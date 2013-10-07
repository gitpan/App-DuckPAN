package App::DuckPAN::Cmd::Query;
BEGIN {
  $App::DuckPAN::Cmd::Query::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::Cmd::Query::VERSION = '0.121';
}
# ABSTRACT: Command line tool for testing queries and see triggered plugins

use MooX qw( Options );
with qw( App::DuckPAN::Cmd );

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_app_duckpan;
	exit 1 unless $self->app->check_ddg;

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	require App::DuckPAN::Query;
	exit App::DuckPAN::Query->run($self->app, @blocks);

}

1;

__END__
=pod

=head1 NAME

App::DuckPAN::Cmd::Query - Command line tool for testing queries and see triggered plugins

=head1 VERSION

version 0.121

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

