#!/usr/bin/perl -w

$filename = $ARGV[0];
$pattern = $ARGV[1];

open my $file, '<', "$filename" or die;
foreach my $line (<$file>) {
	if ($line =~ /$pattern/) {
		$line =~ s/$pattern/($pattern)/g;
		print "$line";
	}
}
close;
