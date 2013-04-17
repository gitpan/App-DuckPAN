package App::DuckPAN::Cmd::Rm;
BEGIN {
  $App::DuckPAN::Cmd::Rm::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::Cmd::Rm::VERSION = '0.068';
}

use Moo;
extends 'App::DuckPAN::CmdBase::Env';

with qw( App::DuckPAN::Cmd );

sub run {
  my ( $self, $name ) = @_;

  if (!defined $name) {
    $self->show_usage;
  } else {
    $self->rm_env($name);
  }
  exit 0;
}

1;
