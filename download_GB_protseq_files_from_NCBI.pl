# September 11th 2018
# Download genbank and protein sequence files from NCBI

#! /usr/perl/bin -w
use strict;
#use HTTP::Request;
#use LWP::UserAgent;
use File::Fetch;

my $filein_info="Bacillus_pumilus.txt";#table downloaded from NCBI showing ftp link
my $folderout="Bacillus_pumilus";
mkdir $folderout;
open(In,"<$filein_info") || die "Cannot open file $filein_info";
chdir $folderout;
while (<In>)
{
	if ($_=~/^\#/){next;}
	$_=~s/\s*$//;
	my @cols=split(/\t/,$_);
	my $assembly_id=$cols[7];
	my $ftp_link=$cols[19];
	my $gb_file_prefix="";
	if ($ftp_link=~/^.+\/(.+)$/){$gb_file_prefix=$1;}
	else{print "\nError: ftp link is not as described!\n$ftp_link\n";exit;}
	my $gb_file=$gb_file_prefix."\_genomic.gbff.gz";#ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/022/965/GCA_000022965.1_ASM2296v1/GCA_000022965.1_ASM2296v1_genomic.gbff.gz
	my $prot_file=$gb_file_prefix."\_protein.faa.gz";
	my $ftp_gb=$ftp_link.'/'.$gb_file;
	my $ftp_prot=$ftp_link.'/'.$prot_file;
	my $ff = File::Fetch -> new(uri=>$ftp_gb);
	my $filegb = $ff -> fetch() || print "\nCannot download GB file for $assembly_id\n";
	#print "\nDownload file $filegb: done\n";
	
	my $ff1 = File::Fetch -> new(uri=>$ftp_prot);
	my $fileprot = $ff1 -> fetch()|| print "\nCannot download protein sequence file for $assembly_id\n";
	#print "\nDownload file $fileprot: done\n";
}
close(In);