package App::DuckPAN::Cmd::Server;
BEGIN {
  $App::DuckPAN::Cmd::Server::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::Cmd::Server::VERSION = '0.030';
}

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use Plack::Runner;
use File::ShareDir::ProjectDistDir;
use File::Copy;
use Path::Class;
use IO::All -utf8;
use LWP::Simple;
use HTML::TreeBuilder;

sub run {
	my ( $self, @args ) = @_;

	exit 1 unless $self->app->check_ddg;

	dir($self->app->cfg->cache_path)->mkpath unless -d $self->app->cfg->cache_path;

	copy(file(dist_dir('App-DuckPAN'),'page_root.html'),file($self->app->cfg->cache_path,'page_root.html')) unless -f file($self->app->cfg->cache_path,'page_root.html');
	copy(file(dist_dir('App-DuckPAN'),'page_spice.html'),file($self->app->cfg->cache_path,'page_spice.html')) unless -f file($self->app->cfg->cache_path,'page_share.html');
	copy(file(dist_dir('App-DuckPAN'),'page.css'),file($self->app->cfg->cache_path,'page.css')) unless -f file($self->app->cfg->cache_path,'page.css');
	copy(file(dist_dir('App-DuckPAN'),'page.js'),file($self->app->cfg->cache_path,'page.js')) unless -f file($self->app->cfg->cache_path,'page.js');

	my @blocks = @{$self->app->ddg->get_blocks_from_current_dir(@args)};

	print "\n\nTrying to fetch current versions of the HTML from http://duckduckgo.com/\n\n";

	my $fetch_page_root;
	if ($fetch_page_root = get('http://duckduckgo.com/')) {
		io(file($self->app->cfg->cache_path,'page_root.html'))->print($self->change_html($fetch_page_root));
	} else {
		print "\nRoot fetching failed, will just use cached version..."
	}

	my $fetch_page_spice;
	if ($fetch_page_spice = get('http://duckduckgo.com/?q=duckduckhack-template-for-spice')) {
		io(file($self->app->cfg->cache_path,'page_spice.html'))->print($self->change_html($fetch_page_spice));
	} else {
		print "\nSpice-Template fetching failed, will just use cached version..."
	}

	my $fetch_page_css;
	if ($fetch_page_css = get('http://duckduckgo.com/style.css')) {
		io(file($self->app->cfg->cache_path,'page.css'))->print($self->change_css($fetch_page_css));
	} else {
		print "\nCSS fetching failed, will just use cached version..."
	}

	my $fetch_page_js;
	if ($fetch_page_js = get('http://duckduckgo.com/duckduck.js')) {
		io(file($self->app->cfg->cache_path,'page.js'))->print($self->change_js($fetch_page_js));
	} else {
		print "\nJavaScript fetching failed, will just use cached version..."
	}

	my $page_root = io(file($self->app->cfg->cache_path,'page_root.html'))->slurp;
	my $page_spice = io(file($self->app->cfg->cache_path,'page_spice.html'))->slurp;
	my $page_css = io(file($self->app->cfg->cache_path,'page.css'))->slurp;
	my $page_js = io(file($self->app->cfg->cache_path,'page.js'))->slurp;

	print "\n\nStarting up webserver...";
	print "\n\nYou can stop the webserver with Ctrl-C";
	print "\n\n";

	require App::DuckPAN::Web;

	my $web = App::DuckPAN::Web->new(
		blocks => \@blocks,
		page_root => $page_root,
		page_spice => $page_spice,
		page_css => $page_css,
		page_js => $page_js,
	);
	my $runner = Plack::Runner->new(
		#loader => 'Restarter',
		includes => ['lib'],
		app => sub { $web->run_psgi(@_) },
	);
	#$runner->loader->watch("./lib");
	exit $runner->run;
}

sub change_js {
	my ( $self, $js ) = @_;
	$js =~ s!/([ds])\.js\?!/?duckduckhack_ignore=1&!g;
	$js =~ s!/post\.html!/?duckduckhack_ignore=1&!g;
	return $self->change_css($js);
}

sub change_css {
	my ( $self, $css ) = @_;
	$css =~ s!url\(("?)!url\($1http://duckduckgo.com/!g;
	return $css;
}

sub change_html {
	my ( $self, $html ) = @_;

	my $root = HTML::TreeBuilder->new;
	$root->parse($html);

	my @a = $root->look_down(
		"_tag", "a"
	);

	my @link = $root->look_down(
		"_tag", "link"
	);

	for (@a,@link) {
		if ($_->attr('type') && $_->attr('type') eq 'text/css') {
			$_->attr('href','/?duckduckhack_css=1');
		} elsif (substr($_->attr('href'),0,1) eq '/') {
			$_->attr('href','http://duckduckgo.com'.$_->attr('href'));
		}
	}

	my @script = $root->look_down(
		"_tag", "script"
	);

	for (@script) {
		if (my $src = $_->attr('src')) {
			if ($src =~ m/^\/d\d{3}\.js/) {
				$_->attr('src','/?duckduckhack_js=1');
			} elsif (substr($src,0,1) eq '/') {
				$_->attr('src','http://duckduckgo.com'.$_->attr('src'));
			}
		}
	}

	my @img = $root->look_down(
		"_tag", "img"
	);

	for (@img) {
		if ($_->attr('src')) {
			$_->attr('src','http://duckduckgo.com'.$_->attr('src'));
		}
	}

	my $newhtml = $root->as_HTML;

	return $self->change_js($self->change_css($newhtml));
}

1;

__END__
=pod

=head1 NAME

App::DuckPAN::Cmd::Server

=head1 VERSION

version 0.030

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

