#!/usr/bin/perl -w

use File::Copy "cp";

$filename = $ARGV[0];
$num = 0;
$flag = 0;
$backupname = "."."$filename".".$num";
while ($flag == 0) {
	if (-e "$backupname") {
		$num += 1;
		$backupname = "."."$filename".".$num";
	} else {
		$new_backupname = "."."$filename".".$num";
		cp $filename, $new_backupname;
		$flag = 1;
	}
}

print "Backup of '$filename' saved as '$new_backupname'\n";
