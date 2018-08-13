# July 26th 2018
# Print first line of each gb file created by RAST to see which files have CDs tag in feature list

#! /usr/perl/bin -w
use strict;

my $folderin="";
my $fileout="RAST_gb_first_lines.txt";

opendir(DIR,$folderin) || die "Cannot open folder";

closedir(DIR);