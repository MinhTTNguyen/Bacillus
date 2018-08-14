# August 14th, 2018
# read .gbk files and extract gene sequences as well as annotation information
# this script is only for gbk files created by KBase, not having CDS tag, only have gene as primary tag and the other tags are /function and /kbase_id

#! /usr/bin/perl -w
use strict;
use Bio::SeqIO;
use Bio::SeqFeature::Generic;
use Bio::DB::GenBank;

my $folderin="/home/mnguyen/Research/Bacillus/GB/All_GB_files/no_CDS_tag";
my $folderout_fasta="/home/mnguyen/Research/Bacillus/GB/All_GB_files/no_CDS_tag_CDs";
my $folderout_annotation="/home/mnguyen/Research/Bacillus/GB/All_GB_files/no_CDS_tag_Annotation";
my $folderout_protein="/home/mnguyen/Research/Bacillus/GB/All_GB_files/no_CDS_tag_Protseq";
mkdir $folderout_annotation;
mkdir $folderout_fasta;
mkdir $folderout_protein;
opendir(DIR,"$folderin") || die "Cannot open folder $folderin";
my @files=readdir(DIR);
my $filecount=0;
foreach my $filein (@files)
{
	if (($filein ne ".") and ($filein ne ".."))
	{
		$filecount++;
		print "$filecount: $filein-----------------------------------------";
		my $annotation_file=$filein;
		$annotation_file=~s/^.+IMGID\_//;
		$annotation_file=~s/\.gbk$//;
		my $imgid=$annotation_file;
		my $prot_seq_file=$annotation_file.".fasta";
		my $gene_seq_file=$annotation_file.".fasta";
		$annotation_file=$annotation_file.".txt";
		open(FASTA,">$folderout_fasta/$gene_seq_file") || die "Cannot open file $folderout_fasta/$gene_seq_file";
		open(PROT_FASTA,">$folderout_protein/$prot_seq_file") || die "Cannot open file $folderout_protein/$prot_seq_file";
		open(ANNOTATION,">$folderout_annotation/$annotation_file") || die "Cannot open file $folderout_annotation/$annotation_file";
		print ANNOTATION "GeneID\tScaffold\tStrand\tStart\tEnd\tGene_length\tProtein_length\tFunction\tGene_seq\tProtein_seq\tKbase_ID\n";
		my $seqio_obj = Bio::SeqIO->new(-file =>"$folderin/$filein", -format => "genbank");
		
		while (my $seq_obj = $seqio_obj->next_seq())
		{
			my $scaffold_id=$seq_obj->display_id;
			for my $feature_obj ($seq_obj -> get_SeqFeatures)
			{
				my $primary_tag=$feature_obj->primary_tag();
				$primary_tag=~s/\s*//g;
				
				if ($primary_tag eq 'gene')
				{
					my $sequence=$feature_obj->spliced_seq()->seq();
					my $protseq=$feature_obj->spliced_seq()->translate()->seq();
					my $start = $feature_obj->start();
					my $end = $feature_obj->end();
					my $strand= $feature_obj->strand();
					my $gene_length=($end-$start)+1;
					my $prot_len=length($protseq);
					my $geneID="";
					my $function="";
					my $kbase_id="";
					for my $tag ($feature_obj->get_all_tags)
					{
						if ($tag eq 'kbase_id')
						{
							my @tag_values=$feature_obj->get_tag_values("$tag");
							$kbase_id=$tag_values[0];
						}
						
						if ($tag eq 'function')
						{
							my @tag_values=$feature_obj->get_tag_values("$tag");
							$function=$tag_values[0];
						}
					}
					if ($strand>0){$strand="Plus";}
					else{$strand="Minus";}
					$geneID=$imgid."|".$scaffold_id."|".$strand."|".$start."|".$end;
					print ANNOTATION "$geneID\t$scaffold_id\t$strand\t$start\t$end\t$gene_length\t$prot_len\t$function\t$sequence\t$protseq\t$kbase_id\n";
					print FASTA ">$geneID\n$sequence\n";
					print PROT_FASTA ">$geneID\n$protseq\n";
				}

			}
		}
		print "done\n";
		close(FASTA);
		close(ANNOTATION);
	}
}
closedir(DIR);
