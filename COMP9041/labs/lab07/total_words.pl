#!/usr/bin/perl -w

my $count = 0;
foreach $line (<STDIN>) {
	$line =~ s/[^ a-zA-Z]/ /g;    # replace all non-alphabetic characters and keep space
	@words = split(' ', $line);
	$count += $#words + 1;
	#print "$line\n";
}
print "$count words\n";
