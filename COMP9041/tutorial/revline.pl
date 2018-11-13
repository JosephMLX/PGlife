#!/usr/bin/perl -w

while ($line = <STDIN>) {
	chomp $line;
	my @arr = split / /, $line;
	$line = join(' ', reverse @arr);
	print "$line\n";
}
