package App::DuckPAN::Cmd::Roadrunner;
BEGIN {
  $App::DuckPAN::Cmd::Roadrunner::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Install requirements as fast as possible
$App::DuckPAN::Cmd::Roadrunner::VERSION = '0.165';
use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Time::HiRes qw( usleep );

sub run {
	my ( $self, @args ) = @_;

	if (-f 'dist.ini') {
		$self->app->emit_info("Found a dist.ini, suggesting a Dist::Zilla distribution");
		$self->app->perl->cpanminus_install_error
			if (system("dzil authordeps --missing 2>/dev/null | grep -ve '^\\W' | cpanm --quiet --notest --skip-satisfied"));
		$self->app->perl->cpanminus_install_error
			if (system("dzil listdeps --missing 2>/dev/null | grep -ve '^\\W' | cpanm --quiet --notest --skip-satisfied"));
		$self->app->emit_info("Everything fine!");
	} elsif (-f 'Makefile.PL') {
		$self->app->emit_info("Found a Makefile.PL");
		$self->app->perl->cpanminus_install_error
			if (system("cpanm --quiet --notest --skip-satisfied --installdeps ."));
	} elsif (-f 'Build.PL') {
		$self->app->emit_info("Found a Build.PL");
		$self->app->perl->cpanminus_install_error
			if (system("cpanm --quiet --notest --skip-satisfied --installdeps ."));
	}

	$self->app->emit_info("\a"); usleep 225000; $self->app->emit_info("\a");

}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Roadrunner - Install requirements as fast as possible

=head1 VERSION

version 0.165

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
