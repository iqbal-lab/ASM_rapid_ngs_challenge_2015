#!/usr/bin/perl -w
use strict;
use File::Basename;

my $file = "/data3/projects/outbreak_challenge/testing/sal_minnesota/phylosnps.vcf.sites";
my $union ="/data3/projects/outbreak_challenge/analyses/salmonella/results/combine/SALMONELLA_ASM_AND_BACKGROUND.sites_vcf";

my %phylo = ();
my $num_sites = get_sites(\%phylo, $file);

my %called=();
get_called(\%phylo, $union, \%called);

open(FILE, $union)||die();
my $out = basename($union).".phylo_sites.vcf";
open(OUT, ">".$out)||die();

while (<FILE>)
{
    my $line = $_;
    if ($line =~ /^\#/)
    {
	print OUT $line;
    }
    else
    {
	chomp $line;
	my @sp = split(/\t/, $line);
	my $pos = $sp[1];
	if (exists $called{$pos})
	{
	    if ($called{$pos} eq "1")
	    {
		print OUT $line."\n";
	    }
	}
    }
}
close(FILE);
close(OUT);
sub get_called
{
    my ($href, $f, $href_called) = @_;
    open(FILE, $f)||die();
    my $ct=0;
    while (<FILE>)
    {
	my $line = $_;
	chomp $line;

	if ($line !~ /^\#/)
	{

	    my @sp = split(/\t/, $line);
	    my $pos = $sp[1];
	    my $ref = $sp[3];
	    my $alt = $sp[4];
	    my $filter = $sp[6];
	    if ($filter ne "PASS")
	    {
		next;
	    }
	    if (exists $href->{$pos})
	    {
		if ($href->{$pos} eq $ref."_".$alt)
		{
		    $href_called->{$pos}=1;
		}
	    }
	    else
	    {
		#print "No $pos $ref $alt\n";
	    }
	}

    }
    return $ct;
}
sub get_sites
{
    my ($href, $f) = @_;
    open(FILE, $f)||die();
    my $ct=0;
    while (<FILE>)
    {
	my $line = $_;
	chomp $line;
	
	if ($line !~ /^\#/)
	{
	    my @sp = split(/\t/, $line);
	    my $pos = $sp[1];
	    my $ref = $sp[3];
	    my $alt = $sp[4];
	    $href->{$pos}=$ref."_".$alt;
	    #print "Add $pos ---> ".$ref."_".$alt."\n";
	    $ct++;
	}
    }
    close(FILE);
    return $ct;
}
