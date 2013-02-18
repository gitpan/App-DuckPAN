package App::DuckPAN;
BEGIN {
  $App::DuckPAN::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::VERSION = '0.062';
}
# ABSTRACT: The DuckDuckGo DuckPAN client

use Moo;
use MooX::Cmd;
use MooX::Options;
use App::DuckPAN::Config;
use App::DuckPAN::Help;
use File::Which;
use Class::Load ':all';
use HTTP::Request::Common qw( GET POST );
use HTTP::Status;
use LWP::UserAgent;
use LWP::Simple;
use Parse::CPAN::Packages::Fast;
use File::Temp qw/ :POSIX /;
use Class::Load ':all';
use Term::UI;
use Term::ReadLine;
use Carp;
use Encode;
use Path::Class;

our $VERSION ||= '0.000';

option dukgo_login => (
	is => 'ro',
	lazy => 1,
	default => sub { 'https://dukgo.com/my/login' }
);

option no_check => (
	is => 'ro',
	lazy => 1,
	default => sub { 0 }
);

option duckpan_packages => (
	is => 'ro',
	lazy => 1,
	default => sub { shift->duckpan.'/modules/02packages.details.txt.gz' }
);

option duckpan => (
	is => 'ro',
	lazy => 1,
	default => sub { 'http://duckpan.org/' }
);

sub _ua_string {
  my ($self) = @_;
  my $class   = ref $self || $self;
  my $version = $class->VERSION;
 
  return "$class/$version";
}

option http_proxy => (
	is => 'ro',
	predicate => 1,
);

option config => (
	is => 'ro',
	predicate => 1,
);

option cache => (
	is => 'ro',
	predicate => 1,
);

has term => (
	is => 'ro',
	lazy => 1,
	builder => '_build_term',
);

sub _build_term { Term::ReadLine->new('duckpan') }

sub get_reply {
	my ( $self, $prompt, %params ) = @_;
	my $return = $self->term->get_reply( prompt => $prompt, %params );
	Encode::_utf8_on($return);
	return $return;
}

has http => (
	is => 'ro',
	builder => '_build_http',
	lazy => 1,
);

sub _build_http {
	my ( $self ) = @_;
	my $agent = LWP::UserAgent->new;
	$agent->agent($self->_ua_string);
	$agent->env_proxy;
	$agent->proxy( http => $self->http_proxy ) if $self->has_http_proxy;
	return $agent;
}

has server_hostname => (
	is => 'ro',
	lazy => 1,
	builder => 1,
);

sub _build_server_hostname { defined $ENV{APP_DUCKPAN_SERVER_HOSTNAME} ? $ENV{APP_DUCKPAN_SERVER_HOSTNAME} : 'duckduckgo.com' }

has cfg => (
	is => 'ro',
	lazy => 1,
	builder => 1,
	handles => [qw(
		config_path
		config_file
		set_config
		get_config
	)]
);

sub _build_cfg {
	my ( $self ) = @_;
	App::DuckPAN::Config->new(
		$self->has_config ? ( config_path => $self->config ) : (),
		$self->has_cache ? ( cache_path => $self->cache ) : (),
	);
}

has help => (
	is => 'ro',
	builder => '_build_help',
	lazy => 1,
);

sub _build_help { App::DuckPAN::Help->new( version => $VERSION ) }

has perl => (
	is => 'ro',
	builder => '_build_perl',
	lazy => 1,
);

sub _build_perl { 
	load_class('App::DuckPAN::Perl');
	App::DuckPAN::Perl->new( app => shift );
}

has ddg => (
	is => 'ro',
	builder => '_build_ddg',
	lazy => 1,
);

sub _build_ddg { 
	load_class('App::DuckPAN::DDG');
	App::DuckPAN::DDG->new( app => shift );
}

sub execute {
	my ( $self, $args, $chain ) = @_;
	my @arr_args = @{$args};
	if (@arr_args) {
		my @modules;
		my @left_args;
		for (@arr_args) {
			if ($_ =~ /^ddg/i || $_ =~ /^app::duckpan/i) {
				push @modules, $_;
			} elsif (lc($_) eq 'duckpan' or lc($_) eq 'upgrade') {
				push @modules, 'App::DuckPAN';
				push @modules, 'DDG' if lc($_) eq 'upgrade';
			} else {
				push @left_args, $_;
			}
		}
		exit $self->perl->duckpan_install(@modules) unless @left_args;
	}
	print $self->help->help;
	exit 0;
}

sub print_text {
	shift;
	for (@_) {
		print "\n";
		my @words = split(/\s+/,$_);
		my $current_line = "";
		for (@words) {
			if ((length $current_line) + (length $_) < 79) {
				$current_line .= " " if length $current_line;
				$current_line .= $_;
			} else {
				print $current_line."\n";
				$current_line = $_;
			}
		}
		print $current_line."\n" if length $current_line;
	}
	print "\n";
}

sub check_requirements {
	my ( $self ) = @_;
	my $fail = 0;
	print "\nChecking your environment for the DuckPAN requirements\n\n";
	#$fail = 1 unless $self->check_locallib;
	$fail = 1 unless $self->check_ddg;
	$fail = 1 unless $self->check_git;
	$fail = 1 unless $self->check_ssh;
	if ($fail) {
		return 1;
	}
	return 0;
}

