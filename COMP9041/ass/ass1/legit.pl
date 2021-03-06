#!/usr/bin/perl -w

use File::Copy "cp";
use File::Compare;
use File::Path "rmtree";
use Cwd qw();

$legit_dir = ".legit";					# create repo .legit
$index_path = "$legit_dir/index";		# index path in repo
$legit_bch = "$legit_dir/.branch.txt";  # legit branch file
$is_force = 0;							# force authority, overwritten in rm function
$current_branch = "$legit_dir/.current_branch.txt";		# default branch
$dir = Cwd::cwd();
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

# caculate total commit time, by caculating commit folders
sub commit_time {
	my $commit_time = 0;		# set a counter to record dir retrieve times
	my $commited_folder = "$legit_dir/".".commit";
	my $folder = "$commited_folder"."$commit_time";
	while (-d $folder) {
		$commit_time += 1;
		$folder = "$commited_folder"."$commit_time";
	}
	return $commit_time;
}
# get which branch is currently on
sub current_branch {
	open my $file, '<', "$current_branch" or die;
	my @current_branch = <$file>;
	close $file;
	return @current_branch;
}
# main function of init function
sub init {
	if ($#ARGV != 0) {				# terminate if init command follows with anything
		print "usage: legit.pl init\n";
		exit 1;
	}
	if (-d "$legit_dir") {			# terminate if the dir already exists
		print "legit.pl: error: .legit already exists\n";
		exit 1;
	}
	mkdir "$legit_dir" or die;		# create repo
	open my $file1, '>', "$legit_bch" or die;
	print $file1 "master\n";		# add init master branch to branch record
	close $file1;
	open my $file2, '>', "$current_branch" or die;
	print $file2 "master";			# set current branch as 'master'
	close $file2;
	print "Initialized empty legit repository in $legit_dir\n";
}

