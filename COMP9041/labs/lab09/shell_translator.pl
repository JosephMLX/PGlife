#!/usr/bin/perl -w

my $shell_script = $ARGV[0];
open my $file, '<', "$shell_script" or die;

my @shell_lines = <$file>;
chomp @shell_lines;

foreach my $shell_line (@shell_lines) {
	$shell_line =~ s/\bdone\b/}/g;
	$shell_line =~ s/\bfi\b/}/g;
	$shell_line =~ s/\belse\b/\} else \{/g;
	if ($shell_line =~ /while | if/) {
		$shell_line =~ s/\(\(/\(/g;
		$shell_line =~ s/\)\)/\)/g;
		$shell_line = "$shell_line \{";
	} else {
		$shell_line =~ s/\(\(//g;
		$shell_line =~ s/\)\)//g;
	}
}

foreach my $shell_line (@shell_lines) {
	if ($shell_line =~ /#!/) {
		$shell_line = "#!/usr/bin/perl -w";
	} elsif ($shell_line =~ /[a-z]+=[0-9]+/) {
		my ($virable, $value) = split ('=', $shell_line);
		$shell_line = "\$$virable = $value;";
	} elsif ($shell_line =~ /echo+/) {
		my @array = split(/(echo )/, $shell_line);
		$array[1] =~ s/echo/print/;
		$array[2] = "\"$array[2]\\n\"";
		$shell_line = join('', @array);
	}
}

foreach my $shell_line (@shell_lines) {
	next if ($shell_line eq "" or $shell_line =~ /do/ or $shell_line =~ /then/);
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
}
close $file;

