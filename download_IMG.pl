#! /usr/bin/perl -w
# July 11th 2017
# Download CAZy tables
# Input: list of CAZy families
# Output: folders containing html files and summarized table

use strict;
#use File::Download;

my $path="/home/mnguyen/Research/Bacillus/";
my $filein_IMGID_list="new_IMG_IDs_11May2018.txt";
my $folderout="new_IMG_IDs_11May2018";
mkdir "$path/$folderout";
chdir $path;

#========================================================================================================#
# Get list of CAZy families
my @IMGID_list;
open(List,"<$filein_IMGID_list") || die "Cannot open file $filein_IMGID_list";
while (<List>)
{
	$_=~s/\s*//g;
	push(@IMGID_list,$_);
}
close(List);
#========================================================================================================#


#========================================================================================================#
my $cmd='curl https://signon-old.jgi.doe.gov/signon/create --data-urlencode login=thitrucminh.nguyen@concordia.ca --data-urlencode password=MinhTri1 -c ./cookies > /dev/null';
print "$cmd\n";
`$cmd`;
foreach my $IMG_ID (@IMGID_list)
{
	my $url='https://genome.jgi.doe.gov/portal/IMG_'.$IMG_ID.'/download/download_bundle.tar.gz';#https://genome.jgi.doe.gov/portal/IMG_2643221487/download/download_bundle.tar.gz
	#print $url. "\n";
	my $cmd = "curl \"$url\" -o $path/$folderout/$IMG_ID.tar.gz -b ./cookies";
	print "$cmd\n";
	`$cmd`;
	
}
#========================================================================================================#
