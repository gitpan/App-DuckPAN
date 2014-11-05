package App::DuckPAN::Perl;
BEGIN {
  $App::DuckPAN::Perl::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Perl related functionality for duckpan
$App::DuckPAN::Perl::VERSION = '0.154';
use Moo;
with 'App::DuckPAN::HasApp';

use Config::INI;
use Dist::Zilla::Util;
use Path::Class;
use Config::INI::Reader;
use Config::INI::Writer;
use Data::Dumper;
use LWP::Simple;
use List::Util qw/ first /;
use File::Temp qw/ :POSIX /;
use version;
use Parse::CPAN::Packages::Fast;
use Class::Load ':all';

sub dzil_root { Dist::Zilla::Util->_global_config_root }
sub dzil_config { file(shift->dzil_root,'config.ini') }

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

sub get_local_version {
	my ( $self, $module ) = @_;
	require Module::Data;
	my $v;
	{
		local $@;
		eval {
			my $m = Module::Data->new( $module );
			$m->require;
			$v = $m->version;
			1
		} or return;
	};
	return unless defined $v;
	return version->parse($v) unless ref $v;
	return $v;
}

sub cpanminus_install_error {
	shift->app->print_text(
		"[ERROR] Failure on installation of modules!",
        "There are several possible explanations and fixes for this error:",
        "1. The download from CPAN was unsuccessful - Please restart this installer.",
        "2. Some other error occured - Please read the `build.log` mentioned in the errors and see if you can fix the problem yourself.",
        "If you are unable to solve the problem, please let us know by making a GitHub Issue in the DuckPAN Repo:",
        "https://github.com/duckduckgo/p5-app-duckpan/issues",
        "Make sure to attach the `build.log` file if it exists. Otherwise, copy/paste the output you see."
	);
	exit 1;	
}

sub duckpan_install {
	my ( $self, @modules ) = @_;
	my $mirror = $self->app->duckpan;
	my $force_install;
	if ($modules[0] eq 'force') {
		# We sent in a signal to force installation
		$force_install = 1;
		shift @modules;
	}
	my $modules_string = join(' ',@modules);
	my $tempfile = tmpnam;
	if (is_success(getstore($self->app->duckpan_packages,$tempfile))) {
		my $packages = Parse::CPAN::Packages::Fast->new($tempfile);
		my @to_install;
		my $error = 0;
		for (@modules) {
			my $module = $packages->package($_);
			if ($module) {
				local $@;

				# see if we have an env variable for this module
				my $sp = $_;
				$sp =~ s/\:\:/_/g;

				# special case: check for a pinned verison number
				my $pin_version = $ENV{$sp};
				my $localver = $self->get_local_version($_);
				my $duckpan_module_version = version->parse($module->version);
				my $duckpan_module_url = $self->app->duckpan.'authors/id/'.$module->distribution->pathname;

				my $install_it;
				if ($force_install) {
					$install_it = 1;
				} elsif ($pin_version && $localver) {
					print "$_: $localver installed, $pin_version pin, $duckpan_module_version latest\n";
					if ($pin_version > $localver && $duckpan_module_version > $localver && $duckpan_module_version <= $pin_version) {
						$install_it = 1;
					}
				} elsif ($localver && $localver == $duckpan_module_version) {
					$self->app->print_text("You already have latest version of ".$_." with ".$localver."\n");
				} elsif ($localver && $localver > $duckpan_module_version) {
					$self->app->print_text("You have a newer version of ".$_." with ".$localver." (duckpan has ".$duckpan_module_version.")\n");
				} else {
					$install_it = 1;
				}
				push @to_install, $duckpan_module_url if ($install_it && !(first { $_ eq $duckpan_module_url } @to_install));
			} else {
				$self->app->print_text("[ERROR] Can't find package ".$_." on ".$self->app->duckpan."\n");
				$error = 1;
			}
		}
		return 1 if $error;
		return 0 unless @to_install;
		unshift @to_install,'-f'  if ($force_install); # cpanm will do the actual forcing.
		return system("cpanm ".join(" ",@to_install));
	} else {
		$self->app->print_text("[ERROR] Can't reach duckpan at ".$self->app->duckpan."!\n");
		return 1;
	}
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

App::DuckPAN::Perl - Perl related functionality for duckpan

=head1 VERSION

version 0.154

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
