#!/usr/bin/perl -w
# sum the integers $start .. $finish
$start = 1;
$finish = 100;
$sum = 0;
$i = 1;
while ($i <= $finish) {
    $sum = $sum + $i;
    $i = $i + 1;
}
print "Sum of the integers $start .. $finish = $sum\n"
