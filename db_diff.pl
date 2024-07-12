#! /usr/bin/perl -w

# Display parameter difference between two databases
# See usage() for parameters
# Maxym Kharchenko, 2011

use strict;
use warnings;

use File::Basename qw(basename);
use Getopt::Std;
use Carp qw(croak);

use FindBin qw($Bin);
use lib "$Bin";

use OraParam;
use OraSingleRow;

# Program version
my $SCRIPT_VERSION = 0.30;

# ----------------------------------------------------------------------------
# CONSTANTS
# ----------------------------------------------------------------------------
# Default db connection
use constant DEF_DB_USER => 'sys';
use constant DEF_DB_PASSWORD => 'asop4u';

# Execution status
use constant STATUS_SAME => 'SAME';
use constant STATUS_DIFFERENT => 'DIFFERENT';

# Comparison types
use constant COMPARISON_SAME => 'SAME';
use constant COMPARISON_DIFFERENT => 'PRIMARY/STANDBY';

# What to check
use constant WTC_CURRENT => 'CURRENT';
use constant WTC_SPFILE => 'SPFILE';

# Executions modes
use constant M_INTERACTIVE => 'INTERACTIVE';
use constant M_SCRIPT => 'SCRIPT';

# ----------------------------------------------------------------------------
# SCRIPT OPTIONS AND VARIABLES
# ----------------------------------------------------------------------------
my $g_rhScriptVars = {
  DB_1 => undef,
  DB_2 => undef,
  PATTERN => undef,
  SHOW_SAME => 'N',
  MODE => M_INTERACTIVE,
  EMAIL => undef,
  STATUS => undef,
  COMPARISON_TYPE => undef,
  WHAT_TO_CHECK => WTC_CURRENT,
  OUTPUT => undef,
};

# ----------------------------------------------------------------------------
# Print program header
# ----------------------------------------------------------------------------
sub PrintHeader
{
   return if M_SCRIPT eq $g_rhScriptVars->{MODE};

   print <<EOM
ORACLE Database Parameter Comparison Utility
(c) 2011 - Maxym Kharchenko, Amazon.com
Version: $SCRIPT_VERSION

EOM
;
}
 

# ----------------------------------------------------------------------------
# Print usage message
# ----------------------------------------------------------------------------
sub usage
{
   die <<EOM
usage: dbdiff.pl -S standby_name | -p primary_db_conn -s secondary_db_conn
  [-f] [-a] [-P <pattern>] [-e email\@address] [-z]
  | -h

where: 
   -S Primary-Standby check. Assumes standard Amazon _a _b standby names

   -p Primary database
   -s Secondary database

      Databases can be defined as:

      - user/password\@tns
      OR
      - db_name (default user/password will be used)

Optional Parameters:
   -f Check spfile (by default, current parameters are checked)
   -a Show all parameters (including the same)
   -P Show only parameters that match the <pattern>
   -e Email results
   -z Silent (script) mode

   -h Print usage message
EOM
;
}

# ----------------------------------------------------------------------------
# Parse command line
# ----------------------------------------------------------------------------
sub ParseCmdLine
{
  my %Options;

  usage if -1 == $#ARGV;
  ODExit("Flag is not supported")
     if ! Getopt::Std::getopts('S:p:s:P:e:fazh', \%Options);
  usage() if exists $Options{h};

  croak("Options -S and [-p|-s] are mutually exclusive")
    if exists $Options{S} and (exists $Options{p} or exists $Options{s});

  my $cDbs = 0;
  $cDbs++ if exists $Options{p}; $cDbs++ if exists $Options{s}; 
  croak("Both primary and secondary database needs to be specified for comparison")
    if ! exists $Options{S} and $cDbs < 2;

  if(exists $Options{p}) {
    $g_rhScriptVars->{DB_1}->{CONN} = ($Options{p} =~ /@/) ?
      $Options{p} : DEF_DB_USER . '/' . DEF_DB_PASSWORD . '@' . $Options{p};
    $g_rhScriptVars->{DB_1}->{TNS} = $Options{p};
  }
  if(exists $Options{s}) {
    $g_rhScriptVars->{DB_2}->{CONN} = ($Options{s} =~ /@/) ?
      $Options{s} : DEF_DB_USER . '/' . DEF_DB_PASSWORD . '@' . $Options{s};
    $g_rhScriptVars->{DB_2}->{TNS} = $Options{s};
  }
  if(exists $Options{S}) {
    my $szDbCon = DEF_DB_USER . '/' . DEF_DB_PASSWORD . '@' . $Options{S};
    $g_rhScriptVars->{DB_1}->{CONN} = $szDbCon . '_a';
    $g_rhScriptVars->{DB_1}->{TNS} = $Options{S} . "_a";
    $g_rhScriptVars->{DB_2}->{CONN} = $szDbCon . '_b';
    $g_rhScriptVars->{DB_2}->{TNS} = $Options{S} . "_b";
  }

  $g_rhScriptVars->{WHAT_TO_CHECK} = WTC_SPFILE if exists $Options{f};
  $g_rhScriptVars->{MODE} = M_SCRIPT if exists $Options{z};
  $g_rhScriptVars->{PATTERN} = $Options{P} if exists $Options{P};
  $g_rhScriptVars->{EMAIL} = $Options{e} if exists $Options{e};
  $g_rhScriptVars->{SHOW_SAME} = 'Y' if exists $Options{a};
}

