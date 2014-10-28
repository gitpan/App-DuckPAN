package App::DuckPAN::Cmd::Query;
BEGIN {
  $App::DuckPAN::Cmd::Query::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Command line tool for testing queries and see triggered instant answers
$App::DuckPAN::Cmd::Query::VERSION = '0.160';
use MooX;
use MooX::Options protect_argv => 0;
with qw( App::DuckPAN::Cmd );

sub run {
	my ( $self, @args ) = @_;

	$self->app->verify_versions;
	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	require App::DuckPAN::Query;
	exit App::DuckPAN::Query->run($self->app, @blocks);

}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Query - Command line tool for testing queries and see triggered instant answers

=head1 VERSION

version 0.160

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
