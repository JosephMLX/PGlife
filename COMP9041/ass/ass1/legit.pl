#!/usr/bin/perl -w

main();		# execute the main funciton

sub init {
	my $legit_dir = ".legit";	# create a directory named .legit
	if (-d $legit_dir) {		
		print "legit.pl: error: .legit already exists\n";	# terminate if the dir already exists
		exit 1;
	}
	mkdir "$legit_dir";			# it will use to store the repository
	print "Initialized empty legit repository in $legit_dir\n";
}






sub main {
	if ($#ARGV == -1) {			# non-command message and command hints
		print "Usage: legit.pl <command> [<args>]\n
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
		exit 1;
	}
	my $command = $ARGV[0];		# get user's command
	if ($command eq "init") {	
		init();					# execute init() function
	}
}

