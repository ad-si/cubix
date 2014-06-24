$fn = 100;

base();

module base (){
	union(){
		difference() {
			union() {
				cylinder(d=30, h=3);
				cylinder(d=10, h=15);
			}
			cylinder(d=5, h=50, center=true);
		}
	}
}