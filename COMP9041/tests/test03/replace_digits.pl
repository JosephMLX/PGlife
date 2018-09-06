#!/usr/bin/perl -w

$filename = $ARGV[0];
open FILE_READ, '<', "$filename" or die;
@lines = <FILE_READ>;
foreach my $line (@lines) {
	$line =~ s/[0-9]/#/g;
}
open FILE_WRITE, '>', "$filename" or die;
foreach my $line (@lines) {
	print FILE_WRITE "$line";
}

close FILE_WRITE;
close FILE_READ;
