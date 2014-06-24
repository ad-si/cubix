displayColors = true;

cubix();

//plate();


// Print plate
module plate (){
	printPlateSize = 5000;

	color([1,1,1])
	translate([-printPlateSize/2, -printPlateSize/2, -2])
	cube(size=[printPlateSize, printPlateSize, 1]);
}


/*
0: front
1: left
2: back
3: right
*/
rotationTable = [
	[0,2,2,2,0,0,0,2,2,2],
	[0,0,0,2,0,2,0,2,0,2],
	[0,2,2,2,0,0,0,2,0,2],
	[0,0,0,2,0,2,0,2,0,2],
	[0,2,2,2,0,0,0,2,2,2],
];

colors = [
	[0, 0, 0],
	[1, 1, 1],
	//[1, 0.4, 0.2],
	[1, 1, 1],
	[1, 1, 1],
	//[0.3, 0.6, 0]
];



module cubix () {
	
	play = 2;
	xPixels = 11;
	zPixels = 5;
	edgeLength = 40;
	// Pixels can turn simultaneously
	//pixelDistance = (sqrt(2) - 1) * edgeLength + play;
	
	// Pixels can NOT turn simultaneously
	pixelDistance = (sqrt(2)/2 - 0.5) * edgeLength;
	

	baseHeight = 40;
	additionalWidth = edgeLength * 2;
	baseWidth = (xPixels * edgeLength) + ((xPixels - 1) * pixelDistance) + additionalWidth;
	baseDepth = edgeLength * 2;
	baseHeight = edgeLength * 2;
	capDistance = zPixels * (edgeLength + pixelDistance) + baseHeight + pixelDistance;
	capWidth = xPixels * (edgeLength + pixelDistance) - pixelDistance;
	capHeight = edgeLength;

	color([0.88, 0.72, 0.59])
	translate([additionalWidth/2, edgeLength/2, capDistance])
	topPlate(capWidth, capHeight, edgeLength);

	translate([additionalWidth/2, edgeLength/2, baseHeight + pixelDistance])
	pixelGrid(xPixels, zPixels, edgeLength, pixelDistance);

	color([0.88, 0.72, 0.59])
	base(baseWidth, baseDepth, baseHeight);
}


module pixel (x, z, edgeLength, pixelDistance) {
	
	translate([
		(edgeLength + pixelDistance) * x,
		0,
		(edgeLength + pixelDistance) * z
	])
	cube(size=[edgeLength, edgeLength, edgeLength]);
}

module colorPixel (x, z, edgeLength, pixelDistance, zPixels) {
	
	sideThickness = 2;

	//echo(90 * rotationTable(x, z))
	union(){
		 translate([
 			(edgeLength + pixelDistance) * x + edgeLength/2,
 			edgeLength/2,
 			(edgeLength + pixelDistance) * (zPixels - z - 1)
 		])
		//rotate([0, 0, (-abs($t*2 - 1) + 1) * 90 * rotationTable[z][x]])
		rotate([0, 0, 90 * rotationTable[z][x]])
		union(){
			for (i = [0:3]){
				color(colors[i])
				rotate([0, 0, 90 * i])
			 	translate([
		  			-edgeLength/2,
		  			edgeLength/2 - sideThickness + 0.1,
		  			0
		  		])
				cube(size=[edgeLength, sideThickness, edgeLength]);
			}
			translate([
				-edgeLength/2,
				-edgeLength/2,
				edgeLength - sideThickness + 0.1
			])
			color([0.88, 0.72, 0.59])
			cube(size=[edgeLength, edgeLength, sideThickness]);
		}
	}
}


module pixelGrid (xPixels, zPixels, edgeLength, pixelDistance) {
	
	for (x = [0:xPixels-1]) {
		for (z = [0:zPixels-1]) {
			//cube(x, z, edgeLength, pixelDistance);
			
			if (displayColors) {
				colorPixel(x, z, edgeLength, pixelDistance, zPixels);
			}
			else {
				pixel(x, z, edgeLength, pixelDistance);
			}
		}
	}
}

module base (baseWidth, baseDepth, baseHeight) {
	cube(size=[baseWidth, baseDepth, baseHeight]);
}

module topPlate (capWidth, capHeight, edgeLength) {
	cube(size=[capWidth, edgeLength, capHeight]);
}
