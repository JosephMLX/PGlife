#!/usr/bin/perl -w

while ($line = <STDIN>) {
	@words = split(" ", $line);
	@words = sort @words;
	print join " ", "@words";
	print "\n";
}
