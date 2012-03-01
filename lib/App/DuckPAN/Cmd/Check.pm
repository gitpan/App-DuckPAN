package App::DuckPAN::Cmd::Check;
BEGIN {
  $App::DuckPAN::Cmd::Check::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::Cmd::Check::VERSION = '0.002';
}

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;

sub run {
	my ( $self ) = @_;
	exit 1 unless $self->app->check_requirements;
}

1;
__END__
=pod

=head1 NAME

App::DuckPAN::Cmd::Check

=head1 VERSION

version 0.002

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

