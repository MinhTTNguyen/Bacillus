# August 13th 2018
# This perl script is to print out all primary tag and tags under each primary tag in the gb files
# The reason writing this script is because gb files seem to have different tags, and the number of
# synonymous ones (e.g. CDs and /translation or genes are all different), which makes it inaccurate
# when extracting annotation and sequences

#! /usr/perl/bin -w
use strict;
use Bio::SeqIO;
use Bio::SeqFeature::Generic;
use Bio::DB::GenBank;


my $folderin="/home/mnguyen/Research/Bacillus/GB/GB_CDs_tag";
my $fileout="/home/mnguyen/Research/Bacillus/GB/GB_CDs_tag_gb_tags.txt";
my %hash_tag;
opendir(DIR,"$folderin") || die "Cannot open folder $folderin";
my @files=readdir(DIR);
foreach my $filein (@files)
{
	if (($filein eq ".") or ($filein eq "..")){next;}
	my $seqio_obj = Bio::SeqIO->new(-file =>"$folderin/$filein", -format => "genbank");
	while (my $seq_obj = $seqio_obj->next_seq())
	{
		for my $feature_obj ($seq_obj -> get_SeqFeatures)
		{
			my $primary_tag=$feature_obj->primary_tag();
			for my $tag ($feature_obj->get_all_tags)
			{
				my $key=$filein."|".$primary_tag."|".$tag;
				$hash_tag{$key}++;
			}
		}
	}
}
closedir(DIR);

open(Out,">$fileout") || die "Cannot open file $fileout";
print Out "IMGID\tPrimary tag\ttag\tCounts\n";
while (my ($k, $v)=each(%hash_tag))
{
	$k=~s/\|/\t/g;
	print Out "$k\t$v\n";
}
close(Out);