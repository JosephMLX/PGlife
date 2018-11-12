#!/usr/bin/perl -w

while ($line = <>) {
	my @info = split / /, $line;
	$sheet{$info[0]} += $info[1];
}
my $student_to_expel = "";
my $highest_fine = 0;
foreach my $student (keys %sheet) {
	if ($sheet{$student} > $highest_fine) {
		$student_to_expel = $student;
		$highest_fine = $sheet{$student};
	}
}

print "Expel $student_to_expel whose library fines total \$$highest_fine\n";
