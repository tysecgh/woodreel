include <../main.scad>
include <../lib/line.scad>

$chamfflg = false;
$holeflg = false;

VIEW_ASSY_R(thetaA=25);

translate([0,0,RB_V_th+boardAw])
UNIT_S();


z = RB_V_th+boardAw+boardAw+S_V_w/2;

color("red")
translate([0,0,z])
cylinder(r=S_V_r+0.1,h=0.2,$fn=64);

color("red")
line([
    [-S_V_r,0,z],
    [-S_V_r,-S_V_r*0.5,z+S_V_w/2],
    [-S_V_r*0.9,-S_V_r*0.9,z+S_V_w/2+boardAw],
    [0,0,300]
]);