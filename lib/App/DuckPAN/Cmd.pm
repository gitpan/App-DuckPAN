package App::DuckPAN::Cmd;
BEGIN {
  $App::DuckPAN::Cmd::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Base class for commands of DuckPAN
$App::DuckPAN::Cmd::VERSION = '0.152';
use Moo::Role;

requires 'run';

has app => (
	is => 'rw',
);

sub execute {
	my ( $self, $args, $chain ) = @_;
	my $app = shift @{$chain};
	$self->app($app);
	$self->run(@{$args});
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd - Base class for commands of DuckPAN

=head1 VERSION

version 0.152

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
