#!/usr/bin/perl -w
$time = $ARGV[0];
$content = $ARGV[1];

to_perl($time, $content);
sub to_perl {
	my $print_time = $_[0];
	my $print_content = $_[1];
	if ($print_time == 1) {
		$print_content =~ s/\\/\\\\/g;
		$print_content =~ s/\"/\\\"/g;
		$print_content = "print \"$print_content\\n\"\;";
		print "$print_content\n";
		return;
	}
	$print_content =~ s/\\/\\\\/g;
	$print_content =~ s/\"/\\\"/g;
	$print_content = "print \"$print_content\\n\"\;";
	$print_time -= 1;
	to_perl($print_time, $print_content);
}

