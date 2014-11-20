package App::DuckPAN::Cmd::Check;
BEGIN {
  $App::DuckPAN::Cmd::Check::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Command for checking the requirements
$App::DuckPAN::Cmd::Check::VERSION = '0.165';
use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

sub run {
	my ($self) = @_;

	$self->app->empty_cache;
	$self->app->check_requirements; # Exits on missing requirements.
	$self->app->emit_info("EVERYTHING OK! You can now go hacking! :)");
	exit 0;
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Check - Command for checking the requirements

=head1 VERSION

version 0.165

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
