#!/usr/bin/perl -w
foreach $n (@ARGV) {
	$h{$n} += $n;
}
foreach $key (sort keys %h) {
	print "key: $key ";
	print "value: $h{$key}\n";
}
print ((sort {$h{$b} <=> $h{$a}} keys %h)[0]);
print "\n";
