package App::DuckPAN::Cmd::Query;
BEGIN {
  $App::DuckPAN::Cmd::Query::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::Cmd::Query::VERSION = '0.035';
}

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Data::Printer;

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_ddg;

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	print "\n(Empty query for ending test)\n";
	while (my $query = $self->app->get_reply( 'Query: ' ) ) {
		my $request = DDG::Request->new( query_raw => $query );
		my $hit;
		for (@blocks) {
			my ($result) = $_->request($request);
			if ($result) {
				$hit = 1;
				print "\n";
				p($result);
				print "\n";
				last;
			}
		}
		unless ($hit) {
			print "\nSorry, no hit on your plugins\n\n";
		}
	}
	print "\n\n\\_o< Thanks for testing!\n\n";
	exit 0;
}

1;

__END__
=pod

=head1 NAME

App::DuckPAN::Cmd::Query

=head1 VERSION

version 0.035

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

