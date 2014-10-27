package App::DuckPAN::Config;
BEGIN {
  $App::DuckPAN::Config::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Configuration class of the duckpan client
$App::DuckPAN::Config::VERSION = '0.157';
use Moo;
use MooX::HasEnv;
use Path::Tiny;
use Config::INI::Reader;
use Config::INI::Writer;

has_env config_path => DUCKPAN_CONFIG_PATH => path($ENV{HOME},'.duckpan');
has config_file => (
	is => 'ro',
	lazy => 1,
	default => sub { shift->config_path->child('config.ini') },
);
has_env cache_path => DUCKPAN_CACHE_PATH => path($ENV{HOME},'.duckpan','cache');

sub set_config {
	my ( $self, $config ) = @_;
	$self->config_path->mkpath unless $self->config_path->is_dir;
	Config::INI::Writer->write_file($config,$self->config_file);
}

sub get_config {
	my ( $self ) = @_;
	return unless $self->config_path->is_dir && $self->config_file->is_file;
	Config::INI::Reader->read_file($self->config_file);
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Config - Configuration class of the duckpan client

=head1 VERSION

version 0.157

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
