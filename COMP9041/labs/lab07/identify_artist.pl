#!/usr/bin/perl -w

foreach my $file (glob "lyrics/*.txt") {
	my $artist = $file;
	my $total_count = 0;
	my $log_probility = 0;
	$artist =~ s/.*\///;		# remove all letters between name
	$artist =~ s/\..*//;		# remove all letters after name
	$artist =~ s/_/ /g;			# replace all underline with space
	open FILE, '<', "$file" or die;
	foreach my $line (<FILE>) {
		$line =~ s/[^ a-zA-Z]/ /g;
		$line = lc $line;
		@words = split(' ', $line);
		$total_count += $#words + 1;
		foreach $word (@words) {
			$hash{$artist}{$word} += 1;
		}
		$hash{$artist}{total_count} = $total_count;
	}
	close FILE;
}

foreach my $file (@ARGV) {
	open FILE, '<', "$file" or die;
	foreach my $line (<FILE>) {
		$line =~ s/[^ a-zA-Z]/ /g;
		$line = lc $line;
		my @words = split(' ', $line);
		foreach my $word (@words) {
			foreach my $key (keys %hash) {
				if (exists $hash{$key}{$word}) {
					$hash{$key}{log_probility} += log(($hash{$key}{$word}+1)/$hash{$key}{total_count});
				}
				else {
					$hash{$key}{log_probility} += log(1/$hash{$key}{total_count});
				}
			}
		}
	}
	close FILE;
	foreach my $key1 (keys(%hash)) {
		$final_hash{$hash{$key1}{log_probility}} = $key1;
		$hash{$key1}{log_probility} = 0;
    	#print("\$hash{$key1} has keys:".join(',',values(%{$hash{$key1}})),"\n");
    	# print all values of the key of hash
	}
	my $possibility = (sort keys %final_hash)[0];
	my $singer = $final_hash{$possibility};
	print sprintf("%s most resembles the work of %s (log-probability=%.1f)\n", $file, $singer, $possibility);
	%final_hash = ();
}
