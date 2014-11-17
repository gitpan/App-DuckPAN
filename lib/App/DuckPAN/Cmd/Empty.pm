package App::DuckPAN::Cmd::Empty;
BEGIN {
  $App::DuckPAN::Cmd::Empty::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Install the distribution in current directory
$App::DuckPAN::Cmd::Empty::VERSION = '0.164';
use Moo;
with qw( App::DuckPAN::Cmd );

use MooX::Options protect_argv => 0;

sub run {
	my ( $self, @args ) = @_;
	$self->app->empty_cache();
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Empty - Install the distribution in current directory

=head1 VERSION

version 0.164

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
