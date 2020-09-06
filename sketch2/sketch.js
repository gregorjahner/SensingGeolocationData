var mapimg;

//longitude and latitude center variation
var clon = 0;
var clat = 0;

//variation for first point in table
var lon = 35.20096302107013;
var lat = 31.755398163775343;

//zoom has to be equal to the link
var zoom = 12.27;

//variation for spots in Jerusalem
var spots;

function preload() {
  mapimg = loadImage('https://api.mapbox.com/styles/v1/mapbox/outdoors-v11/static/35.2212,31.7726,12.27,0/600x600?access_token=pk.eyJ1IjoiZ3JlZ29yamFobmVyIiwiYSI6ImNrZXI2NmxzNzJ5M3kzMHBjMHlqc3dza2UifQ.L8DSwyeUVqJ4FByh6eLi8Q');

  spots = loadStrings('Spots/top_spots_100_JSLM.csv')

}


//function for mercartor projection
function mercX(lon){
  lon = radians(lon);
  var a = (256 / PI) * pow(2, zoom);
  var b = log + PI;
  return a * b;
}

function mercY(lat){
  lat = radians(lat);
  var a = (256 / PI) * pow(2, zoom);
  var b = tan(PI / 4 + lat / 2);
  var c = PI - log(b);
  return a * c;
}

function setup() {
  createCanvas(600, 600);
  translate( width / 2, height / 2);
  imageMode(CENTER);
  image(mapimg, 0, 0);

  var cx = mercX(clon);
  var cy = mercY(clat);

  var x = mercX(lon) - cx;
  var y = mercY(lat) - cy;

  for (var i = 0; i < spots.length; i++) {
    var data = spots[i].split(/,/);
    //console.log(data);
		var lat = data[0];
		var lon = data[1];
		fill(255,0,255, 200);
	  ellipse(x,y,20,20);
	}
}
