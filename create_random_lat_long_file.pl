#!/usr/bin/perl -w

use strict;
use warnings;

#this is a very quick script that creates a random of latlong points
#for testing the script.
# usage:
# perl create_random_lat_long_file.pl 10000000

#this would create a file 10000000 long of random lat longs coords

my $length = $ARGV[0];
my $counter = 0;
while($counter < $length){
	my $lat;
	my $long;
	if(rand()<0.1){
		$lat = rand()*70 + rand();
		$long = rand()*20;
	}elsif(rand()<0.3){
		$lat = rand()*80 - rand();
		$long = 1- rand();
	}else{
		$lat = rand()*90 - rand();
		$long = 0 + rand();
	}
	if(rand()<0.1){
		$lat =  $lat + rand(4);
		$long = $long + rand();
	}
	if(rand()<0.3){
		$lat =  $lat * rand();
		$long = $long * rand();
	}
	if(rand()<0.2){
		$lat =  $lat + rand();
		$long = $long - rand();
	}
	if(rand() > 0.3){
		$lat =  $lat * rand();
		$long = $long - rand(3);
	}
	print "$lat,$long\n";
	$counter++;
}
