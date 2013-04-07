#!/usr/bin/perl
#title           :runs command on remote machines
#description     :This script takes machine list from a file and execute commands in machines sequentially.
#pre-requisite   :The machine from where this script runs require ssh setup between this machine and the machines listed in machine list file.
#author          :rengamanir
#date            :20111012
#version         :1.0
#usage           :cat <MachineListFile> | ./command.pl "<full path of command/script to run>"
#=============================================================================================

my $scommand;
for( $i = 0; $i <= $#ARGV; $i++ ) 
{
    $scommand = join " ", $scommand, $ARGV[$i];
} 

#print "SCOMMAND: $scommand\n";

my $children = 0;
while($server = <STDIN>)
{
    chomp $server; 
    $server =~ /(\S*)/;
    $server = $1;
    $server1 = "vega@".$server;
    
#  if( 0 == ($pid = fork()))
#  {
    my $command = "ssh -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=$HOME/.ssh/known_hosts' $server1 \"$scommand\" "; 
#	 print $command, "\n" ;
    print "$server	";
    system $command;
#	 exit 0;
#  }
#  $children++;
}

#for( $i = 0; $i < $children; $i++ )
#{
#	 wait;
#}



__END__
    
