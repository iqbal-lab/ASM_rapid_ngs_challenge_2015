#!/usr/bin/perl -w
use strict;

my $file = "/data3/projects/outbreak_challenge/testing/sal_minnesota/phylosnps.vcf.sites";
my $union ="/data3/projects/outbreak_challenge/analyses/salmonella/results/combine/SALMONELLA_ASM_AND_BACKGROUND.sites_vcf";

my %phylo = ();
my $num_sites = get_sites(\%phylo, $file);

my $called =  count_called(\%phylo, $union);

print "Running in the 2600 samples called $called out of $num_sites phylo SNPs\n";

sub count_called
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
	    my $filter = $sp[6];
	    if ($filter ne "PASS")
	    {
		next;
	    }
	    if (exists $href->{$pos})
	    {
		if ($href->{$pos} eq $ref."_".$alt)
		{
		    $ct++;
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
