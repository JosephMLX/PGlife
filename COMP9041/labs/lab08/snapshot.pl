#!/usr/bin/perl -w

use File::Copy "cp";
use Cwd qw();

$path = Cwd::cwd();
$command = $ARGV[0];

if ($command eq "save") {
	save();
}

if ($command eq "load") {	
	load($ARGV[1]);
}

sub save {
	my $num = 0;
	my $folder = ".snapshot."."$num";
	my $flag = 0;
	while ($flag == 0) {
		if (-d $folder) {
			$num += 1;
			$folder = ".snapshot."."$num";
		} else {
			my $new_folder = ".snapshot."."$num";
			mkdir "$new_folder";
			print "Creating snapshot $num\n";
			foreach my $file (glob ".* *") {
				if ($file ne "snapshot.pl" && $file !~ /^\..*/) {
					cp $file, "$new_folder/"
				}			
			} 
			$flag = 1;
		}
	}
}

sub load {
	save();
	my $dict = $_[0];
	my $dir = ".snapshot.$dict";
	foreach my $file (glob "$dir/*") {
		cp $file, "$path/";	
	}
	print "Restoring snapshot $dict\n";
}
