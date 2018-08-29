#!/usr/bin/perl -w

$file_path = $ARGV[0];

open FILE, '<', "$file_path" or die;

foreach $line (<FILE>) {
	$line = lc $line;
	if ($line =~ /.[s]$/) {
		$line =~ s/.$//s;
	}
	@l = split(' ', $line);
	$whale_name = join(" ", @l[2..$#l]);
	$whale_hash{$whale_name}[0] += 1;
	$whale_hash{$whale_name}[1] += $l[1];
}

foreach $key (sort keys %whale_hash) {
	$pods = $whale_hash{$key}[0];
	$indi = $whale_hash{$key}[1];
	print "$key observations: $pods pods, $indi individuals", "\n";
}

close;
