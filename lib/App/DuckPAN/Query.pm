package App::DuckPAN::Query;
BEGIN {
  $App::DuckPAN::Query::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Main application/loop for duckpan query
$App::DuckPAN::Query::VERSION = '0.159';
use Moo;

my $query;
my $history_path;

use Data::Printer;
use POE qw( Wheel::ReadLine );

sub run {
	my ( $self, $app, @blocks ) = @_;

	require DDG;
	DDG->import;
	require DDG::Request;
	DDG::Request->import;
	require DDG::Test::Location;
	DDG::Test::Location->import;
	require DDG::Test::Language;
	DDG::Test::Language->import;

	$history_path = $app->cfg->cache_path."/query_history";

	print "\n(Empty query for ending test)\n";
	while (1) {
		
		POE::Session->create(
	      inline_states=> {
	        _start => \&setup_console,
	        got_user_input => \&handle_user_input,
	      }
	    );

	    POE::Kernel->run();

	    last unless $query;
		
		eval {
			my $request = DDG::Request->new(
				query_raw => $query,
				location => test_location_by_env(),
				language => test_language_by_env(),
			);
			my $hit;
			for my $b (@blocks) {
				for ($b->request($request)) {
					$hit = 1;
					print "\n";
					p($_);
					print "\n";
				}
			}
			unless ($hit) {
				print "\nSorry, no hit on your instant answer\n\n";
			}
		};
		if ($@) {
			my $error = $@;
			if ($error =~ m/Malformed UTF-8 character/) {
				print "\n[WARNING] You got a malformed utf8 error message, which normally means\n";
				print "that you try to entered a special character on the query prompt, but your\n";
				print "interface is not properly configured for utf8. Please check out the\n";
				print "documentation of your terminal, ssh client or whatever client you use\n";
				print "to access the shell of this system\n\n";
				print "Here the original error message:\n\n";
			} else {
				print "\nCaught error:\n\n";
			}
			print $error."\n";
		}
	}
	print "\n\n\\_o< Thanks for testing!\n\n";
	return 0;
}

sub handle_user_input {
  my ($input, $exception) = @_[ARG0, ARG1];
  my $console = $_[HEAP]{console};

  exit 0 unless defined $input;

  unless ($input eq ""){
    $console->put("  You entered: $input");
    $console->addhistory($input);
    $console->write_history($history_path);
  }
  $query = $input;
}
 
sub setup_console {
  my $powh_readline = POE::Wheel::ReadLine->new(
    InputEvent => 'got_user_input'
  );
  $powh_readline->bind_key("C-\\", "interrupt");
  $_[HEAP]{console} = $powh_readline;
  $_[HEAP]{console}->read_history($history_path);
  $_[HEAP]{console}->get("Query: ");
}


1;

__END__

=pod

=head1 NAME

App::DuckPAN::Query - Main application/loop for duckpan query

=head1 VERSION

version 0.159

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
