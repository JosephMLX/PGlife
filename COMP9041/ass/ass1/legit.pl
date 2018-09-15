#!/usr/bin/perl -w

use File::Copy "cp";

$legit_dir = ".legit";					# create a directory named .legit
$index_path = "$legit_dir/index";		# index path in repo
$legit_log = "$legit_dir/.log.txt";		# legit log file
@commands_hint = "Usage: legit.pl <command> [<args>]\n
These are the legit commands:
   init       Create an empty legit repository
   add        Add file contents to the index
   commit     Record changes to the repository
   log        Show commit log
   show       Show file at particular state
   rm         Remove files from the current directory and from the index
   status     Show the status of files in the current directory, index, and repository
   branch     list, create or delete a branch
   checkout   Switch branches or restore current directory files
   merge      Join two development histories together\n\n";
# legit commands hint for user when a bad command happens

main();		# execute the main funciton

sub init {
	if ($#ARGV != 0) {					# terminate if init command follows with anything
		print "usage: legit.pl init\n";
		exit 1;					
	}
	if (-d "$legit_dir") {				# terminate if the dir already exists	
		print "legit.pl: error: .legit already exists\n";	
		exit 1;
	}
	mkdir "$legit_dir" or die;			# create repo
	print "Initialized empty legit repository in $legit_dir\n";
}

sub add {
	if (!-d "$legit_dir") {				# terminate if repo has not been created
		print "legit.pl: error: no .legit directory containing legit repository exists\n";
		exit 1;		
	}
	foreach my $i (1..$#ARGV) {
		# terminate if ordinary file is not start with an alphanumeric character or contains any illegal characters
		if ("$ARGV[$i]" !~ /^[a-zA-Z0-9]/ || "$ARGV[$i]" =~ /[^._a-zA-Z0-9-]/) {	
			print "legit.pl: error: invalid filename '$ARGV[$i]'\n";
			exit 1;
		}	
		if (!-e "$ARGV[$i]") {			# terminate if added file doesn't exist
			print "legit.pl: error: can not open '$ARGV[$i]'\n";
			exit 1;	
		}
	}
	if (!-d $index_path) {
		mkdir "$index_path" or die;		# create index dir in repo if it doesn't exist
	}
	foreach my $i (1..$#ARGV) {
		cp "$ARGV[$i]", $index_path;			# copy files to index dir
	}
}

sub commit {
	my $error_msg = "usage: legit.pl commit [-a] -m commit-message";
	my $commit_time = 0;
	if ($ARGV[1] eq "-m") {				
		if ($#ARGV != 2) {				# terminate if not in <./legit.pl commit -m ''> format
			print "$error_msg\n";
			exit 1;
		}
		print "hola\n";
	}
	else {
		print "$error_msg\n";
		exit 1;
	}
}

sub show {
	if ($#ARGV != 1) {					# show() should has two parameters
		print "usage: legit.pl <commit>:<filename>\n";
		exit 1;
	}
	my ($commit, $filename) = split(/:/, $ARGV[1]);
	if ("$filename" !~ /^[a-zA-Z0-9]/ || "$filename" =~ /[^._a-zA-Z0-9-]/) {
		print "legit.pl: error: invalid filename '$filename'\n";
		exit 1;
	}
	if ($commit eq "") {
		if (!-e "$index_path/$filename") {
			print "legit.pl: error: '$filename' not found in index\n";
			exit 1;
		}
		if (!-e "$legit_log") {
			print "legit.pl: error: your repository does not have any commits yet\n";
			exit 1;		
		}
		open my $file, '<', "$index_path/$filename";
		foreach $line (<$file>)	{
			print "$line";
		}
		close $file;
	}
}

sub _log {

}

sub main {
	if ($#ARGV == -1) {					# non-command message and command hints
		print "@commands_hint";
		exit 1;
	}
	my $command = $ARGV[0];				# get user's command
	if ($command eq "init") {	
		init();							# execute init() function
	}
	if ($command eq "add") {
		add();							# execute add() function
	}
	if ($command eq "commit") {
		commit();						# ex
	}
	if ($command eq "show") {
		show();
	}
	if ($command eq "log") {
		_log();
	}
	#else {								# terminate if command is not valiable
	#	print "@commands_hint";
	#	exit 1;
	#}
}

