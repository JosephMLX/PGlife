#!/usr/bin/perl -w

while ($line = <>) {
	if ($line =~ /<!([^>]+)>/) {
		$line =~ s/<!([^>]+)>/<!>/g;
		$s = `$1`;
		$line =~ s/<!>/$s/g;
	}
	while ($line =~ s/<([^>]+)>/<>/g) {
		$s = `cat $1`;
		$line =~ s/<>/$s/g;
	} 
	print "$line";
}
