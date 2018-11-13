#!/usr/bin/perl -w

while ($line = <STDIN>) {
	chomp $line;
	@arr = split //, $line;
	foreach $i (0..$#arr) {
		if ($arr[$i] =~ /[0-9a-zA-Z]/) {
			$hash{$arr[$i]} += 1;
		}
	}
}
foreach $key (sort keys %hash) {
	print "'$key' occured $hash{$key} times\n";
}
