#!/usr/bin/perl -w

$content = $ARGV[0];
$content =~ s/\\/\\\\/g;
$content =~ s/\"/\\\"/g;
$content = "print \"$content\\n\"\;";

print "$content";

