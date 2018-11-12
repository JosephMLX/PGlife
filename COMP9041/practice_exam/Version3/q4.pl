#!/usr/bin/perl -w

while ($line = <>) {
	my @names = split /\|/, $line;
	my $oldName = $names[2];
	my @fullname = split /\, /, $oldName;
	my $fName = $fullname[0];
	my $gName = $fullname[1];
	my $newName = $gName." ".$fName;
	$line =~ s/$oldName/$newName/g;
	print $line;
}
