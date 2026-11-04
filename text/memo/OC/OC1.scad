$time = 0;

h=6;
cr = 9;
mr = 6;
fw = 5;


module OF(){
    translate([-fw+mr-3,-(cr+mr),0])cube([fw,(cr+mr)*2,h]);
    translate([mr+3,-(cr+mr),0])cube([fw,(cr+mr)*2,h]);
    translate([-fw-(cr-mr),-(cr+mr)-fw,0])cube([fw*2+cr*2,fw,h]);
    translate([-fw-(cr-mr),(cr+mr),0])cube([fw*2+cr*2,fw,h]);
}
    


module OC(){
    translate([0,0,-2*h])cylinder(r=3,h=h*2,$fn=64);
    translate([mr,0,0])cylinder(r=3,h=h,$fn=64);
    translate([0,0,-h])cylinder(r=cr+mr,h=h,$fn=64);
}

translate([-fw-(cr-mr)-mr*4,(cr+mr)+fw+1,0])cube([fw*2+cr*2+mr*6,fw,h]);
translate([-fw-(cr-mr)-mr*4,-(cr+mr)-2*fw-1,0])cube([fw*2+cr*2+mr*6,fw,h]);

translate([mr*(cos($time)-1),0,0])OF();
rotate([0,0,$time])OC();