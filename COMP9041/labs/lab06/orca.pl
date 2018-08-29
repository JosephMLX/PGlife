#!/usr/bin/perl -w

$count = 0;

open FILE, '<', "$ARGV[0]";

foreach $line (<FILE>) {
	if ($line =~ /Orca/) {
		$line =~ s/[A-z].*//;
		$line =~ s/[0-9]{2}\/[0-9]{2}\/[0-9]{2}//;
		$count += $line;
	}
}

print "$count Orcas reported in $ARGV[0]", "\n";
close
	
