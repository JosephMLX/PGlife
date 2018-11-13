#!/usr/bin/perl -w

@n = ("hello", "world", 4, 8, 10, "12");
$a = @n;
$b = $#n;
$c = $n[$b];
print "$b";
print "$a $c @n\n";
print @n;
