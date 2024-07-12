#!/home/sreekanc/perl-5.8.8/bin/perl -w


use strict;
use MyDB;
use Getopt::Long;
use FindBin;

my $oracle_user;
my $oracle_passwd;
my $oracle_testing_table="DUAL";
my $sysdba=1;
my $diff=1;
my ($db1,$db2,$parameter,$pfile);
#my $sql="select 'role' name,database_role value from v\$database union  select 'host',host_name from v\$instance union select name,nvl(value,'NULL') from v\$spparameter";
my $sql="select 'role' name,database_role value from v\$database union  select 'host',host_name from v\$instance union select a.ksppinm  name, nvl(c.ksppstvl,'NULL') value from x\$ksppi a, x\$ksppsv c where  a.indx = c.indx";

GetOptions("db1=s"=>\$db1,
           "db2=s"=>\$db2,
	   "parameter=s"=>\$parameter,
           "pfile=s"=>\$pfile
);

unless(defined $pfile)
{
$pfile="/home/sreekanc/perl/bin/initfile";
}


unless ( defined $db1 and $db2 ) {
	&usage();
	exit;
}

if ( defined $parameter and $pfile ) {
       print "\n--parameter and --pfile are mutually exclusive options.Check Usage";
	&usage();
	exit;
}


#Read config file

my %myenv=config();
$oracle_user=$myenv{"SYS_USER"};
$oracle_passwd=$myenv{"SYS_PASSWD"};
$ENV{ORACLE_HOME}=$myenv{ORACLE_HOME} unless(defined $ENV{ORACLE_HOME});
$ENV{LD_LIBRARY_PATH}=$myenv{LD_LIBRARY_PATH} unless(defined $ENV{LD_LIBRARY_PATH});

# Connect to $db1 database and get parameters values

my $dbh = loginOracle($db1,$oracle_user,$oracle_passwd,$sysdba);
my $ary_ref_a = $dbh->selectcol_arrayref("$sql", { Columns=>[1,2] });
unless($ary_ref_a) {
		die " Can't execute $sql on $db1 : ERROR $DBI::errstr";
}
my %hash_a = @$ary_ref_a; 
logoffOracle($dbh);

# Connect to $db_b database and get parameters values

$dbh = loginOracle($db2,$oracle_user,$oracle_passwd,$sysdba);
my  $ary_ref_b = $dbh->selectcol_arrayref("$sql", { Columns=>[1,2] });
unless($ary_ref_b) {
	die " Can't execute $sql on $db2 : ERROR $DBI::errstr";
}
my %hash_b = @$ary_ref_b; 

logoffOracle($dbh);

#Compare the parameter values and print report

printf("%s\n","-"x150);
printf("\n%30s%50s%50s\n","PARAMETER","${db1}(${hash_a{role}})","${db2}(${hash_b{role}})");
printf("%30s%50s%50s\n"," ","\(${hash_a{host}}\)","\(${hash_b{host}}\)");
printf("%s\n","-"x150);
if(defined $parameter) {
	unless(defined $hash_a{$parameter} or defined $hash_b{parameter}) {
	}
	printf("%30s%50s%50s\n",$parameter,$hash_a{$parameter},$hash_b{$parameter});
}
if(defined $pfile)  {
	unless(-e $pfile && -r $pfile ) {
		die "$pfile is not readable";
	}
	unless(open(INFILE,"$pfile"))   {
		die "Error opening file $pfile : $!\n";
	}
	my @parameters;
	my $key;
	while(<INFILE>)  {
		$key=$_;
		chomp($key);
		$key=trim($key);
 		unless(defined $hash_a{$key} or defined $hash_b{$key}) {
			next;
		}
	if(defined $diff)
        {	
		printf("%40s%50s%50s\n",$key,$hash_a{$key},$hash_b{$key}) if("$hash_a{$key}" ne "$hash_b{$key}");
	}
	else
	{
	printf("%40s%50s%50s\n",$key,$hash_a{$key},$hash_b{$key});
	}
}
}
sub usage()
{
   print "\nUsage : db_diff --db1 <dbname> --db2 <dbname> \n";
}

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

