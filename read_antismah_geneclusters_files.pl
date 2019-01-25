#! /usr/perl/bin -w
use strict;

my $folderin="/home/mnguyen/Research/Bacillus/antiSMASH/summarized_GeneCluster"; #folder containing gene cluster files
my $fileout="/home/mnguyen/Research/Bacillus/antiSMASH/summarized_GeneCluster.txt";

my %hash_imgid_clustercount;
my %hash_imgid_clustertype_count;
my %hash_BCG_types;
my %hash_img_ids;
my %hash_imgid_org;

opendir(DIR,"$folderin") || die "Cannot open folder $folderin";
my @fileins=readdir(DIR);

foreach my $filein (@fileins)
{
	if (($filein ne ".") and ($filein ne ".."))
	{
		my $imgid=$filein;
		$hash_img_ids{$imgid}++;
		open(In,"<$folderin/$filein") || die "Cannot open file $folderin/$filein";
		while (<In>)
		{
			$_=~s/\s*$//;
			my @cols=split(/\t/,$_);
			my $BGCtype=$cols[2];
			my $org=$cols[1];
			$hash_imgid_clustercount{$imgid}++;
			my $key=$imgid."_".$BGCtype;
			$hash_imgid_clustertype_count{$key}++;
			$hash_BCG_types{$BGCtype}++;
			unless($hash_imgid_org{$imgid}){$hash_imgid_org{$imgid}=$org;}
		}
		close(In);
	}
}
closedir(DIR);


my @BCG_types=keys(%hash_BCG_types);
my @img_ids=keys(%hash_img_ids);
open(Out,">$fileout") || die "Cannot open file $fileout";
print Out "#IMG_ID\tSpecies\tBGC count";
foreach my $type (@BCG_types){print Out "\t$type";}
print Out "\n";
foreach my $each_imgid (@img_ids)
{
	my $BCGcount=$hash_imgid_clustercount{$each_imgid};
	my $species=$hash_imgid_org{$each_imgid};
	print Out "$each_imgid\t$species\t$BCGcount";
	foreach my $type (@BCG_types)
	{
		my $key=$each_imgid."_".$type;
		my $type_count=$hash_imgid_clustertype_count{$key};
		unless($type_count){$type_count=0;}
		print Out "\t$type_count";
	}
	print Out "\n";
}
close(Out);