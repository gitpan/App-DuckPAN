package App::DuckPAN::Cmd::Goodie;
BEGIN {
  $App::DuckPAN::Cmd::Goodie::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: DEPRECATED
$App::DuckPAN::Cmd::Goodie::VERSION = '0.148';
use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;
use Module::Pluggable::Object;
use Class::Load ':all';
use Data::Printer;

sub run {
	my ( $self, @args ) = @_;
        print "\n[DEPRECATED] Please use \"duckpan query\"!\n";
        exit 1;
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Goodie - DEPRECATED

=head1 VERSION

version 0.148

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
