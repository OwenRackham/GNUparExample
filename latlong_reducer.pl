#!/usr/bin/perl -w

use strict;
use warnings;
###################### SEE latlong_mapper.pl for description and usage ##################



#create a hash to store the data
my %locations;
#loops over the file that is create from the mapper script
while (<>) {
	#remove unwanted characters
    chomp;
    #split the line on commas
    my ($lat, $long, $count) = split /\t/;
    #create a hash location if not initialised
    $locations{$lat}{$long} = 0 if (not exists $locations{$lat}{$long});
    #increment by the counter value
    $locations{$lat}{$long} += $count;
}

#print the top of the page
print_header();

#print the js that will create the variable
print "var heatMapData = [";
#create an array to push the strings into
my @location_strings;
#loop over the hash
foreach my $lat (keys %locations) {
	foreach my $long (keys %{$locations{$lat}}) {
		#add the string to the array
    	push(@location_strings, "{location: new google.maps.LatLng($lat, $long), weight: $locations{$lat}{$long} }\n");
	}
}
#print the array joined on commas
print join(',',@location_strings);
#close the variable
print "];\n";

#print the bottom of the page
print_footer();




#this is the HTML required to initiate a google map with the visualisation layer active
sub print_header{
	print <<END;
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <style type="text/css">
      html { height: 100% }
      body { height: 100%; margin: 0; padding: 0 }
      #map-canvas { height: 100% }
    </style>
    <script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?libraries=visualization&key=AIzaSyC9jwggpplgGOyLjD0F2qlHFqv42tv7JZs&sensor=false">
    </script>
    <script type="text/javascript">	
END
}

#this is the bottom of the page
sub print_footer{
	print <<END;
	   function initialize() {
        var mapOptions = {
          center: new google.maps.LatLng(45, 0),
          zoom: 3,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var map = new google.maps.Map(document.getElementById("map-canvas"),
            mapOptions);
        var heatmap = new google.maps.visualization.HeatmapLayer({
  data: heatMapData
});
heatmap.setMap(map);
      }
      google.maps.event.addDomListener(window, 'load', initialize);
    </script>
  </head>
  <body>
    <div id="map-canvas"/>
  </body>
</html>
END

}
