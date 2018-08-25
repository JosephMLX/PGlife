#!/usr/bin/perl -w

$lines = 10;       			  # set default lines to 10 

if (@ARGV == 0) {			  # read from standard input
	@file = <STDIN>;
	$file_lines = @file;
	if ($file_lines <= $lines) {
		print @file;
	} else {
		$file_lines -= $lines;
		foreach $i ($file_lines..$#file) {
			print $file[$i];
		}
	}
}

if (@ARGV > 0 && $ARGV[0] =~ /-(\d+)/) {	
	$ARGV[0] =~ s/-//;	# adjust the number of first argument -N
}

if (@ARGV > 0) {
	if ($ARGV[0] =~ /^\d+$/) {
		$lines = $ARGV[0];
		shift @ARGV;  			# if ARGV[0] is an integer, shift and set lines with it
	}
	$files = @ARGV;
	foreach $f (@ARGV) {
		if (!open(FILE, "<$f")) {
			print "$0: can't open $f\n";
		} else {
			if ($files > 1) {
				print "==> $f <==\n";
			}
			@file = <FILE>;
			$file_lines = @file;
			if ($file_lines <= $lines) {
				print @file;
			} else {
				$file_lines -= $lines;
				foreach $i ($file_lines..$#file) {
				print $file[$i];
				}
			}
			close (FILE);
		} 
	}			
}

