#!/usr/bin/perl -w

$hash = {};

foreach my $i (0..$#ARGV) {
	if (!defined $hash{$ARGV[$i]}) {
		$hash{$ARGV[$i]} = $i;
	}
}

foreach my $key (sort { $hash{$a} <=> $hash{$b} } keys %hash) {
	print "$key ";
}
print "\n";
