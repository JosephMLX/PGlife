#!/usr/bin/perl -w

$hash = {};
$time = $ARGV[0];

while ($line = <STDIN>) {
	$hash{$line} += 1;
	if ($hash{$line} == $time) {
		print "Snap: $line";
		exit 1;
	}
}
