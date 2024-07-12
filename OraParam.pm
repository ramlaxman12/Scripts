###################################################################################################
# This package is a part of SysChecker
# It returns ORACLE parameter values
# (c) Maxym Kharchenko maxymkharchenko@yahoo.com
###################################################################################################

package OraParam;
use strict;
use Carp qw(croak);

use ExecSql;

our $AUTOLOAD;

sub AUTOLOAD {
  my $self = shift;
  my $type = ref($self) or croak "$self is not an object";

  my $name = $AUTOLOAD;
  $name =~ s/.*://;   # strip fully-qualified portion
  return if 'DESTROY' eq $name;

  $self->init if ! defined $self->{DATA}
    or (defined $self->{PARTIAL} and $name !~ /$self->{PARTIAL}/)
  ;

  unless (exists $self->{DATA}->{lc($name)} ) {
    croak "Cannot locate parameter: $name";
  }

  return $self->{DATA}->{lc($name)};
}

sub new {
  my $class = shift;
  my $rhModuleVars = {
    DB_CON => undef,
    DATA => undef,
    PARTIAL => undef,
    SOURCE => 'C',
  };

  $rhModuleVars->{DB_CON} = shift;
  my $szSource = shift;
  my $szPattern = shift;
  croak "usage: $class->new('DB_Connection ['S' (for spfile) [, Pattern]]')"
    if ! defined $rhModuleVars->{DB_CON} or ! defined $class;
  $rhModuleVars->{SOURCE} = 'S' if 'S' eq uc($szSource);

  my $self = bless $rhModuleVars, $class;
  if(defined $szPattern) {
    $self->init($szPattern);
    $self->{PARTIAL} = $szPattern;
  }

  return $self;
}

sub init {
  my ($self, $szPattern) = @_;
  my $sql = ExecSql->connect($self->{DB_CON});
  my $szSql = 'SELECT name, replace(value, chr(10), \' \') AS value FROM ';

  $szSql .= ('S' eq $self->{SOURCE}) ? 'v$spparameter' : 'v$system_parameter';

  return if defined $self->{DATA} and ! defined $self->{PARTIAL};

  $szSql .= ' WHERE upper(name) LIKE upper(\'%' . $szPattern . '%\')' if defined($szPattern);

  my $raParams = $sql->selectall_hashref($szSql);
  croak $sql->errstr if 0 != $sql->err;

  $self->{DATA}->{lc($_->{NAME})} = $_->{VALUE} for @$raParams;
  $self->{PARTIAL} = $szPattern;
}

sub list_rh {
  my $self = shift;

  $self->init if ! defined $self->{DATA};

  return $self->{DATA};
}

1;
