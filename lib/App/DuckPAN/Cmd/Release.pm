package App::DuckPAN::Cmd::Release;
BEGIN {
  $App::DuckPAN::Cmd::Release::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::Cmd::Release::VERSION = '0.060';
}

use MooX qw( Options );
with qw( App::DuckPAN::Cmd );

sub run {
    my ( $self ) = @_;

    my $ret = system('dzil release');

    print STDERR '[ERROR] Could not begin release. Is Dist::Zilla installed?'
      if $ret == -1;

    return $ret;
}

1;
