#!/usr/bin/perl

@file_list = sort @ARGV;
@same_file_lists = ();

$file_list_len = @file_list;
while ($file_list_len > 0)
{	
	@tmp_same_file_list = ();	
	push @tmp_same_file_list, $file_list[0];
	open(TARGET, "<$file_list[0]");
	splice(@file_list, 0, 1);	
	$file_list_len = @file_list;
	@target_file_content_list = <TARGET>;
	$target_file_content = join('', @target_file_content_list);
	for($i = 0; $i < $file_list_len; $i = $i + 1)
	{
		open(TMP, "<$file_list[$i]");
		@tmp_file_content_list = <TMP>;
		$tmp_file_content = join('', @tmp_file_content_list);
		if($target_file_content eq $tmp_file_content)
		{
			push @tmp_same_file_list, $file_list[$i];
			splice(@file_list, $i, 1);
			$file_list_len = @file_list;
			$i = $i - 1;
		}
	}
	$tmp_same_file_list_len = @tmp_same_file_list;
	if($tmp_same_file_list_len > 1)
	{
		$tmp_same_file_list_str = join(' ', @tmp_same_file_list);
		push @same_file_lists, $tmp_same_file_list_str;
	}
}

$result_str = join("\n", @same_file_lists);
print "$result_str\n";

