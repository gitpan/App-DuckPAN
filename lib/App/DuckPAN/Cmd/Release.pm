package App::DuckPAN::Cmd::Release;
BEGIN {
  $App::DuckPAN::Cmd::Release::AUTHORITY = 'cpan:DDG';
}
{
  $App::DuckPAN::Cmd::Release::VERSION = '0.108';
}
# ABSTRACT: Release the distribution of the current directory

use MooX qw( Options );
with qw( App::DuckPAN::Cmd );

sub run {
    my ( $self ) = @_;

    my $ret = system('dzil release');

    print STDERR '[ERROR] Could not begin release. Is Dist::Zilla installed?'
      if $ret == -1;

    return $ret;
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Release - Release the distribution of the current directory

=head1 VERSION

version 0.108

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by DuckDuckGo, Inc. L<http://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
