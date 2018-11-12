#!/usr/bin/perl -w

while ($line = <>) {
	#print "$line";
	my @num = $line =~ /(\d+\.\d+)/g;
	foreach my $number (@num) {
		$rounded_number = int($number + 0.5);
		$line =~ s/$number/$rounded_number/g;
	}
	print "$line"; 
}
