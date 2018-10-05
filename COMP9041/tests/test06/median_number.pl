#!/usr/bin/perl -w

my @arr;
foreach my $num (0..$#ARGV) {
  push @arr, $ARGV[$num];
}
@arr = sort{$a <=> $b} @arr;
my $mid = ($#ARGV+1) / 2;
print "$arr[$mid]\n";

