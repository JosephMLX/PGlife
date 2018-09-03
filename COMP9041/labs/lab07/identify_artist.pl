#!/usr/bin/perl -w

foreach $file (glob "lyrics/*.txt") {
	my $artist = $file;
	my $total_count = 0;
	$artist =~ s/.*\///;		# remove all letters between name
	$artist =~ s/\..*//;		# remove all letters after name
	$artist =~ s/_/ /g;			# replace all underline with space
	open FILE, '<', "$file" or die;
	foreach my $line (<FILE>) {
		$line =~ s/[^ a-zA-Z]/ /g;
		$line = lc $line;
		@words = split(' ', $line);
		$total_count += $#words + 1;
	}
	$freq{$artist}[0] = $total_count;
	$freq{$artist}[1] = 0;
}

if ($ARGV[0] eq "-d") {
	single_file();
}

sub single_file {
	my $file = $ARGV[1];
	open FILE, '<', "$file" or die;
	foreach $line (<FILE>) {
		$line =~ s/[^ a-zA-Z]/ /g;    # replace all non-alphabetic characters and keep space
		$line = lc $line;
		@words = split(' ', $line);
		foreach $word (@words) {
			count_word_all($word);
		}		
	}
}

sub count_word_all {
	my @defined_word = @_;
	foreach $key (sort keys %freq) {
		my $filename = $key;
		$filename =~ s/ /_/g;
		$filename = "lyrics/$filename.txt";
		$freq{$key}[1] += log((count_word_single(@defined_word, $filename)+1)/$freq{$key}[0]);
	}
}	

sub count_word_single {
	my ($defined_word, $filename) = @_;
	my $word_count = 0;
	open FILE, '<', "$filename" or die;
	foreach my $line (<FILE>) {
		$line =~ s/[^ a-zA-Z]/ /g;    # replace all non-alphabetic characters and keep space
		$line = lc $line;
		my @words = split(' ', $line);
		foreach my $word (@words) {
			if ($word eq $defined_word) {
				$word_count += 1;	
			}
		}	
	}
	return $word_count;
}

foreach my $key (sort keys %freq) {
	$hash{$freq{$key}[1]} = $key;
}

if ($ARGV[0] eq "-d") {
	foreach my $key (sort keys %hash) {
		print sprintf("%s: log_probability of %.1f for %s\n", $ARGV[1], $key, $hash{$key});
	}
	$possibility = (sort keys %hash)[0];
	$singer = $hash{$possibility};
	print sprintf("%s most resembles the work of %s (log-probability=%.1f)\n", $ARGV[1], $singer, $possibility);
}