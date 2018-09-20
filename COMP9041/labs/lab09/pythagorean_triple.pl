#!/usr/bin/perl -w
$max = 42;
$a = 1;
while ($a < $max) {
    $b = $a;
    while ($b < $max) {
        $c = $b;
        while ($c < $max) {
            if ($a * $a + $b * $b == $c * $c) {
                print "$a $b $c is a Pythagorean Triple\n"
            }
            $c = $c + 1;
        }
        $b = $b + 1;
    }
    $a = $a + 1;
}
