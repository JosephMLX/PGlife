#!/usr/bin/perl -w

$shell_line = "        n=$(3 * n + 1)";

if ($shell_line =~ /\(.*[<=>] | \([<=>]=/) {
		my @line_splited = split ('\(', $shell_line);
		$line_splited[1] =~ s/\) \{//;
		my @caculate = split (' ', $line_splited[1]);
		my $item = @caculate;
		my $i = 0;
		while ($i < $item) {
			if ($caculate[$i] =~ /[a-z]/ and $caculate[$i] !~ /\$/) {
			$caculate[$i] = "\$$caculate[$i]";
			}
			$i += 1;
		}
		$line_splited[1] = join(' ', @caculate);
		$line_splited[1] = "\($line_splited[1]\) \{";
		$shell_line = join('', $line_splited[0],$line_splited[1]);
	} elsif ($shell_line =~ /.*[a-z]=/) {
		my @equation = split('=', $shell_line);
		$equation[0] =~ /([a-z])/;
		my $var_1 = "\$$1";
		$equation[0] =~ s/$1/$var_1/;
		my @caculate = split(' ', $equation[1]);
		my $items = @caculate;
		my $i = 0;
		while ($i < $items) {
			if ($caculate[$i] =~ /[a-z]/ and $caculate[$i] !~ /\$/) {
				$caculate[$i] = "\$$caculate[$i]";
			}
			$i += 1;
		}
		$equation[1] = join(' ', @caculate);
		$equation[1] = $equation[1].";";
		$shell_line = join(' = ', $equation[0], $equation[1]);
	}
	print "$shell_line\n";
print "$shell_line\n";
