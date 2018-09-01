#!/usr/bin/perl -w

$nth = $ARGV[0]-1;
$filename = $ARGV[1];
open FILE, '<', "$filename";
@lines = <FILE>;
if ($nth <= $#lines) {
	print "$lines[$nth]";
}
close FILE;
