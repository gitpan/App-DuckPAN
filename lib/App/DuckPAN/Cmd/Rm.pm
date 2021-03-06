package App::DuckPAN::Cmd::Rm;
BEGIN {
  $App::DuckPAN::Cmd::Rm::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Remove an ENV variable
$App::DuckPAN::Cmd::Rm::VERSION = '0.165';
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

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Rm - Remove an ENV variable

=head1 VERSION

version 0.165

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
