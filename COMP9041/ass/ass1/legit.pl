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
	my @files = @_;
	foreach my $file (@files) {
		# terminate if ordinary file is not start with an alphanumeric character or contains any illegal characters
		if ("$file" !~ /^[a-zA-Z0-9]/ || "$file" =~ /[^._a-zA-Z0-9-]/) {	
			print "legit.pl: error: invalid filename '$file'\n";
			exit 1;
		}	
		if (!-e "$file") {				# terminate if added file doesn't exist
			print "legit.pl: error: can not open '$file'\n";
			exit 1;	
		}
	}
	if (!-d $index_path) {
		mkdir "$index_path" or die;		# create index dir in repo if it doesn't exist
	}
	foreach my $file (@files) {
		cp "$file", $index_path;		# copy files to index dir
	}
}

sub commit {
	my $error_msg = "usage: legit.pl commit [-a] -m commit-message";
	my @commit_commands = @_;			# get parameters after "./legit.pl commit"
	my $length_of_commands = @commit_commands;
	if ($length_of_commands == 0) {		# return error message if nothing follows "commit"
		print "$error_msg\n";
		exit 1;
	}
	elsif ($length_of_commands == 2 && $commit_commands[0] eq "-m") {					
		commit_file($commit_commands[1]);			# pass commit message to commit_file function in "commit -m case"
	} 
	elsif ($length_of_commands == 3 && $commit_commands[0] eq "-a" && $commit_commands[1] eq "-m") {
		my @index_files = glob "$index_path/*";		# get all files already in the index
		for $index_file (@index_files) {
			if (-e $index_file) {
				my @name_without_path = split('/', $index_file);	# get file name after the last slash for using add() function
				@name_without_path = $name_without_path[-1];
				if (-e "@name_without_path") {		
					add (@name_without_path);	# add current file to index if exists
				} 
			}
			else {
				unlink "$index_path/$index_file";	# delete the file is it doesn't exist in current dir
			}
		}
		commit_file($commit_commands[2]);			# pass commit message to commit_file function in "commit -a -m case"
	} 
	else {
		print "$error_msg\n";
		exit 1;
	}
}

sub commit_file {
	my @commit_msg = @_;		# get commit message from commit() function
	my $commit_time = 0;		# set a counter to record dir retrieve times
	my $commited_folder = "$legit_dir/".".commit";
	my $folder = "$commited_folder"."$commit_time";
	my $index_content = "";
	my $last_commit_content = "";
	my @index_files = glob "$index_path/*";
	if (!defined $index_files[0]) {
		print "nothing to commit\n";
		exit 1;
	}
	foreach my $index_file (@index_files) {
		open my $file, '<', "$index_file" or die;
		my @name_without_path = split('/', $index_file);
		@name_without_path = $name_without_path[-1];
		$index_content .= "@name_without_path\n";		
		while (my $line = <$file>) {
			$index_content .= $line;
		}
		close $file;
		}
	while (-d $folder) {
		$commit_time += 1;
		$folder = "$commited_folder"."$commit_time";
	}
	if ($commit_time > 0) {
		$last_commit_time = $commit_time - 1;
		my $last_commit_folder = "$commited_folder"."$last_commit_time";
		my @last_commit_files = glob "$last_commit_folder/*";
		foreach my $last_commit_file (@last_commit_files) {
			open my $file, '<', "$last_commit_file" or die;
			my @name_without_path = split('/', $last_commit_file);
			@name_without_path = $name_without_path[-1];
			$last_commit_content .= "@name_without_path\n";		
			while (my $line = <$file>) {
				$last_commit_content .= $line;
			}
		close $file;
		}
		if ($index_content eq $last_commit_content) {
			print "nothing to commit\n";
			exit 1;
		}
	}
	my $new_folder = "$commited_folder"."$commit_time";
	mkdir "$new_folder";
	foreach my $file (glob "$index_path/*") {
		cp $file, "$new_folder"			# copy files from index to new commit dir
	}
	open my $file, '>>', "$legit_log" or die;	# write commit time and commit message to legit log
	print $file "$commit_time @commit_msg\n";
	close $file;
	print "Committed as commit $commit_time\n";
}

sub show {
	if ($#ARGV != 1) {					# show() should has two parameters
		print "usage: legit.pl <commit>:<filename>\n";
		exit 1;
	}
	my ($commit_time, $filename) = split(/:/, $ARGV[1]);	# split <commit_time>:<$filename> 
	if ("$filename" !~ /^[a-zA-Z0-9]/ || "$filename" =~ /[^._a-zA-Z0-9-]/) {
		print "legit.pl: error: invalid filename '$filename'\n";
		exit 1;
	}
	if ($commit_time eq "") {			# is commit_time is null, find filename in index
		if (!-e "$index_path/$filename") {
			print "legit.pl: error: '$filename' not found in index\n";
			exit 1;
		}
		if (!-e "$legit_log") {			# repo has no commits if legit_log is not created
			print "legit.pl: error: your repository does not have any commits yet\n";
			exit 1;		
		}
		open my $file, '<', "$index_path/$filename";	# print the file if it exists in index
		foreach $line (<$file>)	{
			print "$line";
		}
		close $file;
		return 0;						# return successfully
	}
	if ($commit_time =~ /\D/) {			# return unknown commit if commit_time has nondigits
		print "legit.pl: error: unknown commit '$commit_time'\n";
		exit 1;
	}
	# retrieve all commit dir to find the one matches commit_time and check whether filename exists in the dir
	my $num = 0;
	while (-d "$legit_dir/".".commit"."$num") {
		if ($num == $commit_time) {
			my $file_to_show = "$legit_dir/".".commit"."$num/"."$filename";
			if (!-e $file_to_show) {
				print "legit.pl: error: '$filename' not found in commit $commit_time\n";
				exit 1;
			}
			open my $file, '<', "$file_to_show";
			foreach $line (<$file>) {
				print "$line";
			}
			close $file;
			return 0;					# print file and return successfully
		}
		$num += 1;
	}
	print "legit.pl: error: unknown commit '$commit_time'\n";
}

sub _log {
	if (!-e $legit_log) {					# return error if no commits
		print "legit.pl: error: your repository does not have any commits yet\n";
		exit 1;
	}
	open my $file, '<', "$legit_log";
	my @log_content = <$file>;
	close $file;
	foreach my $line (reverse @log_content) {		# print legit log in reversed sequence
		print "$line";
	}	
}

sub rm {
	my @rm_command = @_;
	#foreach my $element (@rm_command)
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
	elsif (!-d "$legit_dir") {			# terminate if repo has not been created
		print "legit.pl: error: no .legit directory containing legit repository exists\n";
		exit 1;		
	}
	elsif ($command eq "add") {
		add(@ARGV[1..$#ARGV]);			# execute add() function
	}
	elsif ($command eq "commit") {
		commit(@ARGV[1..$#ARGV]);		# execute commit() function
	}
	elsif ($command eq "show") {
		show();							# execute show() function
	}
	elsif ($command eq "log") {
		_log();							# execute _log() function
	}
	elsif ($command eq "rm") {
		rm(@ARGV[1..$#ARGV]);							# execute rm() function
	}
	#else {								# terminate if command is not valiable
	#	print "@commands_hint";
	#	exit 1;
	#}
}

