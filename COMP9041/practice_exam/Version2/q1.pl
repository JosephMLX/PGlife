#!/usr/bin/perl -w

while (<>) {
    chomp;
    @a = split;
    $h{$a[0]} .= $a[1];
}
print "$h{a}\n";
