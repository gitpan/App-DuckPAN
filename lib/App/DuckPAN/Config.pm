package App::DuckPAN::Config;
BEGIN {
  $App::DuckPAN::Config::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::Config::VERSION = '0.004';
}

use Moo;
use Path::Class;
use Config::INI::Reader;
use Config::INI::Writer;

has config_path => (
	is => 'ro',
	lazy => 1,
	default => sub { defined $ENV{DUCKPAN_CONFIG_PATH} ? $ENV{DUCKPAN_CONFIG_PATH} : dir($ENV{HOME},'.duckpan') },
);

has config_file => (
	is => 'ro',
	lazy => 1,
	default => sub { defined $ENV{DUCKPAN_CONFIG_FILE} ? $ENV{DUCKPAN_CONFIG_FILE} : file(shift->config_path,'config.ini') },
);

sub set_config {
	my ( $self, $config ) = @_;
	$self->config_path->mkpath unless -d $self->config_path;
	Config::INI::Writer->write_file($config,$self->config_file);
}

sub get_config {
	my ( $self ) = @_;
	return unless -d $self->config_path && -f $self->config_file;
	Config::INI::Reader->read_file($self->config_file);
}

1;

__END__
=pod

=head1 NAME

App::DuckPAN::Config

=head1 VERSION

version 0.004

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

