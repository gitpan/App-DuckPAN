package App::DuckPAN::Help;
BEGIN {
  $App::DuckPAN::Help::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::Help::VERSION = '0.104';
}
# ABSTRACT: Contains the main help page

use Moo;

has version => ( is => 'ro', required => 1 );

sub header { my $version = shift->version; return <<"__EOT__"; }

 ____   V$version    _    ____   _    _   _
|  _ \\ _   _  ___| | _|  _ \\ / \\  | \\ | |
| | | | | | |/ __| |/ / |_) / _ \\ |  \\| |
| |_| | |_| | (__|   <|  __/ ___ \\| |\\  |
|____/ \\__,_|\\___|_|\\_\\_| /_/   \\_\\_| \\_|

 Contributing to https://duckduckgo.com/
 =======================================

__EOT__

sub help { return shift->header().<<'__EOT__'; }
Usage:

- duckpan check
    Check if you fulfill all requirements for the development
    environment (this is run automatically during setup)

duckpan installdeps
-------------------
 Install all requirements of the specific DuckDuckHack project (if
 possible), like zeroclickinfo-spice, zeroclickinfo-goodie, duckduckgo
 or community-platform

duckpan query
-------------
 Test goodies and spice interactively on the command line

duckpan server
--------------
 Test spice on a local web server

duckpan env <name> <value>
--------------------------
 Add an environment variable that duckpan will remember. Useful for
 spice API keys. Variables are stored in ~/.duckpan/env.ini

duckpan env rm <name>
---------------------
 Remove an environment variable from duckpan

duckpan poupload
---------------
 Upload a po file to the Community Platform (Translation manager only)

duckpan publisher
---------------
 Live testing of duckduckgo-publisher

duckpan release
---------------
 Release the project of the current directory to DuckPAN [TODO]

duckpan test
------------
 Test your release (this will run automatically before a release)

duckpan release
---------------
 Release the project of the current directory to DuckPAN

__EOT__

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Help - Contains the main help page

=head1 VERSION

version 0.104

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
