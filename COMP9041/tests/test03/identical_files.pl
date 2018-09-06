#!/usr/bin/perl -w

if (@ARGV == 0) {
	print "Usage: ./identical_files.pl <files>\n";
	exit;
}

open FILE_1, '<', "$ARGV[0]" or die;

while (my $line = <FILE_1>) {
	$init_str .= $line;
}

$hash{$init_str} = 0;

foreach $f (@ARGV) {
	open my $file, '<', "$f" or die;
	my $str = "";
	while (my $line = <$file>) {
		$str .= $line;
	}
	if (!defined $hash{$str}) {
			print "$f is not identical\n";
			exit;
	}
	close $file;
}
print "All files are identical\n";
