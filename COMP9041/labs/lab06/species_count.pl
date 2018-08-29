#!/usr/bin/perl -w

$pods = 0;
$indi = 0;
$specie = $ARGV[0];
$file_path = $ARGV[1];

open FILE, '<', "$file_path" or die;

foreach $line (<FILE>) {
	if ($line =~ "$specie") {
		$line =~ s/[A-Z].*//;
		$line =~ s/[0-9]{2}\/[0-9]{2}\/[0-9]{2}//;
		$pods += 1;
		$indi += $line;
	}
}

print "$specie observations: $pods pods, $indi individuals", "\n";
close;
