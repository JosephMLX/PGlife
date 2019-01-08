#!/usr/bin/perl -w

while ($line = <>) {
	$line =~ /([\d]{2}\:[\d]{2}\:[\d]{2})/g;
	print $1;
}