# ----------------------------------------------------------------------------
# Make an intelligent trim of parameter string
# Parameters:
# 1 - String to trim
# 2 - Trim length
# ----------------------------------------------------------------------------
sub SmartTrim {
  my ($szStr, $nLen) = @_;
  croak "Invalid # of parameters in SmartTrim()" if ! defined $szStr or ! defined $nLen;

  return (length($szStr) > $nLen) ? substr($szStr, 0, $nLen-2) . '..': $szStr;
}

# ----------------------------------------------------------------------------
# Find comparison type
# ----------------------------------------------------------------------------
sub FindComparisonType {
  my ($szDbType1, $szDbType2) =
    ($g_rhScriptVars->{DB_1}->{DATABASE_ROLE}, $g_rhScriptVars->{DB_2}->{DATABASE_ROLE});
  my ($szDbName1, $szDbName2) =
    ($g_rhScriptVars->{DB_1}->{NAME}, $g_rhScriptVars->{DB_2}->{NAME});

  $g_rhScriptVars->{COMPARISON_TYPE} = 
    (($szDbType1 eq $szDbType2) or ($szDbName1 ne $szDbName2)) ?
     COMPARISON_SAME : COMPARISON_DIFFERENT;
}

# ----------------------------------------------------------------------------
# Get data for comparison
# ----------------------------------------------------------------------------
sub GetData {
  my $szSource = (WTC_SPFILE eq $g_rhScriptVars->{WHAT_TO_CHECK}) ? 'S' : 'C';
  my $rh1 = $g_rhScriptVars->{DB_1};
  my $rh2 = $g_rhScriptVars->{DB_2};

  eval {
    my $db1 = OraSingleRow->new($rh1->{CONN}, 'v$database');
    my $db2 = OraSingleRow->new($rh2->{CONN}, 'v$database');
    my $p1 = OraParam->new($rh1->{CONN}, $szSource, $g_rhScriptVars->{PATTERN});
    my $p2 = OraParam->new($rh2->{CONN}, $szSource, $g_rhScriptVars->{PATTERN});

    $rh1->{NAME} = $db1->name; $rh1->{DB_UNIQUE_NAME} = $db1->db_unique_name;
    $rh1->{DATABASE_ROLE} = $db1->database_role; $rh1->{PARAMS} = $p1->list_rh;
    $rh2->{NAME} = $db2->name; $rh2->{DB_UNIQUE_NAME} = $db2->db_unique_name;
    $rh2->{DATABASE_ROLE} = $db2->database_role; $rh2->{PARAMS} = $p2->list_rh;
  };
  if($@) {
    print "ERROR comparing databases: " . $rh1->{TNS} . ", " . $rh2->{TNS} . "\n";
    print $@ . "\n";
    exit(-1);
  }
  
  FindComparisonType;
  $g_rhScriptVars->{DB_1} = AdjustData($rh1);
  $g_rhScriptVars->{DB_2} = AdjustData($rh2);
}

