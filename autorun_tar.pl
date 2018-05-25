#! /usr/bin/perl -w
use strict;

my $folderin="Large_size/TAR";
opendir(DIR,$folderin) || die "Cannot open folder $folderin";
my @files=readdir(DIR);
foreach my $file (@files)
{
	if (($file ne ".") and ($file ne ".."))
	{
		my $cmd = "tar -xvf $folderin/$file";
		system $cmd;
	}
}
closedir(DIR);