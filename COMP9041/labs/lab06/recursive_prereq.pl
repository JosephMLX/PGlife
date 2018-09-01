#!/usr/bin/perl -w

sub recursive {
	my $course = $_[0];
	my $ug = "undergraduate";
	my $pg = "postgraduate";
	my $url_ug = "http://www.handbook.unsw.edu.au/$ug/courses/2018/$course.html";
	my $url_pg = "http://www.handbook.unsw.edu.au/$pg/courses/2018/$course.html";
	open my $F, "wget -q -O- $url_ug $url_pg|" or die;	# open multiple urls

	while ($line = <$F>) {
		chomp $line;
		if ($line =~ /Prereq/) {
			$line =~ s/<\/p>.*//;
			my @arr = split ' ', $line;
			foreach my $i (@arr) {
				$i =~ s/\.//;
				if ($i =~ /([A-Z]{4}[0-9]{4})/) {
					$i = $1;
					$courses{$i} = 0;
					#print "$i\n";
					recursive($i);
				}
			}
		}
	}
}

if ($#ARGV == 0) {
	my $course = $ARGV[0];
	$ug = "undergraduate";
	$pg = "postgraduate";
	$url_ug = "http://www.handbook.unsw.edu.au/$ug/courses/2018/$course.html";
	$url_pg = "http://www.handbook.unsw.edu.au/$pg/courses/2018/$course.html";

	open F, "wget -q -O- $url_ug $url_pg|" or die;	# open multiple urls

	while ($line = <F>) {
		chomp $line;
		if ($line =~ /Prereq/) {
			$line =~ s/<\/p>.*//;
			@arr = split ' ', $line;
			foreach $i (@arr) {
				$i =~ s/\.//;
				if ($i =~ /([A-Z]{4}[0-9]{4})/) {
					$i = $1;
					$hash{$i} = 0;
				}
			}
		}
	}
	for $key (sort keys %hash) {
		print "$key\n";
	}
}

if ($#ARGV == 1) {
	recursive($ARGV[1]);
}
foreach $key (sort keys %courses) {
	print "$key\n";
}

