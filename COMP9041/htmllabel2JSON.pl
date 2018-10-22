#!/usr/bin/perl -w

my $content = "{";
my @num_array;
my @name_array;
open my $file, '<', "origin.txt" or die;
foreach my $line (<$file>) {
	$line =~ s/[^0-9]//g;
	push @num_array, $line;	
}

open my $file2, '<', "origin.txt" or die;
foreach my $line (<$file2>) {
	my @substr = split('>', $line);
	$substr[1] =~ s/<.*$//;
	push @name_array, $substr[1];
}

foreach my $i (0..$#num_array) {
	$content .= $num_array[$i];
	$content .= ": \"";
	$content .= $name_array[$i];
	$content .= "\"\, ";
}

$content .= "}";
print "$content";

close;
