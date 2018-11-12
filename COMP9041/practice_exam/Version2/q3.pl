#!/usr/bin/perl -w

my $max = 0;
foreach my $item (@ARGV) {
	$seen{$item} += 1;
	if ($seen{$item} > $max) {
		$max = $seen{$item};
	}
}
foreach my $key (@ARGV) {
	if ($seen{$key} == $max) {
		print "$key\n";
		exit 1;
	}
}

