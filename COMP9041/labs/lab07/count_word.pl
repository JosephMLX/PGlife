#!/usr/bin/perl -w

my $count = 0;
my $defined_word = $ARGV[0];
foreach $line (<STDIN>) {
	$line =~ s/[^ a-zA-Z]/ /g;    # replace all non-alphabetic characters and keep space
	$line = lc $line;
	@words = split(' ', $line);
	foreach $word (@words) {
		if ($word eq $defined_word) {
			$count += 1;	
		}	
	}
}
print "$defined_word occurred $count times\n";
