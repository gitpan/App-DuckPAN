package App::DuckPAN::DDG;
BEGIN {
  $App::DuckPAN::DDG::AUTHORITY = 'cpan:GETTY';
}
{
  $App::DuckPAN::DDG::VERSION = '0.055';
}

use Moo;
with 'App::DuckPAN::HasApp';

use Module::Pluggable::Object;
use Class::Load ':all';

sub get_blocks_from_current_dir {
	my ( $self, @args ) = @_;
	unless ($self->app->get_local_ddg_version) {
		print "\n[ERROR] You need to have the DDG distribution installed\n";
		print "\nTo get the installation command, please run: duckpan check\n\n";
		exit 1;
	}
	my $finder = Module::Pluggable::Object->new(
		search_path => ['lib/DDG/Spice','lib/DDG/Goodie'],
	);
	my @plugins = $finder->plugins;
	push @args, sort { $a cmp $b } @plugins;
	@args = map {
		$_ =~ s!/!::!g;
		my @parts = split('::',$_);
		shift @parts;
		join('::',@parts);
	} @args;
	unless (@args) {
		print "\n[ERROR] No DDG::Goodie::* or DDG::Spice::* packages found\n";
		print "\nHint: You must be in the root of your repository so that this works.\n\n";
		exit 1;
	}
	require lib;
	lib->import('lib');
	print "\nUsing the following DDG plugins:\n\n";
	for (@args) {
		load_class($_);
		print " - ".$_;
		print " (".$_->triggers_block_type.")\n";
	}
	my %blocks_plugins;
	for (@args) {
		unless ($blocks_plugins{$_->triggers_block_type}) {
			$blocks_plugins{$_->triggers_block_type} = [];
		}
		push @{$blocks_plugins{$_->triggers_block_type}}, $_;
	}
	my @blocks;
	for (keys %blocks_plugins) {
		my $block_class = 'DDG::Block::'.$_;
		load_class($block_class);
		push @blocks, $block_class->new( plugins => $blocks_plugins{$_} );
	}
	load_class('DDG::Request');
	return \@blocks;
}

1;