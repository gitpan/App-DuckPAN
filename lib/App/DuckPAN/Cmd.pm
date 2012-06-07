package App::DuckPAN::Cmd;
BEGIN {
  $App::DuckPAN::Cmd::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::Cmd::VERSION = '0.042';
}

use Moo::Role;

requires 'run';

has app => (
	is => 'rw',
);

sub execute {
	my ( $self, $args, $chain ) = @_;
	my $app = shift @{$chain};
	$self->app($app);
	$self->run(@{$args});
}

1;
