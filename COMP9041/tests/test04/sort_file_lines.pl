#!/usr/bin/perl -w

$filename = $ARGV[0];
$hash = {};
open my $file, '<', "$filename" or die;
foreach $line (<$file>) {
	$length = length($line);
	$hash{$line} = $length;	
}
foreach my $key (sort { $hash{$a} <=> $hash{$b} } sort keys %hash) {
	print "$key";
}
close $file;
