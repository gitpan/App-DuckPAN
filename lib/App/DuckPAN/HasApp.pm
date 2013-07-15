package App::DuckPAN::HasApp;
BEGIN {
  $App::DuckPAN::HasApp::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::HasApp::VERSION = '0.112';
}
# ABSTRACT: Simple role for classes which carry an object of App::DuckPAN

use Moo::Role;

has app => (
	is => 'rw',
	required => 1,
);

1;

__END__

=pod

=head1 NAME

App::DuckPAN::HasApp - Simple role for classes which carry an object of App::DuckPAN

=head1 VERSION

version 0.112

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
