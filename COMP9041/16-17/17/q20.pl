#!/usr/bin/perl -w

$filename = $ARGV[0];
$pattern = $ARGV[1];
@plaintext = ();
@password = ();

sub mapLetter {
	my $s = $_[0];
	if ($s =~ /[a-c]/) {
		return 2;
	}
	elsif ($s =~ /[d-f]/) {
		return 3;
	}
	elsif ($s =~ /[g-i]/) {
		return 4;
	}
	elsif ($s =~ /[j-l]/) {
		return 5;
	}
	elsif ($s =~ /[m-o]/) {
		return 6;
	}
	elsif ($s =~ /[p-s]/) {
		return 7;
	}
	elsif ($s =~ /[t-v]/) {
		return 8;
	}
	return 9;
}

open my $file, '<', "$filename" or die;
foreach my $line (<$file>) {
	chomp $line;
	my @words = split / /, $line;
	foreach my $word (@words) {
		if ($word =~ /^[a-z]+$/) {
			push @plaintext, $word;
		}
	}
}
foreach my $word (@plaintext) {
	my @to_trans = split //, $word;
	my $transed = "";
	foreach $l (@to_trans) {
		$transed .= mapLetter($l);
	}
	push @password, $transed;
}
foreach my $i (0..$#password) {
	if ($password[$i] eq $pattern) {
		print "$plaintext[$i]\n";
	}
}
foreach my $i (0..$#password) {
	foreach my $j (0..$#password) {
		my $combined = "$password[$i]"."$password[$j]";
		if ($combined eq $pattern) {
			print "$plaintext[$i] $plaintext[$j]\n";
		}
	} 
}
