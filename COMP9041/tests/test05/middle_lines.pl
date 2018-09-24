#!/usr/bin/perl -w

if ($ARGV[0] eq "/dev/null") {
	exit 1;
}

$filename = $ARGV[0];
open $file, '<', "$filename" or die;
@content = <$file>;
$lines = @content;
if ($lines % 2 == 0) {
	$second_line = ($lines / 2);
	$first_line = $second_line - 1;
	print "$content[$first_line]";
	print "$content[$second_line]";
}
else {
	$middle_line = (($lines-1) / 2);
	print "$content[$middle_line]";
	}
close $file;
