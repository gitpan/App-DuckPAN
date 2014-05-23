package App::DuckPAN::Cmd::Publisher;
BEGIN {
  $App::DuckPAN::Cmd::Publisher::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Starting up the publisher test webserver
$App::DuckPAN::Cmd::Publisher::VERSION = '0.140';
use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

use Path::Class;
use Plack::Handler::Starman;

for (qw( duckduckgo dontbubbleus donttrackus whatisdnt fixtracking duckduckhack )) {
	option $_ => (
		is => 'ro',
		format => 's',
		predicate => 1,
	);
}

sub run {
	my ( $self, @args ) = @_;

	print "\n\nChecking for Publisher...\n";

	my $publisher_pm = file('lib','DDG','Publisher.pm')->absolute;
	die "You must be in the root of the duckduckgo-publisher repository" unless -f $publisher_pm;

	print "\n\nStarting up publisher webserver...";
	print "\n\nYou can stop the webserver with Ctrl-C";
	print "\n\n";

	my %sites = (
		duckduckgo => {
			port => 5000,
			url => $self->has_duckduckgo ? $self->duckduckgo : "http://duckduckgo.com/",
		},
		dontbubbleus => {
			port => 5001,
			url => $self->has_dontbubbleus ? $self->dontbubbleus : "http://dontbubble.us/",
		},
		donttrackus => {
			port => 5002,
			url => $self->has_donttrackus ? $self->donttrackus : "http://donttrack.us/",
		},	
		whatisdnt => {
			port => 5003,
			url => $self->has_whatisdnt ? $self->whatisdnt : "http://whatisdnt.com/",
		},
		fixtracking => {
			port => 5004,
			url => $self->has_fixtracking ? $self->fixtracking : "http://fixtracking.com/",
		},
		duckduckhack => {
			port => 5005,
			url => $self->has_duckduckhack ? $self->duckduckhack : "http://duckduckhack.com/",
		},
	);

	for (sort { $sites{$a}->{port} <=> $sites{$b}->{port} } keys %sites) {
		print "Serving on port ".$sites{$_}->{port}.": ".$sites{$_}->{url}."\n";
	}

	print "\n\n";

	require App::DuckPAN::WebPublisher;
	my $web = App::DuckPAN::WebPublisher->new(
		app => $self->app,
		sites => \%sites,
	);
	my @ports = map { $sites{$_}->{port} } keys %sites; 
	exit Plack::Handler::Starman->new(listen => [ map { ":$_" } @ports ])->run(sub { $web->run_psgi(@_) });
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Publisher - Starting up the publisher test webserver

=head1 VERSION

version 0.140

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
