# October 5th 2018
# Read information of full-record information file got from Batch-Entrez from NCBI after uploading a batch of BioSample IDs

#! /usr/perl/bin -w
use strict;

my $folderin="/mnt/fs1/home/mnguyen/Research/Bacillus/Bacillus_genus/Biosample/Biosample_info"; #folder contains full-recorded of BioSample full entries from Batch Entrez (NCBI)
my $folderout="/mnt/fs1/home/mnguyen/Research/Bacillus/Bacillus_genus/Biosample/Biosamples_tbl";
mkdir $folderout;

opendir(DIR,"$folderin") || die "Cannot open folder $folderin";  
my @files=readdir (DIR);
foreach my $filein (@files)
{
	if (($filein eq ".") or ($filein eq "..")) {next;}
	open(In,"<$folderin/$filein") || die "Cannot open file $folderin/$filein";
	open(Out,">$folderout/$filein") || die "Cannot open file $folderout/$filein";
	print Out "#Biosample_ID\tstrain\tgeographic location\tisolation source\tcollected by\tnote\thost\thost disease\tenvironment biome\thost tissue sampled\tspecimen voucher\ttemperature\tisolate\tisolation and growth condition\trelationship to oxygen\tenvironment material\tenvironment feature\thost health state\thost age\thost disease outcome\thost sex\tassembly_method\tcompleteness_estimated\tcontamination_estimated\tenvironmental_sample\tgenome_coverage\tmetagenome_source\n";
	my $biosample_id="";
	my $strain="";
	my $geographic_location="";
	my $isolation_source="";
	my $collected_by="";
	my $note="";
	my $host="";
	my $host_disease="";
	my $environment_biome="";
	my $host_tissue_sampled="";
	my $specimen_voucher="";
	my $temperature="";
	my $isolate="";
	my $isolation_and_growth_condition="";
	my $relationship_to_oxygen="";
	my $environment_material="";
	my $environment_feature="";
	my $host_health_state="";
	my $host_age="";
	my $host_disease_outcome="";
	my $host_sex="";
	my $assembly_method="";
	my $completeness_estimated="";
	my $contamination_estimated="";
	my $environmental_sample="";
	my $genome_coverage="";
	my $metagenome_source="";
	
	while (<In>)
	{
		$_=~s/\s*$//;
		if ($_=~/^Identifiers\:\s*BioSample\:\s*([^\;]+)\;*/){$biosample_id=$1;}
		if ($_=~/^\s+\/strain\=\"(.+)\"/){$strain=$1;}
		if ($_=~/^\s+\/geographic location\=\"(.+)\"/){$geographic_location=$1;}
		if ($_=~/^\s+\/isolation source\=\"(.+)\"/){$isolation_source=$1;}
		if ($_=~/^\s+\/collected by\=\"(.+)\"/){$collected_by=$1;}
		if ($_=~/^\s+\/note\=\"(.+)\"/){$note=$1;}
		if ($_=~/^\s+\/host\=\"(.+)\"/){$host=$1;}
		if ($_=~/^\s+\/host disease\=\"(.+)\"/){$host_disease=$1;}
		if ($_=~/^\s+\/environment biome\=\"(.+)\"/){$environment_biome=$1;}
		if ($_=~/^\s+\/host tissue sampled\=\"(.+)\"/){$host_tissue_sampled=$1;}
		if ($_=~/^\s+\/specimen voucher\=\"(.+)\"/){$specimen_voucher=$1;}
		if ($_=~/^\s+\/temperature\=\"(.+)\"/){$temperature=$1;}
		if ($_=~/^\s+\/isolate\=\"(.+)\"/){$isolate=$1;}
		if ($_=~/^\s+\/isolation and growth condition\=\"(.+)\"/){$isolation_and_growth_condition=$1;}
		if ($_=~/^\s+\/relationship to oxygen\=\"(.+)\"/){$relationship_to_oxygen=$1;}
		if ($_=~/^\s+\/environment material\=\"(.+)\"/){$environment_material=$1;}
		if ($_=~/^\s+\/environment feature\=\"(.+)\"/){$environment_feature=$1;}
		if ($_=~/^\s+\/host health state\=\"(.+)\"/){$host_health_state=$1;}
		if ($_=~/^\s+\/host age\=\"(.+)\"/){$host_age=$1;}
		if ($_=~/^\s+\/host disease outcome\=\"(.+)\"/){$host_disease_outcome=$1;}
		if ($_=~/^\s+\/host sex\=\"(.+)\"/){$host_sex=$1;}
		if ($_=~/^\s+\/assembly\_method\=\"(.+)\"/){$assembly_method=$1;}
		if ($_=~/^\s+\/completeness\_estimated\=\"(.+)\"/){$completeness_estimated=$1;}
		if ($_=~/^\s+\/contamination\_estimated\=\"(.+)\"/){$contamination_estimated=$1;}
		if ($_=~/^\s+\/environmental\_sample\=\"(.+)\"/){$environmental_sample=$1;}
		if ($_=~/^\s+\/genome\_coverage\=\"(.+)\"/){$genome_coverage=$1;}
		if ($_=~/^\s+\/metagenome\_source\=\"(.+)\"/){$metagenome_source=$1;}
	
		if ($_=~/^Accession/)
		{
			print Out "$biosample_id\t$strain\t$geographic_location\t$isolation_source\t$collected_by\t$note\t$host\t$host_disease\t$environment_biome\t$host_tissue_sampled\t$specimen_voucher\t$temperature\t$isolate\t$isolation_and_growth_condition\t$relationship_to_oxygen\t$environment_material\t$environment_feature\t$host_health_state\t$host_age\t$host_disease_outcome\t$host_sex\t$assembly_method\t$completeness_estimated\t$contamination_estimated\t$environmental_sample\t$genome_coverage\t$metagenome_source\n";
			$biosample_id="";
			$strain="";
			$geographic_location="";
			$isolation_source="";
			$collected_by="";
			$note="";
			$host="";
			$host_disease="";
			$environment_biome="";
			$host_tissue_sampled="";
			$specimen_voucher="";
			$temperature="";
			$isolate="";
			$isolation_and_growth_condition="";
			$relationship_to_oxygen="";
			$environment_material="";
			$environment_feature="";
			$host_health_state="";
			$host_age="";
			$host_disease_outcome="";
			$host_sex="";
			$assembly_method="";
			$completeness_estimated="";
			$contamination_estimated="";
			$environmental_sample="";
			$genome_coverage="";
			$metagenome_source="";			
		}
	}
	close(In);
	close(Out);
}
closedir(DIR);