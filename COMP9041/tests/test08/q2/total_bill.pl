#!/usr/bin/perl -w

my $totalPrice = 0;
my $filename = $ARGV[0];

open my $file, '<', "$filename" or die;
foreach $line (<$file>) {
	$line =~ s/[^\d.]+//g;
	$totalPrice += $line;
}
print "\$";
printf "%.2f", "$totalPrice\n";
