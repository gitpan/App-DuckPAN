package App::DuckPAN::Cmd::Installdeps;
BEGIN {
  $App::DuckPAN::Cmd::Installdeps::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Regular way to install requirements with tests
$App::DuckPAN::Cmd::Installdeps::VERSION = '0.141';
use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

sub run {
	my ( $self, @args ) = @_;

	if (-f 'dist.ini') {
		$self->app->print_text(
			"Found a dist.ini, suggesting a Dist::Zilla distribution",
		);
		$self->app->perl->cpanminus_install_error
			if (system("dzil authordeps --missing 2>/dev/null | grep -ve '^\\W' | cpanm"));
		$self->app->perl->cpanminus_install_error
			if (system("dzil listdeps --missing 2>/dev/null | grep -ve '^\\W' | cpanm"));
		$self->app->print_text(
			"Everything fine!",
		);
	}

}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Installdeps - Regular way to install requirements with tests

=head1 VERSION

version 0.141

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
