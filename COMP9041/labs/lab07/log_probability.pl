#!/usr/bin/perl -w

my $total_count = 0;
my $word_count = 0;
my $defined_word = $ARGV[0];

foreach $file (glob "lyrics/*.txt") {
	my $artist = $file;
	$artist =~ s/.*\///;		# remove all letters between name
	$artist =~ s/\..*//;		# remove all letters after name
	$artist =~ s/_/ /g;			# replace all underline with space	
	open FILE, '<', "$file" or die;
	foreach $line (<FILE>) {
		$line =~ s/[^ a-zA-Z]/ /g;
		$line = lc $line;
		@words = split(' ', $line);
		$total_count += $#words + 1;
		foreach $word (@words) {
			if ($word eq $defined_word) {
				$word_count += 1;	
			}	
		}
	}
	$freq{$artist}[0] = $word_count;
	$freq{$artist}[1] = $total_count;
	$freq{$artist}[2] = log(($word_count+1) / $total_count);
	$word_count = 0;
	$total_count = 0;
	#close;
	#print "$artist\n";
}
foreach $key (sort keys %freq) {
	print sprintf("log((%d+1)/%6d) =  %.4f %s\n", $freq{$key}[0], $freq{$key}[1], $freq{$key}[2], $key);
}
