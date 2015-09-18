#!/usr/bin/perl -w
use strict;

my $file = shift;
my $out = $file.".gt_only";

open(FILE, $file)||die();
open(OUT, ">".$out)||die();

while (<FILE>)
{
    my $line = $_;
    chomp $line;
    if ($line =~ /^\#/)
    {
	print OUT $line."\n";
    }
    else
    {
	my @sp = split(/\t/, $line);
	my $format = $sp[8];
	$sp[8]="GT";
	my $i;
	for ($i=9; $i<scalar(@sp); $i++)
	{
	    my @sp2 = split(/:/, $sp[$i]);
	    $sp[$i]=$sp2[0];##replace the set of values with just the genotype
	}
	print OUT join("\t", @sp);
	print OUT "\n";
    }
}
close(FILE);
close(OUT);

