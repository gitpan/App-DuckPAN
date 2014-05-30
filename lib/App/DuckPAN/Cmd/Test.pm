package App::DuckPAN::Cmd::Test;
BEGIN {
  $App::DuckPAN::Cmd::Test::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Command for running the tests of this library
$App::DuckPAN::Cmd::Test::VERSION = '0.142';
use MooX;
use MooX::Options protect_argv => 0;
with qw( App::DuckPAN::Cmd );

sub run {
    my ( $self ) = @_;

    my $ret = 0;

    if (-e 'dist.ini') {
      $ret = system('dzil test');
      print STDERR '[ERROR] Could not begin testing. Is Dist::Zilla installed?'
        if $ret == -1;
    } else {
      print STDERR "[WARNING] Could not find dist.ini.\n";
      $ret = system('prove -Ilib');
    }

    return $ret;
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::Cmd::Test - Command for running the tests of this library

=head1 VERSION

version 0.142

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
