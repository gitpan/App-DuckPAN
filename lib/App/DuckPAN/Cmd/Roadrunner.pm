package App::DuckPAN::Cmd::Roadrunner;
BEGIN {
  $App::DuckPAN::Cmd::Roadrunner::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::Cmd::Roadrunner::VERSION = '0.074';
}

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Time::HiRes qw( usleep );

sub run {
	my ( $self, @args ) = @_;

	if (-f 'dist.ini') {
		$self->app->print_text(
			"Found a dist.ini, suggesting a Dist::Zilla distribution",
		);
		$self->app->perl->cpanminus_install_error
			if (system("dzil authordeps --missing 2>/dev/null | grep -vP '[^\\w:]' | cpanm --quiet --notest --skip-satisfied"));
		$self->app->perl->cpanminus_install_error
			if (system("dzil listdeps --missing 2>/dev/null | grep -vP '[^\\w:]' | cpanm --quiet --notest --skip-satisfied"));
		$self->app->print_text(
			"Everything fine!",
		);

		print "\a"; usleep 225000; print "\a";
	}

}

1;

__END__
=pod

=head1 NAME

App::DuckPAN::Cmd::Roadrunner

=head1 VERSION

version 0.074

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