# ----------------------------------------------------------------------------
# Adjust data (remove unnecessary details)
# Parameters:
# 1 - Parameter hash
# Returns: Adjusted parameter hash
# ----------------------------------------------------------------------------
sub AdjustData {
  my $rhDb = shift;
  croak 'Invalid # of parameters in AdjustData()' if ! defined $rhDb;

  my $szDbName = $rhDb->{NAME};
  my $szDbUniqueName = $rhDb->{DB_UNIQUE_NAME};
  my $rhParams = $rhDb->{PARAMS};

  my $szParametersToSkip = 'db_unique_name|service_names|fal_client|fal_server|resource_manager_plan|log_archive_dest_\d+';

  my $rhReplacePatterns = {
    'audit_file_dest'        => "$szDbUniqueName|$szDbName",
    'background_dump_dest'   => "$szDbUniqueName|$szDbName",
    'control_files'          => "$szDbUniqueName|$szDbName",
    'core_dump_dest'         => "$szDbUniqueName|$szDbName",
    'db_name'                => "$szDbName",
    'instance_name'          => "$szDbUniqueName|$szDbName",
    'user_dump_dest'         => "$szDbUniqueName|$szDbName",
    'utl_file_dir'           => "$szDbUniqueName|$szDbName",
  };

  my $rhLoopPatterns = {};

  # Adjust for comparison type
  if(COMPARISON_SAME eq $g_rhScriptVars->{COMPARISON_TYPE}) {
    # Same db type comparison
    $rhLoopPatterns->{dispatchers} = '(dispatchers=\d+)';

    $rhReplacePatterns->{dg_broker_config_file1} = "$szDbUniqueName|$szDbName";
    $rhReplacePatterns->{dg_broker_config_file2} = "$szDbUniqueName|$szDbName";
    $rhReplacePatterns->{spfile}                 = "$szDbUniqueName|$szDbName";

    $szParametersToSkip .= '|local_listener';
  } else {
    # Primary/standby
    $rhLoopPatterns->{dispatchers} = '(dispatchers=\d+|port=\d+)';
    $rhLoopPatterns->{local_listener} = '(port=\d+)';

    $rhReplacePatterns->{dg_broker_config_file1} = 'A\d+db|' . "$szDbUniqueName|$szDbName";
    $rhReplacePatterns->{dg_broker_config_file2} = 'A\d+db|' . "$szDbUniqueName|$szDbName";
    $rhReplacePatterns->{spfile}                 = 'A\d+db|' . "$szDbUniqueName|$szDbName";

    $szParametersToSkip .= '|log_archive_dest_state_\d+|audit_trail';
  }

  delete $rhParams->{$_} for
    grep {$_ =~ /$szParametersToSkip/;} keys %$rhParams;

  $rhParams->{$_} =~ s/$rhReplacePatterns->{$_}/DUMMY/ig for
    grep {exists($rhReplacePatterns->{$_});} keys %$rhParams;

  foreach my $szKey (grep {exists($rhLoopPatterns->{$_});} keys %$rhParams) {
    my $szNewPat;
    while($rhParams->{$szKey} =~ /$rhLoopPatterns->{$szKey}/ig) { $szNewPat .= " $1"; } 
    $rhParams->{$szKey} = $szNewPat;
  }

  $rhDb->{PARAMS} = $rhParams;

  return $rhDb;
}

# ----------------------------------------------------------------------------
# Compare parameter data
# ----------------------------------------------------------------------------
sub CompData {
  my $p1 = $g_rhScriptVars->{DB_1}->{PARAMS};
  my $p2 = $g_rhScriptVars->{DB_2}->{PARAMS};
  my $diff;

  my $szWarningsOnly = 'log_archive_config|audit_trail|cpu_count';

  foreach my $szParam (keys %$p1) {
    if(exists($p1->{$szParam}) and defined ($p1->{$szParam})
       and exists($p2->{$szParam}) and defined($p2->{$szParam})
      ) {
      if(uc($p1->{$szParam}) eq uc($p2->{$szParam})) {
        $diff->{SAME}->{$szParam} = 1;
      } else {
        if ($szParam =~ /$szWarningsOnly/) {
          $diff->{WARN}->{$szParam} = 1;
        } else {
          $diff->{DIFF}->{$szParam} = 1;
        }
      }
    } elsif(! exists($p2->{$szParam})) {
      $diff->{ONLY_IN_1}->{$szParam} = 1;
    }
  }

  foreach my $szParam (keys %$p2) {
    $diff->{ONLY_IN_2}->{$szParam} = 1 if ! exists $p1->{$szParam};
  }

  $g_rhScriptVars->{CMP} = $diff;
}

