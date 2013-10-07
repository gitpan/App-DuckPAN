package App::DuckPAN::Cmd::Poupload;
BEGIN {
  $App::DuckPAN::Cmd::Poupload::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::Cmd::Poupload::VERSION = '0.121';
}
# ABSTRACT: Command for uploading .po files to the DuckDuckGo Community Platform

use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options;
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use Path::Class;
use Dist::Zilla::Util;

option domain => (
	is => 'ro',
	format => 's',
	predicate => 1,
);

option upload_uri => (
	is => 'ro',
	format => 's',
	lazy => 1,
	builder => 1,
);

sub _build_upload_uri { 'https://dukgo.com/translate/po/upload' }

sub get_request {
	my ( $self, $file ) = @_;
	my ( $user, $pass ) = $self->app->ddg->get_dukgo_user_pass;
	my $req = POST(
		$self->upload_uri,
		Content_Type => 'form-data',
		Content => {
			CAN_MULTIPART => 1,
			HIDDENNAME => $user,
			po_upload => [ $file ],
			$self->has_domain ? ( token_domain => $self->domain ) : (),
		},
	);
	$req->authorization_basic($user, $pass);
	return $req;
}

sub run {
	my ( $self, @args ) = @_;
	for (@args) {
		$self->upload($_);
	}
}

sub upload {
	my ( $self, $file ) = @_;
	die "File not found" unless -f $file;
	print "Uploading ".$file."... ";
	my $response = $self->app->http->request($self->get_request($file));
	die "Error: ".$response->code if $response->is_error || $response->is_redirect;
	print "success!\n";
}

1;

__END__
=pod

=head1 NAME

App::DuckPAN::Cmd::Poupload - Command for uploading .po files to the DuckDuckGo Community Platform

=head1 VERSION

version 0.121

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

