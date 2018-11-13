#!/usr/bin/perl

$u = $ARGV[0];
$v = $ARGV[1];
while ($v) {
	$t = $u;
	$u = $v;
	$v = $t % $v;
}
if ($u < 0) {
	$u = - $u;
}
print "The gcd of $ARGV[0] and $ARGV[1] is $u\n"
