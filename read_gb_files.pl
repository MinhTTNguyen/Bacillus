# June 21, 2018
# read .gbk files and extract gene sequences as well as annotation information

#! /usr/bin/perl -w
use strict;
use Bio::SeqIO;
use Bio::SeqFeature::Generic;
use Bio::DB::GenBank;

my $folderin="/home/mnguyen/Research/Bacillus/GB/GB_CDs_tag";
my $folderout_fasta="/home/mnguyen/Research/Bacillus/CDs_CDstag";
my $folderout_annotation="/home/mnguyen/Research/Bacillus/Annotation_CDstag";
my $folderout_protein="/home/mnguyen/Research/Bacillus/Protseq_CDstag";
#my $fileout_test="/home/mnguyen/Research/Bacillus/RAST/antismash_submitted/test.txt";
#open(TEST,">$fileout_test") || die "Cannot open file $fileout_test";
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
		print "$filecount: $filein-----------------------------------------\n";
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
		print ANNOTATION "GeneID\tScaffold\tStrand\tStart\tEnd\tGene_length\tProtein_length\tFunction\tGene_seq\tProtein_seq\n";
		my $seqio_obj = Bio::SeqIO->new(-file =>"$folderin/$filein", -format => "genbank");
		
		while (my $seq_obj = $seqio_obj->next_seq())
		{
			my $scaffold_id=$seq_obj->display_id;
			for my $feature_obj ($seq_obj -> get_SeqFeatures)
			{
				my $primary_tag=$feature_obj->primary_tag();
				$primary_tag=~s/\s*//g;
				
				if ($primary_tag eq 'CDS')
				{
					my $sequence="";
					my $protseq="";
					my $start = $feature_obj->start();
					my $end = $feature_obj->end();
					my $strand= $feature_obj->strand();
					my $gene_length=($end-$start)+1;
					my $prot_len="";
					my $geneID="";
					my $function="";
					my $locus_tag="";
					for my $tag ($feature_obj->get_all_tags)
					{
						#if ($tag eq 'kbase_id')
						#{
						#	my @tag_values=$feature_obj->get_tag_values("$tag");
						#	$geneID=$tag_values[0];
						#	$geneID=~s/^.+IMGID\_//;#Bacillus_oleivorans_JC228_IMGID_2740891863.CDS.4501
						#	$geneID=~s/\.CDS\./\_/;
						#}
						
						if (($tag eq 'function') or ($tag eq 'product'))
						{
							my @tag_values=$feature_obj->get_tag_values("$tag");
							$function=$tag_values[0];
						}
						
						if ($tag eq 'locus_tag'){my @tag_values=$feature_obj->get_tag_values("$tag");$locus_tag=$tag_values[0];}
						
						if ($tag eq 'translation')
						{
							my @tag_values=$feature_obj->get_tag_values("$tag");
							$protseq=$tag_values[0];
							$prot_len=length($protseq);
						}
					}
					if ($strand>0){$strand="Plus";}
					else{$strand="Minus";}
					$geneID=$imgid."|".$scaffold_id."|".$strand."|".$start."|".$end;
					print ANNOTATION "$geneID\t$scaffold_id\t$strand\t$start\t$end\t$gene_length\t$prot_len\t$function\t$sequence\t$protseq\t$locus_tag\n";
					print FASTA ">$geneID\n$sequence\n";
					print PROT_FASTA ">$geneID\n$protseq\n";
				}

			}
		}
		close(FASTA);
		close(ANNOTATION);
		#exit;
	}
}
closedir(DIR);
