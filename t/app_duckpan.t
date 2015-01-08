#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Path::Tiny;
use Class::Load ':all';

delete $ENV{APP_DUCKPAN_SERVER_HOSTNAME};

use App::DuckPAN;

my $version = $App::DuckPAN::VERSION;

my $tempdir = Path::Tiny->tempdir(CLEANUP => 1);

my $app = App::DuckPAN->new(
	config => $tempdir,
);

isa_ok($app,'App::DuckPAN');
is($app->cfg->config_path->absolute,$tempdir,"Checking temp config path of App::DuckPAN");
isa_ok($app->http,'LWP::UserAgent');
is($app->server_hostname, 'duckduckgo.com','Checking for default server duckduckgo.com');

###############################################################
isa_ok($app->perl,'App::DuckPAN::Perl');
is($app->perl->get_local_version('App::DuckPAN'),$version,'Checking get_local_version of perl submodule');

###############################################################
isa_ok($app->cfg,'App::DuckPAN::Config');

SKIP: {
	skip "No DDG installed yet", 2 unless try_load_class('DDG');
	my $ddg_version = $DDG::VERSION;
	isa_ok($app->ddg,'App::DuckPAN::DDG');
	is($app->get_local_ddg_version,$ddg_version,'Checking get_local_ddg_version');
}

done_testing;
