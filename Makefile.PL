
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "The DuckDuckGo DuckPAN client",
  "AUTHOR" => "Torsten Raudssus <torsten\@raudss.us>",
  "BUILD_REQUIRES" => {
    "Test::LoadAllModules" => "0.021",
    "Test::More" => "0.98"
  },
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
    "MooX::Cmd" => "0.001",
    "MooX::HasEnv" => 0,
    "MooX::Options" => "0.8",
    "Parse::CPAN::Packages::Fast" => "0.04",
    "Plack" => "0.9986",
    "Term::UI" => "0.30",
    "URI" => "1.60",
    "utf8::all" => "0.004",
    "version" => "0.96"
  },
  "VERSION" => "0.043",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


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



