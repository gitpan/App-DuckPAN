package App::DuckPAN::WebStatic;
BEGIN {
  $App::DuckPAN::WebStatic::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::WebStatic::VERSION = '0.129';
}
# ABSTRACT: Webserver for duckpan static

use Moo;
use IO::All -utf8;
use HTTP::Request;
use Plack::Request;
use Plack::Response;
use LWP::UserAgent;
use URI::Escape;
use Path::Class;
use JSON;

has sites => ( is => 'ro', required => 1 );

has _ports => ( is => 'rw', default => sub {{}} );

has ua => (
	is => 'ro',
	default => sub {
		LWP::UserAgent->new(
			agent => "Mozilla/5.0", #User Agent required for some API's (eg. Vimeo, IsItUp)
			timeout => 5,
			ssl_opts => { verify_hostname => 0 },
		);
	},
);

sub BUILD {
	my ( $self ) = @_;
	for my $site (keys %{$self->sites}) {
		my $port = $self->sites->{$site}->{port};
		my $url = $self->sites->{$site}->{url};
		my $data_file = file($site.'.json')->absolute;
		die "Missing JSON publisher data file for ".$site unless -f $data_file;
		my $data = decode_json(io($data_file)->slurp);
		my %urls;
		for my $dir (keys %$data) {
			next if $dir eq 'locales';
			for my $filebase (keys %{$data->{$dir}}) {
				for my $file (keys %{$data->{$dir}->{$filebase}}) {
					next if $file eq 'static';
					my $url = $data->{$dir}->{$filebase}->{$file}->{url};
					my $locale = $data->{$dir}->{$filebase}->{$file}->{locale};
					$urls{$url} = {} unless defined $urls{$url};
					$urls{$url}->{$locale} = file($site,$dir,$file)->absolute->stringify;
					#use DDP; p($data->{$dir}->{$filebase}->{$file}->{url});
				}
			}
		}
		$self->_ports->{$port} = {
			base_url => $url,
			urls => \%urls,
		};
	}
}

sub run_psgi {
	my ( $self, $env ) = @_;
	my $request = Plack::Request->new($env);
	my $response = $self->request($request);
	return $response->finalize;
}

sub request {
	my ( $self, $request ) = @_;

	my $response = Plack::Response->new(200);
	my $body;

	my $locale = defined $ENV{DDG_LOCALE} ? $ENV{DDG_LOCALE} : 'en_US';

	my $site = $self->_ports->{$request->port};

	if ($site->{urls}->{$request->request_uri}) {
		$body = io($site->{urls}->{$request->request_uri}->{$locale})->slurp;
		$response->code("200");
		$response->content_type('text/html');
	} else {
		my $res = $self->ua->request(HTTP::Request->new(GET => $site->{base_url}.$request->request_uri));
		if ($res->is_success) {
			$body = $res->decoded_content;
			$response->code($res->code);
			$response->content_type($res->content_type);
		} else {
			warn $res->status_line, "\n";
			$body = "";
		}
	}

	# This could cause issues with incorrectly encoded data as Plack expects a
	# raw bytestream. We should find the root of this issue and reencode
	# offending strings.
	Encode::_utf8_off($body);
	$response->body($body);
	return $response;
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::WebStatic - Webserver for duckpan static

=head1 VERSION

version 0.129

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
