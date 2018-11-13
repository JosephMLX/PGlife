#!/usr/bin/perl

while ($line = <STDIN>) {
	if($line =~ /[^#]([0-9]+)/) {
		print "$1\n";
	}
}
