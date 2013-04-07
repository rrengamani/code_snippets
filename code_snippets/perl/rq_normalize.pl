#!/usr/bin/perl

#title           :raw query normalizer
#description     :This will normalize the raw queries passed in standard input.
#author          :rengamanir
#date            :20120718
#version         :1.0
#usage           : cat <Input file> | ./rq_normalize.pl > outputfile
#==============================================================================

while(<>){
    chomp;
    $nq1 = normalizeShownQuery($_);
    $nq2 = normalizeQuery($_);
    print STDOUT "$_\t$nq1\t$nq2\n";
    #if($nq1 ne $nq2){
    #print "$_\t$nq1\t$nq2\n";
    #}
}

sub normalizeShownQuery
{
    my ($str) = @_;
    $str =~ tr/A-Z/a-z/;
    $str =~ s/[\'\"]+s\b/ /g;
    $str =~ s/[\'\"]+\W/ /g;
    $str =~ s/\W[\'\"]+/ /g;
    $str =~ s/[\'\"]+$//g;
    $str =~ s/^[\'\"]+//g;
    $str =~ s/[\?\+\,]+/ /g;
    $str =~ s/\s+/ /g;
    $str =~ s/^\s+//;
    $str =~ s/\s+$//;
    $str;
}

sub normalizeQuery
{
    my ($str) = @_;
    $str =~ tr/A-Z/a-z/;
    $str =~ s/\s+/ /g;
    $str =~ s/^\s+//;
    $str =~ s/\s+$//;
    $str;
}
