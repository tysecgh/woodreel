$time = 30;

h=6;
cr = 9;
mr = 6;
fw = 5;

pin_rad = 1.5;

module heart_cam(r, R, h) {
	min_r = r - pin_rad;
	max_r = R - pin_rad;
	steps = 24;
	step_angle = 360 / steps;

	points = [
		for (i = [0 : steps - 1])
		let(
			angle = i * step_angle,
			r = max_r - (max_r - min_r) * 2 * abs(i - steps/2) / steps
		)
		[r * cos(angle), r * sin(angle)]
	];

	linear_extrude(height = h) {
		polygon(points);
	}
}

module OF(){
    translate([-6,0,-h])cylinder(r=pin_rad,h=h*2,$fn=16);    translate([18,0,-h])cylinder(r=pin_rad,h=h*2,$fn=16);
    
    translate([-fw-(cr-mr),-3-fw,-h])cube([fw*2+cr*2,fw,h]);
    translate([-fw-(cr-mr),3,-h])cube([fw*2+cr*2,fw,h]);
    translate([-fw-(cr-mr),-(3+fw),-h])cube([fw,6+fw*2,h]);
    translate([(cr+mr),-(3+fw),-h])cube([fw,6+fw*2,h]);
}
    


module OC(){
    translate([0,0,-h])cylinder(r=3,h=h*3,$fn=64);

    rotate([0,0,180]) heart_cam(6, 18, h);
}


translate([-fw-(cr-mr)-mr*4,3+fw+1,-h])cube([fw*2+cr*2+mr*6,fw,h]);
translate([-fw-(cr-mr)-mr*4,-3-2*fw-1,-h])cube([fw*2+cr*2+mr*6,fw,h]);
dx = 12 *(180 - abs($time-180))/180;
translate([-dx,0,0])OF();
rotate([0,0,$time])OC();