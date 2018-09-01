#!/usr/bin/perl -w

$begin = $ARGV[0];
$end = $ARGV[1];
$filename = $ARGV[2];

open FILE, '>', "$filename";

while ($begin <= $end) {
	print FILE "$begin\n";
	$begin += 1;
}

close FILE;
