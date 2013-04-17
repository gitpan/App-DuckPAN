package App::DuckPAN::Cmd;
BEGIN {
  $App::DuckPAN::Cmd::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::Cmd::VERSION = '0.068';
}
# ABSTRACT: Base class for commands of DuckPAN

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
