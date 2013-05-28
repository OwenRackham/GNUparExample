#!/usr/bin/perl -w
use strict;
use warnings;

########################### MAPPER SCRIPT FOR LAT LONG FILE REDUCTION##################################
#REQUIREMENTS: The solution to the data scientist problem requires gnu parallel to be installed.
#this can be obtained by visiting: http://www.gnu.org/software/parallel/  or by using mac ports or similar
########################################################################################################
#This script is intended for use with gnu parallel. The task of taking a large
#file and summarising it in the way requested lends itself nicely to a map 
#reduce framework but the overhead of implementing this for a small problem like
#this is not nescessary. It is possible to use gnu parallel in the same way.
#######################################################################################################
#By invoking gnu parallel as follows with the two scripts, the large file will be
#broken down into chunks and piped of for mapping by indivual processes. This can
#be many cores on a single machine or over shh to several machines depending on how
#much CPU you want to dedicate to the task, what the network connection speed is
#like (obviosuly the file chunks have to scp'd) and how large the file is. It is
#even possible to run this on ec2.
#    USAGE:
#
#	cat latlong_file.csv | parallel --pipe --blocksize 64M ./latlong_mapper.pl | ./latlong_reducer.pl > output.html
#
#
# output: 	The script outputs a html with the required  heatmap using google maps API. In the folder there is 
#			an example.html that is created using uniformly distributed points.
#######################################################################################################

#create a hash to store the data in.
my %locations;
#a variable that could be changed (can be issued from ARGS) if you wish to granulise the locations.
my $granulise_dp = 1;

#open and iterate over the file provided to the script. This is using perl's implied varialble.
while (<>) {
	chomp;
	#split the line of commas
    my @data = split /,/;
    #the lat value is stored
    my $lat = $data[0];
    #the long value is stored
    my $long = $data[1];
    #the hash is initialised with 0 of no line has contained the same values
    if($granulise_dp != 0){
    	$lat = create_granules($lat,$granulise_dp);
    	$long = create_granules($long,$granulise_dp);
    }
    $locations{$lat}{$long} = 0 if (not exists $locations{$lat}{$long});
    #the count of the location is incremented.
    $locations{$lat}{$long}++;
    
}
#loop through the summarised data and print
foreach my $lat (keys %locations) {
	foreach my $long (keys %{$locations{$lat}}) {
    print "$lat\t$long\t$locations{$lat}{$long}\n";
	}
}

sub create_granules{
	#this routing takes a value and dp as an argument and returns the granulised value
	my $value = shift;
	my $dps = shift;
	my $granule = sprintf("%.".$dps."f", $value);
	return $granule;
}