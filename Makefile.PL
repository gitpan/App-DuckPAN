
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "The DuckDuckGo DuckPAN client",
  "AUTHOR" => "Torsten Raudssus <torsten\@raudss.us>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "App-DuckPAN",
  "EXE_FILES" => [
    "bin/duckpan"
  ],
  "LICENSE" => "perl",
  "NAME" => "App::DuckPAN",
  "PREREQ_PM" => {
    "App::cpanminus" => "1.5007",
    "CPAN::Repository" => "0.007",
    "Class::Load" => "0.18",
    "Config::INI" => "0.019",
    "Crypt::SSLeay" => "0.58",
    "Data::Printer" => "0.3",
    "Dist::Zilla" => "4.300007",
    "Dist::Zilla::Plugin::UploadToDuckPAN" => 0,
    "Email::Valid" => "0.187",
    "File::ShareDir::ProjectDistDir" => "0.003002",
    "File::Temp" => "0.22",
    "File::Which" => "1.09",
    "HTML::TreeBuilder" => 0,
    "IO::All" => 0,
    "LWP::Protocol::https" => 0,
    "LWP::Simple" => "6.00",
    "Module::Data" => "0.006",
    "Module::Pluggable" => "4.0",
    "Moo" => "0.009013",
    "MooX" => "0.101",
    "MooX::Cmd" => "0.001",
    "MooX::HasEnv" => "0.003",
    "MooX::Options" => "3.71",
    "POE" => "1.354",
    "Parse::CPAN::Packages::Fast" => "0.04",
    "Path::Class" => "0.26",
    "Plack" => "0.9986",
    "Starman" => 0,
    "Term::UI" => "0.30",
    "URI" => "1.60",
    "version" => "0.96"
  },
  "TEST_REQUIRES" => {
    "Dir::Self" => "0.10",
    "File::FindLib" => "0.001001",
    "File::HomeDir" => "1.00",
    "File::Temp" => "0.22",
    "File::chdir" => "0.1008",
    "Test::LoadAllModules" => "0.021",
    "Test::More" => "0.98",
    "Test::Script::Run" => "0.05"
  },
  "VERSION" => "0.070",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



