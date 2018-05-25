# May 24th 2018
# move assembly files into a folder automatically for the selected genomes

#! /usr/perl/bin -w
use strict;

my $filein_imgid="/home/mnguyen/Research/Bacillus/IMG_download_by_perl/Large_size/FNA/IMG_ID_downloaded_by_perl_selected.txt";
my $folderout="/home/mnguyen/Research/Bacillus/IMG_download_by_perl/Large_size/FNA/Selected_assemblies";
my $folder_assemblies="/home/mnguyen/Research/Bacillus/IMG_download_by_perl/Large_size/FNA/assemblies";
mkdir $folderout;

open(In,"<$filein_imgid") || die "Cannot open file $filein_imgid";
while (<In>)
{
	$_=~s/\s*//g;
	my $file=$_;
	$file=$file.'.fna';
	#print "$file\n";
	my $cmd = "mv $folder_assemblies/$file $folderout";
	system $cmd;
}
close(In);