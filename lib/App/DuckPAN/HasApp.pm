package App::DuckPAN::HasApp;
BEGIN {
  $App::DuckPAN::HasApp::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::HasApp::VERSION = '0.042';
}

use Moo::Role;

has app => (
	is => 'rw',
	required => 1,
);

1;
