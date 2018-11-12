#!/usr/bin/perl -w

@a = <STDIN>;
foreach my $line (0..$#a) {
	if ($a[$line] =~ /\d/g) {
		my $line_n = $a[$line];
		$line_n =~ s/\#//g;
		$a[$line] = $a[$line_n-1];
	}
}

print "@a";

