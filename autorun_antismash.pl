#! /usr/perl/bin -w
use strict;

my $filein_list="antismash_imgids.txt";
open(In,"<$filein_list") || die "Cannot open file $filein_list";
while (<In>)
{
	$_=~s/\s*//g;
	my $imgid=$_;
	my $filegb=$_.".gbk";
	my $log_file=$_.".log";
	my $status_file=$_.".status";
	my $cmd="antismash -c 50 --taxon bacteria --subclusterblast --knownclusterblast --smcogs --inclusive --borderpredict --full-hmmer --outputfolder $imgid --logfile $log_file --statusfile $status_file RAST/$filegb";
	system $cmd;
}
close(In);