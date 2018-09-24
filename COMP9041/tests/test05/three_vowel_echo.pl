#!/usr/bin/perl -w

@words = @ARGV;
@selected_words = "";
foreach $word (@words) {
	if ($word =~ /[AEIOUaeiou]{3}/) {
		@selected_words = "@selected_words"."$word ";
	}
}
print "@selected_words\n";
