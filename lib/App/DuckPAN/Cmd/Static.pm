package App::DuckPAN::Cmd::Static;
BEGIN {
  $App::DuckPAN::Cmd::Static::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::Cmd::Static::VERSION = '0.106';
}
# ABSTRACT: Starting up the static webserver

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;

use Plack::Handler::Starman;

sub run {
	my ( $self, @args ) = @_;

	print "\n\nStarting up static webserver...";
	print "\n\nYou can stop the webserver with Ctrl-C";
	print "\n\n";

	require App::DuckPAN::WebStatic;

	my %sites = (
		duckduckgo => {
			port => 5000,
			url => "http://duckduckgo.com/",
		},
		dontbubbleus => {
			port => 5001,
			url => "http://dontbubble.us/",
		},
		donttrackus => {
			port => 5002,
			url => "http://donttrack.us/",
		},
		whatisdnt => {
			port => 5003,
			url => "http://whatisdnt.com/",
		},
	);

	for (keys %sites) {
		print "Serving ".$sites{$_}->{url}." on ".$sites{$_}->{port}."\n";
	}

	print "\n\n";

	my $web = App::DuckPAN::WebStatic->new(
		sites => \%sites,
	);
	my @ports = map { $sites{$_}->{port} } keys %sites; 
	exit Plack::Handler::Starman->new(listen => [ map { ":$_" } @ports ])->run(sub { $web->run_psgi(@_) });
}

1;

__END__
=pod

=head1 NAME

App::DuckPAN::Cmd::Static - Starting up the static webserver

=head1 VERSION

version 0.106

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

