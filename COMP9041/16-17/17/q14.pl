#!/usr/bin/perl

@matching_list = grep { /^[1-9]+[0-9]*$/ } @ARGV;
@sorted_matching_list = sort {$a<=>$b}  @matching_list;
$sorted_matching_str = join(' ',@sorted_matching_list);
print "$sorted_matching_str\n";
