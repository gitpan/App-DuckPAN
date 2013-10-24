package App::DuckPAN::Cmd::Env;
BEGIN {
  $App::DuckPAN::Cmd::Env::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::Cmd::Env::VERSION = '0.130';
}
# ABSTRACT: Get or set ENV variables for the plugins

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

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Env - Get or set ENV variables for the plugins

=head1 VERSION

version 0.130

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
