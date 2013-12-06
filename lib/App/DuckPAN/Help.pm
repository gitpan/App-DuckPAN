package App::DuckPAN::Help;
BEGIN {
  $App::DuckPAN::Help::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::Help::VERSION = '0.133';
}
# ABSTRACT: Contains the main help page

use Moo;
use Pod::Usage;

sub help { pod2usage(verbose => 2); }

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Help - Contains the main help page

=head1 VERSION

version 0.133

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
