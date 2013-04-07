#!/usr/bin/perl

#title           :mirror_by_tree.pl
#description     :copy files/directories into multiple unix remote machines reducing the copy work load from a single machine.
#pre-requisite   :The machine from where this script runs require ssh setup between this machine and the machines listed in machine list file.
#		 :if there are 8 machines, say we want to copy a directory/file into all machines in parallel, 
#		 :so that the copy workload will be distributed and happens in parallel.script output shown below.
#                : Machine list file has machine names from rrengamani-linux2 to rrengamani-linux8 and script is ran from rrengamani-linux.
#Output          :scp rrengamani@rrengamani-linux:/home/rrengamani/test.cc rrengamani@rrengamani-linux2:/home/rrengamani/test.cc &
#		 :wait;
#		 :copy distribution starts here. after the file is copied into rrengamani-linux2, the next copy load will happen from this machine into rrengamani-linux4.
#		 :scp rrengamani@rrengamani-linux:/home/rrengamani/test.cc rrengamani@rrengamani-linux3:/home/rrengamani/test.cc &
#		 :scp rrengamani@rrengamani-linux2:/home/rrengamani/test.cc rrengamani@rrengamani-linux4:/home/rrengamani/test.cc &
# 		 :wait;
#		 :scp rrengamani@rrengamani-linux:/home/rrengamani/test.cc rrengamani@rrengamani-linux5:/home/rrengamani/test.cc &
#		 :scp rrengamani@rrengamani-linux2:/home/rrengamani/test.cc rrengamani@rrengamani-linux6:/home/rrengamani/test.cc &
#		 :scp rrengamani@rrengamani-linux3:/home/rrengamani/test.cc rrengamani@rrengamani-linux7:/home/rrengamani/test.cc &
#		 :scp rrengamani@rrengamani-linux4:/home/rrengamani/test.cc rrengamani@rrengamani-linux8:/home/rrengamani/test.cc &
#		 :wait;
#		 :here the copy looks like 1, 2 ,4 just like forming a tree structure which distributes and runs the copy in parallel.
#author          :rengamanir
#date            :20111012
#version         :1.0
#usage           :Usage: mirror_by_tree.pl <MachineList> <Src_File_Full_Path> <Start_Machine> <Login> FILE|DIRECTORY
Example		 : ./mirror_by_tree.pl MachineList /home/rrengamani/test.cc rrengamani-linux rrengamani FILE > scp.out
#		 : chmod +x scp.out
#		 : ./scp.out
#=====================================================================================================================

use POSIX qw(ceil floor);

if ($#ARGV != 4) {
    print "Usage: mirror_by_tree.pl <MachineList> <Src_File_Full_Path> <Start_Machine> <Login> FILE|DIRECTORY\n";
    exit;
}

open $in, "<$ARGV[0]";
@mach = ();
push @mach, $ARGV[2];
while(<$in>){
    chomp;
    push @mach, $_ if($_ ne $ARGV[2]);
}

$s=@mach;
$iterations = ceil(log($s)/log(2));
#print "it: $iterations for $s\n";

for($i=0; $i < $iterations; $i++){
    $num_copies = 2**$i;
    #print "it:$i nc:$num_copies\n";
    for($k=0; $k < $num_copies; $k++){
	$m=$k+2**$i;
	if($m < $s){
		if ($ARGV[4] eq "FILE") {
	    		print "scp $ARGV[3]\@$mach[$k]:$ARGV[1] $ARGV[3]\@$mach[$m]:$ARGV[1] &\n";
		}
		else {
			my @directories = split /\//, $ARGV[1];
			my $destination_directory = join ("/", @directories[0..$#directories-1]); 
	    		print "scp -r $ARGV[3]\@$mach[$k]:$ARGV[1] $ARGV[3]\@$mach[$m]:$destination_directory &\n";
		}
	}
    }
    print " wait;\n";
}
