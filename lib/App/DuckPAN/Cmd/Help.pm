package App::DuckPAN::Cmd::Help;
BEGIN {
  $App::DuckPAN::Cmd::Help::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Launch help page
$App::DuckPAN::Cmd::Help::VERSION = '0.165';
use Moo;
with qw( App::DuckPAN::Cmd );
use Pod::Usage qw(pod2usage);

sub run {
	my ($self, $short_output) = @_;


	pod2usage(-verbose => 2) unless $short_output;
	pod2usage(-verbose => 1);
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Help - Launch help page

=head1 VERSION

version 0.165

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
