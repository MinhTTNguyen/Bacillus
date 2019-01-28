# Friday, January 25, 2019
# auto-create protein database for each complete bacillus genome

#! /usr/perl/bin -w
use strict;

my $working_folder="/mnt/fs1/home/mnguyen/Research/Bacillus/Bacillus_genus/2010_published_Bacillus_core_genome";
my $query_file="2010_published_814Bacillus_core_protein_GInumbers.fasta";
my $filein_proteome_list="/mnt/fs1/home/mnguyen/Research/Bacillus/Bacillus_genus/Complete_genomes/NCBI_complete_genome_Bacillus_list.txt";

#print "test"; exit;
##################################################################################################################
# get list of database name
my @proteome_list;
open(In,"<$filein_proteome_list") || die "Cannot open file $filein_proteome_list\n";
while (<In>)
{
	$_=~s/\s*//g;
	#print "\n$_\n";exit;
	push(@proteome_list,$_);
}
close(In);
##################################################################################################################




##################################################################################################################
chdir $working_folder;
my $count=0;
print "\n";
foreach my $proteome (@proteome_list)
{
		$count ++;
		print "$count. $proteome...";
		my $fileout="BLASTP_".$query_file.".".$proteome.".out";
		my $cmd = "blastp -query $query_file -db $proteome -evalue 1E-10 -out $fileout -num_threads 30";
		system $cmd;
		print "done\n";
}
##################################################################################################################