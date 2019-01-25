# Autorun hmmsearch program
 
#! /usr/perl/bin -w
use strict;

my $folderin="/home/mnguyen/Research/Bacillus/Bacillus_of_interest_13Sep2018/Bacilus_coagulans/protseq";
my $folderout="/home/mnguyen/Research/Bacillus/Bacillus_of_interest_13Sep2018/Bacilus_coagulans/pfamscanv31";
mkdir $folderout;

opendir(DIR,"$folderin") || die "Could not open folder $folderin";
my @files=readdir(DIR);
my $filecount=0;
foreach my $file (@files)
{
	if (($file ne ".") and ($file ne ".."))
	{
		my $fileout=substr($file,0,-5);
		$fileout=$fileout."_pfamv31.txt";
		$filecount++;
		print "$filecount.$file:start...............................";
		my $cmd = "perl /opt/PfamScan/pfam_scan.pl -fasta $folderin/$file -dir /opt/PfamScan/DB_v31_31Aug2017 -outfile $folderout/$fileout -e_seq 1E-05 -e_dom 1E-05 -cpu 30";
		system $cmd;
		print "finish\n";
	}
}
closedir(DIR);