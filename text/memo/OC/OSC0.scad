$time = 120;

h=6;
cr = 9;
mr = 6;
fw = 5;


module OF(){
rotate([0,0,90])
linear_extrude(h){
translate([0,3,0])    
polygon([ 
    each [ for (i = [-10 : 10]) let(x=0.1*i) [mr*x, mr*scline(x)] ],
    [mr+3,mr*scline(1)], [mr+3,mr*scline(1)+fw],
    each [ for (i = [-10 : 10]) let(x=-0.1*i) [mr*x, mr*scline(x)+fw] ],
    [-mr-3,mr*scline(-1)+fw], [-mr-3,mr*scline(-1)]
]);

translate([0,-3-fw,0])
polygon([ 
    each [ for (i = [-10 : 10]) let(x=0.1*i) [mr*x, mr*scline(x)] ],
    [mr+3,mr*scline(1)], [mr+3,mr*scline(1)+fw],
    each [ for (i = [-10 : 10]) let(x=-0.1*i) [mr*x, mr*scline(x)+fw] ],
    [-mr-3,mr*scline(-1)+fw], [-mr-3,mr*scline(-1)]
]);
}

    translate([-fw-cr,-mr-3-fw,0])cube([fw*2+cr*2,fw,h]);
    translate([-fw-cr,mr+3,0])cube([fw*2+cr*2,fw,h]);
}

function _scline(x) = (1 - asin( x )*PI/180 - sqrt(1-x*x));
function scline(x) = x > 0 ? _scline(x): -_scline(abs(x));

    
module OC(){
    translate([0,0,-h])cylinder(r=3,h=h*2,$fn=64);
    cylinder(r=mr+6,h=h,$fn=64);
    translate([mr,0,0])cylinder(r=3,h=h*2,$fn=64);
}



translate([-fw-(cr-mr)-mr*4,3+2*fw+1,h])cube([fw*2+cr*2+mr*6,fw,h]);
translate([-fw-(cr-mr)-mr*4,-3-3*fw-1,h])cube([fw*2+cr*2+mr*6,fw,h]);

translate([mr*scline(sin($time))+mr*cos($time),0,h])OF();
rotate([0,0,$time])OC();
