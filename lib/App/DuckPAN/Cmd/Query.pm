package App::DuckPAN::Cmd::Query;
BEGIN {
  $App::DuckPAN::Cmd::Query::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::Cmd::Query::VERSION = '0.076';
}

use MooX qw( Options );
with qw( App::DuckPAN::Cmd );

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_ddg;

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	require App::DuckPAN::Query;
	exit App::DuckPAN::Query->run($self->app, @blocks);

}

1;
