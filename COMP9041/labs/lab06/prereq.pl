#!/usr/bin/perl -w

$course = $ARGV[0];
$ug = "undergraduate";
$pg = "postgraduate";
$url_ug = "http://www.handbook.unsw.edu.au/$ug/courses/2018/$course.html";
$url_pg = "http://www.handbook.unsw.edu.au/$pg/courses/2018/$course.html";
print "$url_pg", "\n";
open F, "wget -q -O- $url_ug|" or die;
# if it is a pg course, F is null, then scrap from pg website;
if (! <F>) {
	open F, "wget -q -O- $url_pg|" or die;
}
# open O, '>', "output.txt";
while ($line = <F>) {
	chomp $line;
    print $line;
}

# close O;