#!/usr/bin/perl -w

my $whale = $ARGV[0];
my @str = '';
my $sum = 0;
open my $file, '<', "$ARGV[1]";
foreach my $line (<$file>) {
	if ($line =~ /how_many/ or $line =~ /species/) {
		push @str, $line;
	}
}
foreach my $line (@str) {
	if ($line =~ /how_many/) {
		$line =~ s/\D//g;
	}
}
foreach my $i (0..$#str) {
	if ($str[$i] =~ $whale) {
		$sum += $str[$i-1];
	}
}
print("$sum\n");
