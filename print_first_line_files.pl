#! /usr/perl/bin -w
use strict;
my $folder="/home/mnguyen/Research/Bacillus/Annotation";
my $fileout="/home/mnguyen/Research/Bacillus/Annotation.txt";
opendir(DIR,$folder) || die "Cannot open folder $folder";
my @files=readdir(DIR);
open(Out,">$fileout") || die "Cannot open file $fileout";
foreach my $file (@files)
{
	if (($file ne ".") and ($file ne ".."))
	{
		open(In,"<$folder/$file") || die "Cannot open file $folder/$file";
		while (<In>)
		{
			if ($_!~/^GeneID/)
			{
				print Out "$file\t$_";
				last;
			}
		}
		close(In);
	}
}
closedir(DIR);
close(Out);