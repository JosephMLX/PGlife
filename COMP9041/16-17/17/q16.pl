#!/usr/bin/perl

@result = ();
$max_num = 0;

while ($line = <STDIN>) {
	if($line =~ /([0-9]+)/) {
		if ( $max_num < ($1 + 0) ) {
			$max_num = ($1 + 0);
			@result = ();
			push @result, $line;
		}
		elsif ( $max_num == ($1 + 0) ) {
			push @result, $line;
		}
	}
}

$result_str = join('',@result);
print "$result_str";
