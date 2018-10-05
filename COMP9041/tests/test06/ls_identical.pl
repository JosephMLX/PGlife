#!/usr/bin/perl -w

use File::Compare;

my $dir1 = $ARGV[0];
my $dir2 = $ARGV[1];

@dir1_files = glob "$dir1/*";
foreach my $file (@dir1_files) {
  @dir1_file = split ('/', $file);
  @dir1_file = $dir1_file[-1];
  if (-e "$dir2/@dir1_file" && compare("$dir1/@dir1_file","$dir2/@dir1_file") == 0) {
  	print "@dir1_file\n";
  }
}

