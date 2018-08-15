# August 14th 2018
# This script is to compare protein sequences extracted from gb files of perl scripts before and after considering all feature tags in gb files

#! /usr/perl/bin -w
use strict;

my $folder_protseq_before="/home/mnguyen/hmmscan/Proteomes_Bacillus";
my $folder_protseq_after="/home/mnguyen/Research/Bacillus/GB/All_GB_files/Protseq";
my $fileout="/home/mnguyen/Research/Bacillus/GB/All_GB_files/Protseq_before_after_checking_all_tags.txt";

my %hash_before_gbfile_protcount;
my %hash_after_gbfile_protcount;
my %hash_after_gbfile_protcount_seq_diff;
my %hash_after_gbfile_protids_seq_diff;

open (Out,">$fileout") || die "Cannot open file $fileout";
print Out "GB_file\tProtcount_before\tProtcount_after\tProtcount_after_differs_before\tProtID_after_differs_before\n";
opendir(AFTER,$folder_protseq_after) || die "Cannot open folder $folder_protseq_after";
my @files_after=readdir(AFTER);
my $filecount=0;
foreach my $file (@files_after)
{
	if (($file eq ".") || ($file eq "..")){next;}
	$filecount++;
	print "$filecount. $file............................";
	my %hash_fasta_before=&Read_fasta("$folder_protseq_before/$file");
	my %hash_fasta_after=&Read_fasta("$folder_protseq_after/$file");
	my @arr_protids_before=keys(%hash_fasta_before);
	my @arr_protids_after=keys(%hash_fasta_after);
	my $totalprot_before=scalar(@arr_protids_before);
	my $totalprot_after=scalar(@arr_protids_after);
	
	while (my ($id,$seq)=each(%hash_fasta_after))
	{
		my $before_seq=$hash_fasta_before{$id};
		$seq=~s/\*$//;
		$before_seq=~s/\*$//;
		if ($before_seq ne $seq)
		{
			$hash_after_gbfile_protcount_seq_diff{$file}++;
			if ($hash_after_gbfile_protids_seq_diff{$file}){$hash_after_gbfile_protids_seq_diff{$file}=$hash_after_gbfile_protids_seq_diff{$file}.";".$id;}
			else{$hash_after_gbfile_protids_seq_diff{$file}=$id;}
		}
	}
	unless($hash_after_gbfile_protcount_seq_diff{$file}){$hash_after_gbfile_protcount_seq_diff{$file}=0;}
	unless($hash_after_gbfile_protids_seq_diff{$file}){$hash_after_gbfile_protids_seq_diff{$file}="NA";}
	print Out "$file\t$totalprot_before\t$totalprot_after\t$hash_after_gbfile_protcount_seq_diff{$file}\t$hash_after_gbfile_protids_seq_diff{$file}\n";
	print "done\n";
}
close(AFTER);
close(Out);


sub Read_fasta
{
	my $filein=$_[0];
	my %hash_fasta;
	open(Fasta,"<$filein") || die "Cannot open file $filein";
	my $id="";
	my $seq="";
	while (<Fasta>)
	{
		$_=~s/\s*$//;
		if ($_=~/^\>/)
		{
			if ($seq)
			{
				$seq=uc($seq);
				$hash_fasta{$id}=$seq;
				$id="";
				$seq="";
			}
			$id=$_;
			$id=~s/^\>//;
		}
		else{$_=~s/\s*//g;$seq=$seq.$_;}
	}
	$seq=uc($seq);
	$hash_fasta{$id}=$seq;
	close(Fasta);
	return(%hash_fasta);
}