# ----------------------------------------------------------------------------
# Find "difference status"
# ----------------------------------------------------------------------------
sub FindStatus {
  my $cmp = $g_rhScriptVars->{CMP};

  $g_rhScriptVars->{STATUS} = STATUS_DIFFERENT;

  $g_rhScriptVars->{STATUS} = STATUS_SAME
    if (0 == scalar keys %{$cmp->{DIFF}})
      and (0 == scalar keys %{$cmp->{ONLY_IN_1}})
      and (0 == scalar keys %{$cmp->{ONLY_IN_2}})
  ;
}

# ----------------------------------------------------------------------------
# Email differences
# ----------------------------------------------------------------------------
sub EmailDiff {
  my $szBody = $g_rhScriptVars->{OUTPUT};
  croak "Empty message body in EmailDiff()" if ! defined $szBody;
  croak "Email TO address is NOT defined EmailDiff()" if ! defined $g_rhScriptVars->{EMAIL};
  my $szSubj = 'PARAMETER CHECK: ';
  $szSubj .= (STATUS_SAME eq $g_rhScriptVars->{STATUS}) ? 'OK' : 'DIFFERENCES DETECTED!';
  $szSubj .= ' [' . $g_rhScriptVars->{DB_1}->{DB_UNIQUE_NAME} . '/' .
    $g_rhScriptVars->{DB_2}->{DB_UNIQUE_NAME} . ']';
   
  my $sendmail = '/usr/lib/sendmail';

  open(MAIL, "|$sendmail -oi -t");
  print MAIL "From: oracle\@amazon.com\n";
  print MAIL "To: " . $g_rhScriptVars->{EMAIL} . "\n";
  print MAIL "Subject: $szSubj\n\n";
  print MAIL "$szBody\n";
  close(MAIL);
}

# ----------------------------------------------------------------------------
# Print parameter differences
# ----------------------------------------------------------------------------
sub PrintDiff {
  if(M_SCRIPT eq $g_rhScriptVars->{MODE}) {
    PrintDiffScript();
  } else {
    PrintDiffInteractive();
  }
}

# ----------------------------------------------------------------------------
# Print parameter differences (interactive mode)
# ----------------------------------------------------------------------------
sub PrintDiffScript {
  my ($d1, $d2) = ($g_rhScriptVars->{DB_1}, $g_rhScriptVars->{DB_2});
  my ($p1, $p2) = ($d1->{PARAMS}, $d2->{PARAMS});
  my $cmp = $g_rhScriptVars->{CMP};
  my $szOut = '';

  if(STATUS_DIFFERENT eq $g_rhScriptVars->{STATUS}) {
    if(('Y' eq $g_rhScriptVars->{SHOW_SAME}) and exists($cmp->{SAME})) {
      foreach my $szParam (sort keys %{$cmp->{SAME}}) {
        $szOut .= '  SAME' . ':' . $szParam . ':' . SmartTrim($p1->{$szParam}, 80) . "\n";
      }
    }

    foreach my $szParam (sort keys %{$cmp->{DIFF}}) {
      $szOut .= '  DIFF' . ':' . $szParam . ':' .
        SmartTrim($p1->{$szParam}, 80) . ':' . SmartTrim($p2->{$szParam}, 80) . "\n";
    }

    foreach my $szParam (sort keys %{$cmp->{ONLY_IN_1}}) {
      $szOut .= '  ONLY_IN_1' . ':' . $d1->{DB_UNIQUE_NAME} . ':' . 
        $szParam . ':' . SmartTrim($p1->{$szParam}, 80) . "\n";
    }

    foreach my $szParam (sort keys %{$cmp->{ONLY_IN_2}}) {
      $szOut .= '  ONLY_IN_2' . ':' . $d2->{DB_UNIQUE_NAME} . ':' . 
        $szParam . ':' . SmartTrim($p2->{$szParam}, 80) . "\n";
    }
  }

  print $szOut;
  $g_rhScriptVars->{OUTPUT} = $szOut;
}

