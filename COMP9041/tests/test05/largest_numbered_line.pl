#!/usr/bin/perl -w

@lines = <STDIN>;
@print_lines = "";
$max = -9999;
foreach $line (@lines) {
	$new_line = $line;
	$new_line =~ s/[A-Za-z]//g;
	@line_content = split(' ', $new_line);
	foreach $word (@line_content) {
		if ($word =~ /^?\d+?$/ and $word > $max) {
			$max = $word;
			@print_lines = "$line";
		}
		elsif ($word =~ /^?\d+?$/ and $word == $max) {
			@print_lines = "@print_lines"."$line";		
		}
	}
}			
print "@print_lines";