sub check_git {
	my ( $self ) = @_;
	my $ok = 1;
	print "Checking for git... ";
	if (my $git = which('git')) {
		my $version_string = `$git --version`;
		if ($version_string =~ m/git version (\d+)\.(\d+)/) {
			if ($1 <= 1 && $2 < 7) {
				print "require minimum 1.7"; $ok = 0;
			} else {
				print $git;
			}
		} else {
			print "Unknown version!"; $ok = 0;
		}
	} else {
		print "No!"; $ok = 0;
	}
	print "\n";
	return $ok;
}

sub check_ssh {
	my ( $self ) = @_;
	my $ok = 1;
	print "Checking for ssh... ";
	if (my $ssh = which('ssh')) {
		print $ssh;
	} else {
		print "No!"; $ok = 0;
	}
	print "\n";
	return $ok;
}

sub get_local_ddg_version {
	my ( $self ) = @_;
	return $self->perl->get_local_version('DDG');
}

sub check_ddg {
	my ( $self ) = @_;
	my $ok = 1;
	my $installed_version = $self->get_local_ddg_version;
	return $ok if $installed_version && $installed_version == '9.999';
	print "Checking for latest DDG Perl package... ";
	my $tempfile = tmpnam;
	if (is_success(getstore($self->duckpan_packages,$tempfile))) {
		my $packages = Parse::CPAN::Packages::Fast->new($tempfile);
		my $module = $packages->package('DDG');
		my $latest = $self->duckpan.'authors/id/'.$module->distribution->pathname;
		if ($installed_version && version->parse($installed_version) >= version->parse($module->version)) {
			print $installed_version;
			print " (duckpan has ".$module->version.")" if $installed_version ne $module->version;
		} else {
			if ($installed_version) {
				print "You have version ".$installed_version.", latest is ".$module->version."!\n";
			} else {
				print "You don't have DDG installed! Latest is ".$module->version."!\n";
			}
			print "[ERROR] Please install the latest DDG package with: duckpan DDG\n";
			$ok = 0;
		}
	} else {
		print "[ERROR] Can't download ".$self->duckpan_packages;
		$ok = 0;
	}
	print "\n";
	return $ok;
}

sub checking_dukgo_user {
	my ( $self, $user, $pass ) = @_;
	my $response = $self->http->request(POST($self->dukgo_login, Content => {
		username => $user,
		password => $pass,
	}));
	$response->code == 302 ? 1 : 0; # workaround, need something in dukgo
}

sub BUILD {
	my ( $self ) = @_;
	if ($^O eq 'MSWin32') {
		print "\n[ERROR] We dont support Win32\n\n";
		exit 1;
	}
    my $env_config = file($self->cfg->config_path, 'env.ini');
    if (-e $env_config) {
        my $env = Config::INI::Reader->read_file(file($self->cfg->config_path, 'env.ini'));
        map { $ENV{$_} = $env->{'_'}{$_}; } keys %{$env->{'_'}} if $env->{'_'};
    }
}

1;

__END__

=head1 SYNPOSIS

  duckpan check
  # Check for the requirements to make duckpan contributions
  
  duckpan query
  # Fire up your own CLI DuckDuckGo to test goodies
  # Use it in the zeroclickinfo-goodies repository root

  duckpan server
  # Fire up your own Webserver that acts like DuckDuckGo to test
  # spice (and goodies if you like). Use it in the
  # zeroclickinfo-spice repository root
  
  duckpan help <command>
  # Getting help

  # TODO  
  duckpan test
  #######

  # For the followings you need an account at https://dukgo.com/

  # TODO
  duckpan release
  #######

  # BETA
  duckpan setup
  # Setup your environment for using Dist::Zilla::Plugin::UploadToDuckPAN
  #######

=head1 DESCRIPTION

L<DuckPAN|http://duckpan.org/> is a project of L<DuckDuckGo|https://duckduckgo.com/>
trying to make a release platform for the contributions to DuckDuckGo. DuckDuckGo
is a search engine, using so a so called Zero-click Info to spice the search result
with a very specific result, for example 2+2 or 200 USD to EUR. In this concept
there is like a nearly unlimited option of what contributions are possible. Beside
gathering those Zero-click Info plugins, we also want to use it to store all
released style projects of DuckDuckGo (for example opensource browser plugins and
the other user contributed tools).

We are still in the buildup of all this, but you may contact us in the channel
mentioned in the SUPPORT section down under. So anything can change, but we try to
keep this client and already implemented features stable.

=head1 SEE ALSO

L<https://duckduckgo.com>

L<https://github.com/duckduckgo>

L<https://dukgo.com>

L<http://duckpan.org>

=head1 SUPPORT

IRC

  Join us on #duckduckgo on irc.freenode.net

Repository

  https://github.com/duckduckgo/p5-app-duckpan
  Pull request and additional contributors are welcome
 
Issue Tracker

  https://github.com/duckduckgo/p5-app-duckpan/issues
