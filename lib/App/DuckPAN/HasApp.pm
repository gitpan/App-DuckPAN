package App::DuckPAN::HasApp;
BEGIN {
  $App::DuckPAN::HasApp::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::HasApp::VERSION = '0.068';
}
# ABSTRACT: Simple role for classes which carry an object of App::DuckPAN

use Moo::Role;

has app => (
	is => 'rw',
	required => 1,
);

1;
