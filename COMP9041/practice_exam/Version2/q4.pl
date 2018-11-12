#!/usr/bin/perl -w

while ($line = <>) {
	my @time = $line =~ /[\d]{2}\:[\d]{2}\:[\d]{2}/g;
	my $t = $time[0];
	my @times = split /:/, $t;
	if ($times[0] >= 12) {
		if ($times[0] > 12) {
			$times[0] = sprintf "%02d", $times[0] - 12;
			$t = join(':', @times);
		}
		$t .= "pm";
	} elsif ($times[0] == "00") {
		$times[0] = 12;
		$t = join(':', @times);
		$t .= "am";
	} else {
		$t .= "am";
	}
	$line =~ s/@time/$t/g;
	print "$line";	
}