# ----------------------------------------------------------------------------
# Print parameter differences (interactive mode)
# ----------------------------------------------------------------------------
sub PrintDiffInteractive {
  my ($d1, $d2) = ($g_rhScriptVars->{DB_1}, $g_rhScriptVars->{DB_2});
  my ($p1, $p2) = ($d1->{PARAMS}, $d2->{PARAMS});
  my $cmp = $g_rhScriptVars->{CMP};
  my $szOut = '';

  $szOut = "====== COMPARING DATABASES: [Type: " . $g_rhScriptVars->{COMPARISON_TYPE} . " FROM " .
    ((WTC_SPFILE eq $g_rhScriptVars->{WHAT_TO_CHECK}) ? 'v$spparameter' : 'v$system_parameter') . "]\n\n";
  $szOut .= $d1->{NAME} . " [" . $d1->{DB_UNIQUE_NAME} . "] " . $d1->{DATABASE_ROLE} . "\n";
  $szOut .= "AND\n";
  $szOut .= $d2->{NAME} . " [" . $d2->{DB_UNIQUE_NAME} . "] " . $d2->{DATABASE_ROLE} . "\n";
 

  if(STATUS_DIFFERENT eq $g_rhScriptVars->{STATUS}) {
    if(('Y' eq $g_rhScriptVars->{SHOW_SAME}) and exists($cmp->{SAME})) {
      $szOut .= "\n====== Parameters that are the SAME:\n\n";
      foreach my $szParam (sort keys %{$cmp->{SAME}}) {
        $szOut .= sprintf "  %-60s\n", $szParam;
        $szOut .= sprintf "    %-10s: %-80s\n",
          $g_rhScriptVars->{DB_1}->{DB_UNIQUE_NAME}, SmartTrim($p1->{$szParam}, 80);
        $szOut .= sprintf "    %-10s: %-80s\n",
          $g_rhScriptVars->{DB_2}->{DB_UNIQUE_NAME}, SmartTrim($p2->{$szParam}, 80);
      }
    }

    $szOut .= "\n====== Parameters that are different:\n\n" if exists $cmp->{DIFF};
    foreach my $szParam (sort keys %{$cmp->{DIFF}}) {
      $szOut .= sprintf "  %-60s\n", $szParam;
      $szOut .= sprintf "    %-10s: %-80s\n",
        $g_rhScriptVars->{DB_1}->{DB_UNIQUE_NAME}, SmartTrim($p1->{$szParam}, 80);
      $szOut .= sprintf "    %-10s: %-80s\n",
        $g_rhScriptVars->{DB_2}->{DB_UNIQUE_NAME}, SmartTrim($p2->{$szParam}, 80);
    }

    $szOut .= "\n====== Parameters that only exist in " . $g_rhScriptVars->{DB_1}->{DB_UNIQUE_NAME} .
      ":\n\n" if exists $cmp->{ONLY_IN_1};
    foreach my $szParam (sort keys %{$cmp->{ONLY_IN_1}}) {
      $szOut .= sprintf "  %-60s\n", $szParam;
      $szOut .= sprintf "    %-80s\n", SmartTrim($p1->{$szParam}, 80);
    }

    $szOut .= "\n====== Parameters that only exist in " . $g_rhScriptVars->{DB_2}->{DB_UNIQUE_NAME} .
      ":\n\n" if exists $cmp->{ONLY_IN_2};
    foreach my $szParam (sort keys %{$cmp->{ONLY_IN_2}}) {
      $szOut .= sprintf "  %-60s\n", $szParam;
      $szOut .= sprintf "    %-80s\n", SmartTrim($p2->{$szParam}, 80);
    }
  } else {
    $szOut = "\nNO DIFFERENCES DETECTED\n";
  }

  print $szOut;
  $g_rhScriptVars->{OUTPUT} = $szOut;
}

# ----------------------------------------------------------------------------
# Return number of differences found
# ----------------------------------------------------------------------------
sub GetNumberOfDiffs {
  my $cmp = $g_rhScriptVars->{CMP};
  my $nRet = 0;

  $nRet += scalar keys %{$cmp->{DIFF}} if exists $cmp->{DIFF};
  $nRet += scalar keys %{$cmp->{ONLY_IN_1}} if exists $cmp->{ONLY_IN_1};
  $nRet += scalar keys %{$cmp->{ONLY_IN_2}} if exists $cmp->{ONLY_IN_2};

  return $nRet;
}

###################### MAIN PROGRAM BEGINS HERE ###################################

ParseCmdLine;
PrintHeader;
GetData;
CompData;
FindStatus;
PrintDiff;
EmailDiff if defined $g_rhScriptVars->{EMAIL};
exit(GetNumberOfDiffs);
