# Friday, January 25, 2019
# auto-create protein database for each complete bacillus genome

#! /usr/perl/bin -w
use strict;

my $proteome_folder="/mnt/fs1/home/mnguyen/Research/Bacillus/Bacillus_genus/Complete_genomes/protseq";

opendir(DIR,$proteome_folder) || die "Could not open folder $proteome_folder";
my @protein_files=readdir(DIR);
closedir(DIR);
chdir $proteome_folder;

foreach my $file (@protein_files)
{
	if (($file ne ".") and ($file ne ".."))
	{
		my $cmd = "makeblastdb -in $file -dbtype prot -out $file";
		system $cmd;
	}
}