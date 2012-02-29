package App::DuckPAN::Perl;
BEGIN {
  $App::DuckPAN::Perl::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::Perl::VERSION = '0.001';
}

use Moo;
with 'App::DuckPAN::HasApp';

use Config::INI;
use Dist::Zilla::Util;
use Path::Class;
use Config::INI::Reader;
use Config::INI::Writer;
use Data::Dumper;

sub dzil_root { Dist::Zilla::Util->_global_config_root }
sub dzil_config { file(shift->dzil_root,'config.ini') }

sub duckpan_url { 'http://duckpan.org/' }

sub setup {
	my ( $self, %params ) = @_;
	my $config_root = Dist::Zilla::Util->_global_config_root;
	my $config = $self->get_dzil_config;
	$config = {} unless $config;
	$config->{'%Rights'} = {
		license_class => 'Perl_5',
		copyright_holder => $params{name},
	} unless defined $config->{'%Rights'};
	$config->{'%User'} = {
		email => $params{email},
		name => $params{name},
	} unless defined $config->{'%User'};
	$config->{'%DUKGO'} = {
		username => $params{user},
		password => $params{pass},
	};
	$self->set_dzil_config($config);
}

sub duckpan_install {
	my ( $self, @modules ) = @_;
	my $mirror = $self->duckpan_url;
	my $modules_string = join(' ',@modules);
	my $return = system("cpanm --mirror=$mirror --mirror-only $modules_string");
	return $return ? 0 : 1;
}

sub set_dzil_config {
	my ( $self, $config ) = @_;
	$self->dzil_root->mkpath unless -d $self->dzil_root;
	Config::INI::Writer->write_file($config,$self->dzil_config);
}

sub get_dzil_config {
	my ( $self ) = @_;
	return unless -d $self->dzil_root && -f $self->dzil_config;
	Config::INI::Reader->read_file($self->dzil_config);
}

1;

__END__
=pod

=head1 NAME

App::DuckPAN::Perl

=head1 VERSION

version 0.001

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

