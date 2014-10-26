package App::DuckPAN::Cmd::Env;
BEGIN {
  $App::DuckPAN::Cmd::Env::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::Cmd::Env::VERSION = '0.066';
}

use Moo;
extends 'App::DuckPAN::CmdBase::Env';

with qw( App::DuckPAN::Cmd );

sub run {
  my ( $self, $name, $value ) = @_;

  if (!defined $name) {
    $self->show_usage;
  }
  $name = uc($name);
  if (defined $value) {
    if ($name eq 'RM') {
      $self->rm_env($value);
    } else {
      $self->set_env($name,$value);
    }
  } else {
    $self->show_env($name);
  }
  exit 0;
}

1;