sub add {
	my @files = @_;
	my @current_branch = current_branch();
	my $current_index = "$index_path"."_@current_branch";
	foreach my $file (@files) {
		# terminate if ordinary file is not start with an alphanumeric character or contains any illegal characters
		if ("$file" !~ /^[a-zA-Z0-9]/ || "$file" =~ /[^._a-zA-Z0-9-]/) {
			print "legit.pl: error: invalid filename '$file'\n";
			exit 1;
		}
		if (!-e "$file" && !-e "$index_path/$file") {				# terminate if added file doesn't exist
			print "legit.pl: error: can not open '$file'\n";
			exit 1;
		}
	}
	if (!-d $index_path) {
		mkdir "$index_path" or die;		    # create main stream index dir in repo if it doesn't exist
	}
	if (!-d $current_index) {
		mkdir "$current_index" or die;		# create current branch index dir in repo if it doesn't exist
	}
	foreach my $file (@files) {
		if (-e "$index_path/$file" && !-e "$file") {
			unlink "$index_path/$file";     # delete file in main stream index but not in local dict
			unlink "$current_index/$file";  # delete file in current branch index but not in local dict
		}
		cp "$file", $index_path;		    # copy files to main stream index dir
		cp "$file", $current_index;			# copy files to index dir on current branch
	}
}
# main function of commit function
sub commit {
	my $error_msg = "usage: legit.pl commit [-a] -m commit-message";
	my @commit_commands = @_;			      # get parameters after "./legit.pl commit"
	my $length_of_commands = @commit_commands;
	if ($length_of_commands == 0) {		  # return error message if nothing follows "commit"
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
# function called to commit files in index
sub commit_file {
	my @commit_msg = @_;		# get commit message from commit() function
	my $commit_time = 0;
	my $commited_folder = "$legit_dir/".".commit";
	my $folder = "$commited_folder"."$commit_time";		# foldername ends with commit time
	my @current_branch = current_branch();
	my @index_files = glob "$index_path/*";
	if (!defined $index_files[0] && !-d $folder) {
		print "nothing to commit\n";
		exit 1;
	}
	if (compare_with_last_commit() == 1) {
		print "nothing to commit\n";
		exit 1;
	}
	$commit_time = commit_time();
	my $new_folder = "$commited_folder"."$commit_time";
	mkdir "$new_folder";
	foreach my $file (glob "$index_path/*") {
		cp $file, "$new_folder"			# copy files from index to new commit dir
	}
	my $log = "$legit_dir/.@current_branch"."_log.txt";
	open my $file, '>>', "$log" or die;	# write commit time and commit message to legit log
	print $file "$commit_time @commit_msg\n";
	close $file;
	print "Committed as commit $commit_time\n";
}
# funciton used to compare index files and last commit files
sub compare_with_last_commit {
	my $commit_time = commit_time();
	my $commited_folder = "$legit_dir/".".commit";
	my $index_content = "";
	my $last_commit_content = "";
	my @index_files = glob "$index_path/*";
	foreach my $index_file (@index_files) {    # write all files in index as a string
		open my $file, '<', "$index_file" or die;
		my @name_without_path = split('/', $index_file);
		@name_without_path = $name_without_path[-1];
		$index_content .= "@name_without_path\n";
		while (my $line = <$file>) {
			$index_content .= $line;
		}
		close $file;
	}
	if ($commit_time > 0) {                    # write all files in last commit as a string
		my $last_commit_time = $commit_time - 1;
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
		if ($index_content eq $last_commit_content) {     # compare two strings
			return 1;			# equal
		} else {
			return 0;			# not equal
		}
	}
}
# main function of show function
sub show {
	my $_commit_time = commit_time();
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
		if ($_commit_time == 0) {			# repo has no commits if commit time is 0
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
# main function of log function
sub _log {
	my @current_branch = current_branch();
	my $log = "$legit_dir/.@current_branch"."_log.txt";
	if (!-e $log) {					# return error if no commits
		print "legit.pl: error: your repository does not have any commits yet\n";
		exit 1;
	}
	open my $file, '<', "$log";
	my @log_content = <$file>;
	close $file;
	foreach my $line (reverse @log_content) {		# print legit log in reversed sequence
		print "$line";
	}
}
# main function of rm function
sub rm {
	my @rm_command = @_;
	my $commit_time = 0;		# set a counter to record dir retrieve times
	my $commited_folder = "$legit_dir/".".commit";
	my $folder = "$commited_folder"."$commit_time";
	my $index_content = "";
	my $last_commit_content = "";
	my @index_files = glob "$index_path/*";
	if (!-d "$folder") {
		print "legit.pl: error: your repository does not have any commits yet\n";
		exit 1;
	}
	$commit_time = commit_time();
	if ($commit_time > 0) {
		$commit_time--;
	}
	my $last_commit_folder = "$commited_folder"."$commit_time";
	if ($rm_command[0] eq "--cached") {
		shift @rm_command;
		if ($rm_command[0] eq "--force") {
			$is_force = 1;
			shift @rm_command;
		}
		rm_check(@rm_command);
		foreach my $filename (@rm_command) {
			if (!-e "$index_path/$filename") {
				print "legit.pl: error: '$filename' is not in the legit repository\n";
				exit 1;
			}
			if ($is_force == 1) {			# with force authority
				unlink "$index_path/$filename";
			}
			elsif (compare("$filename", "$index_path/$filename") != 0 && compare("$index_path/$filename", "$last_commit_folder/$filename") != 0) {
				print "legit.pl: error: '$filename' in index is different to both working file and repository\n";
				exit 1;
			}
			unlink "$index_path/$filename";
		}
	}
	elsif ($rm_command[0] eq "--force") {	# overwrite authority and use recursion
		shift @rm_command;
		$is_force = 1;
		rm(@rm_command);
	}
	else {
		rm_check(@rm_command);
		foreach my $filename (@rm_command) {
			if (!-e "$index_path/$filename") {
					print "legit.pl: error: '$filename' is not in the legit repository\n";
					exit 1;    # file not exists in index
			}
			if ($is_force == 1) {			# with force authority
				unlink "$index_path/$filename";
				unlink "$filename";
			}
			elsif (compare("$filename", "$index_path/$filename") != 0 && compare("$index_path/$filename", "$last_commit_folder/$filename") != 0) {
				print "legit.pl: error: '$filename' in index is different to both working file and repository\n";
				exit 1;      # files in index and local and last commit are different
			}
			elsif (compare("$filename", "$index_path/$filename") != 0) {
				print "legit.pl: error: '$filename' in repository is different to working file\n";
				exit 1;      # files in index and local are different
			}
			elsif (compare("$index_path/$filename", "$last_commit_folder/$filename") != 0) {
				print "legit.pl: error: '$filename' has changes staged in the index\n";
				exit 1;      # files in index and last commit are different
			}
			unlink "$index_path/$filename";
			unlink "$filename";
		}
	}
}
# check whether files and commands in rm function are available
sub rm_check {
	my $err_msg = "usage: legit.pl rm [--force] [--cached] <filenames>";
	@rm_command = @_;
	foreach my $filename (@rm_command) {
		if ($filename =~ /^-.*/) {
			print "$err_msg\n";
			exit 1;
		}
		elsif ("$filename" !~ /^[a-zA-Z0-9]/ || "$filename" =~ /[^._a-zA-Z0-9-]/) {
			print "legit.pl: error: invalid filename '$filename'\n";
			exit 1;
		}
	}
}
# main function of status function
sub status {
	my $commit_time = commit_time();
	if ($commit_time == 0) {
		print "legit.pl: error: your repository does not have any commits yet\n";
		exit 1;
	}
	$commit_time--;
	my $file_hash = {};
  	my $commited_folder = "$legit_dir/".".commit";
  	my $last_commit_folder = "$commited_folder"."$commit_time";
  	my @index_files = glob "$index_path/*";
  	my @last_commit_files = glob "$last_commit_folder/*";
  	my @local_files = glob "$dir/*";
  	foreach my $local_file (@local_files) {
    	my @name_without_path = split('/', $local_file);
    	@name_without_path = $name_without_path[-1];
    	$file_hash{"@name_without_path"} = 0;
  	}
  	foreach my $index_file (@index_files) {
    	my @name_without_path = split('/', $index_file);	# get file name after the last slash for using add() function
    	@name_without_path = $name_without_path[-1];
    	$file_hash{"@name_without_path"} = 0;
  	}
  	foreach my $last_commit_file (@last_commit_files) {
    	my @name_without_path = split('/', $last_commit_file);	# get file name after the last slash for using add() function
    	@name_without_path = $name_without_path[-1];
    	$file_hash{"@name_without_path"} = 0;
  	}
  	foreach $key (keys %file_hash) {
    	if (!-e "$dir/$key" && !-e "$index_path/$key") {
      		$file_hash{$key} = "$key - deleted";
    	}
    	elsif (!-e "$index_path/$key" && -e "$dir/$key") {
      		$file_hash{$key} = "$key - untracked";
    	}
    	elsif (-e "$index_path/$key" && !-e "$last_commit_folder/$key") {
      		$file_hash{$key} = "$key - added to index";
    	}
    	elsif (!-e "$dir/$key" && (-e "$index_path/$key" || -e "$last_commit_folder/$key")) {
      		$file_hash{$key} = "$key - file deleted";
    	}
    	elsif (compare("$dir/$key", "$index_path/$key") == 0 && compare("$index_path/$key", "$last_commit_folder/$key") == 0 && compare("$dir/$key", "$last_commit_folder/$key") == 0) {
      		$file_hash{$key} = "$key - same as repo";
    	}
    	elsif (compare("$dir/$key", "$index_path/$key") != 0 && compare("$index_path/$key", "$last_commit_folder/$key") != 0 && compare("$dir/$key", "$last_commit_folder/$key") != 0) {
      		$file_hash{$key} = "$key - file changed, different changes staged for commit";
    	}
    	elsif (compare("$dir/$key", "$index_path/$key") == 0 && compare("$index_path/$key", "$last_commit_folder/$key") != 0) {
      		$file_hash{$key} = "$key - file changed, changes staged for commit";
    	}
    	elsif (compare("$dir/$key", "$index_path/$key") != 0 && compare("$index_path/$key", "$last_commit_folder/$key") == 0) {
      		$file_hash{$key} = "$key - file changed, changes not staged for commit";
    	}
  	}
  	foreach $key (sort keys %file_hash) {
  		print "$file_hash{$key}\n";
  	}
}
# main function of branch function
sub branch {
	my @branch_command = @_;
	my $command_length = @branch_command;
	my $commit_time = commit_time();
	my @current_branch = current_branch();
	my @index_files = glob "$index_path/*";
	open my $file, '<', "$legit_bch" or die;
	my @branches = <$file>;			# all existed branches
	close $file;
	if ($commit_time == 0) {		# terminate if no commits
		print "legit.pl: error: your repository does not have any commits yet\n";
		exit 1;
	}
	if ($command_length == 0) {		# print all branches in alphabetical order
		foreach my $branch (sort {$a cmp $b} @branches) {
			print "$branch";
		}
	}
	elsif ($branch_command[0] ne "-d") {
		if ($command_length > 1) {		# illegal command
			print "usage: legit.pl branch [-d] <branch>\n";
			exit 1;
		}
		elsif ($branch_command[0] =~ /^\*.*/) {
			print "legit.pl: error: branch name '$branch_command[0]'\n";	# invalid branch name
			exit 1;
		}			
		elsif (grep (/^$branch_command[0]$/, @branches)) {		# terminate if branch exists
			print "legit.pl: error: branch '$branch_command[0]' already exists\n";
			exit 1;
		}
		elsif ("$branch_command[0]" !~ /^[a-zA-Z0-9]/ || "$branch_command[0]" =~ /[^._a-zA-Z0-9-]/) {
			print "legit.pl: error: branch name '$branch_command[0]'\n";	# invalid branch name
			exit 1;
		}
		else {				# append new branch name to legit branch file
			open my $file, '>>', "$legit_bch" or die;
			print $file "$branch_command[0]\n";
			my $current_log = "$legit_dir/.@current_branch"."_log.txt";
			my $log = "$legit_dir/.$branch_command[0]"."_log.txt";
			cp $current_log, $log;
			my $current_index = "$index_path"."_$branch_command[0]";
			mkdir "$current_index";
			foreach my $file (@index_files) {
				cp $file, $current_index;
			}
		}
	}
	elsif ($branch_command[0] eq "-d") {
		shift @branch_command;
		if ($command_length > 2) {		# invalid command
			print "usage: legit.pl branch [-d] <branch>\n";
			exit 1;
		}
		elsif (grep (/^$branch_command[0]$/, @branches)) {
			if ($branch_command[0] eq "master") {      # master branch cannot be deleted
				print "legit.pl: error: can not delete branch 'master'\n";
				exit 1;
			}
			open my $file, '>', "$legit_bch" or die;   # delete branch and overwrite legit branch file
			foreach $branch (@branches) {
				chomp $branch;
				if ($branch ne $branch_command[0]) {
					print $file "$branch\n";
				}
			}
			close $file;
			print "Deleted branch '$branch_command[0]'\n";
			my $log = "$legit_dir/.$branch_command[0]"."_log.txt";
			my $current_index = "$index_path"."_$branch_command[0]";
			rmtree $current_index;		# delete index dir of this branch
			unlink $log;				# delete log of this branch
			return;
		}
		else {
			print "legit.pl: error: branch '$branch_command[0]' does not exist\n";
			exit 1;
		}
	}
}

sub checkout {
	my @new_branch = @_;
	my $command_length = @new_branch;
	open my $file1, '<', "$legit_bch" or die;
	my @branches = <$file1>;
	close $file1;
	open my $file2, '<', "$current_branch" or die;
	my @old_branch = <$file2>;
	close $file2;
	my $commit_time = commit_time();
	if ($commit_time == 0) {		# terminate if no commits
		print "legit.pl: error: your repository does not have any commits yet\n";
		exit 1;
	}
	$commit_time = $commit_time - 1;
	my $commited_folder = "$legit_dir/".".commit";
	my $last_commit_folder = "$commited_folder"."$commit_time";
	if ($command_length != 1) {		# invilid command
		print "usage: legit.pl checkout <branch>\n";
		exit 1;
	}
	elsif ("@new_branch" eq "@old_branch") {
		print "Already on '@old_branch'\n";
		exit 1;
	}
	elsif (grep /^@new_branch$/, @branches) {
		my $new_index = "$index_path"."_@new_branch";
		my $old_index = "$index_path"."_@old_branch";
		open my $file, '>', "$current_branch" or die;
		print $file @new_branch;
		close $file;
		foreach my $file (glob "$index_path/*") {		# clean the main stream index
			unlink $file;
		}
		foreach my $file (glob "$new_index/*") {		# replace with index current branch
			cp $file, $index_path;
		}
		foreach my $file (glob "$dir/*") {
			my @filename = split('/', $file);
			@filename = $filename[-1];
			if ($file ne "$dir/legit.pl" && !-e "$new_index/@filename" || compare("$file", "$new_index/@filename") == 0 || compare("$file", "$last_commit_folder/@filename") == 0) {
        		unlink $file;
			}
		}
		foreach my $file (glob "$new_index/*") {
			my @filename = split('/', $file);
			@filename = $filename[-1];
			if (!-e "$dir/@filename" || compare("@filename", "$old_index/@filename") == 0) {
          		cp $file, $dir;
			}
    		cp $file, $index_path;
		}
		print "Switched to branch '@new_branch'\n";
		return;
	}
	print "legit.pl: error: unknown branch '@new_branch'\n";
}

sub merge {
  print "hehe\n";
}

sub main {
	if ($#ARGV == -1) {					# non-command message and command hints
		print "@commands_hint";
		exit 1;
	}
	my $command = $ARGV[0];			# get user's command
	if ($command ne "init" && $command ne "add" && $command ne "commit" && $command ne "show" && $command ne "log" && $command ne "rm" && $command ne "status" && $command ne "branch" && $command ne "checkout" && $command ne "merge") {
		print "@commands_hint";
		exit 1;
	}
	if ($command eq "init") {
		init();							      # execute init() function
	}
	elsif (!-d "$legit_dir") {	# terminate if repo has not been created
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
		rm(@ARGV[1..$#ARGV]);			# execute rm() function
	}
	elsif ($command eq "status") {
		status();						# execute status() function
	}
	elsif ($command eq "branch") {
		branch(@ARGV[1..$#ARGV]);		# execute branch() function
	}
	elsif ($command eq "checkout") {
		checkout(@ARGV[1..$#ARGV]);		# execute checkout() function
	}
  	elsif ($command eq "merge") {
    	merge(@ARGV[1..$#ARGV]);
  	}
}
