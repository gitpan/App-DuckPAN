package App::DuckPAN::CmdBase::Env;
BEGIN {
  $App::DuckPAN::CmdBase::Env::AUTHORITY = 'cpan:DDG';
}
# ABSTRACT: Base class for ENV related functionality of duckpan (duckpan env and duckpan rm)
$App::DuckPAN::CmdBase::Env::VERSION = '0.163';
use MooX qw( Options );
use Path::Tiny;
use Config::INI;

has env_ini => (
  is => 'ro',
  lazy => 1,
  builder => 1,
);

sub _build_env_ini { shift->app->cfg->config_path->child('env.ini') }

sub load_env_ini {
  my ( $self ) = @_;
  if (-f $self->env_ini) {
    my $data = Config::INI::Reader->read_file(shift->env_ini)->{_};
    defined $data ? $data : {}
  } else {
    {}
  }
}
sub save_env_ini {
  my ( $self, $data ) = @_;
  Config::INI::Writer->write_file({ _ => $data },$self->env_ini);
}

sub set_env {
  my ( $self, $name, $value ) = @_;
  $name = uc($name);
  my %data = %{$self->load_env_ini};
  $data{$name} = $value;
  $self->save_env_ini(\%data);
}

sub get_env {
  my ( $self, $name ) = @_;
  $name = uc($name);
  my %data = %{$self->load_env_ini};
  $data{$name};
}

sub rm_env {
  my ( $self, $name ) = @_;
  $name = uc($name);
  my %data = %{$self->load_env_ini};
  delete $data{$name} if defined $data{$name};
  $self->save_env_ini(\%data);
}

sub show_env {
  my ( $self, $name ) = @_;
  if ($self->get_env($name)) {
    $self->app->emit_info('export '.$name.'=\''.$self->get_env($name).'\'');
  } else {
    $self->app->emit_info('# '.$name.' is not set');
  }
}

sub show_usage {
    my ($self) = @_;
    if (keys %{$self->load_env_ini}) {
        $self->app->emit_info("# ENV variables added so far:");
        $self->show_env($_) for (sort keys %{$self->load_env_ini});
    }
    $self->app->emit_and_exit(1, "Usage:", "\tset: duckpan env <name> <value>", "get: duckpan env <name>", "\t rm: duckpan rm <name>\n");
}

1;

__END__

=pod

=head1 NAME

App::DuckPAN::CmdBase::Env - Base class for ENV related functionality of duckpan (duckpan env and duckpan rm)

=head1 VERSION

version 0.163

=head1 AUTHOR

Torsten Raudssus <torsten@raudss.us> L<https://raudss.us/>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by DuckDuckGo, Inc. L<https://duckduckgo.com/>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
