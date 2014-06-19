package App::DuckPAN::Cmd::Check;
BEGIN {
  $App::DuckPAN::Cmd::Check::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Command for checking the requirements
$App::DuckPAN::Cmd::Check::VERSION = '0.144';
use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

sub run {
	my ( $self ) = @_;
	exit 1 unless $self->app->check_app_duckpan;
	if ($self->app->check_requirements) {
		print "\n[ERROR] Check for the requirements failed!! See instructions or reports above\n\n";
		exit 1;
	} else {
		print "\nEVERYTHING OK! You can now go hacking! :)\n\n";
	}
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Check - Command for checking the requirements

=head1 VERSION

version 0.144

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
