#!/usr/bin/perl -w
use strict;


## this file has sample metadata
my $file = "samples.txt";


## open the file
open(FILE, $file);


## while we can keep getting lines from the file
# get the next line
while (<FILE>)
{
    my $line = $_;##this is the current line
    chomp $line;# remove the carriage return character at the end of the line

    ##split the line into fields, separated by spaces
    my @fields = split(/\s+/, $line);
    my $srr_id = $fields[3];##4th column is the SRR identifier

    my $download_from_ncbi = "fastq-dump --split-files $srr_id";
    my $ret = qx{$download_from_ncbi};

}
close(FILE);
