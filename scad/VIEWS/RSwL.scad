include <../main.scad>
include <../lib/line.scad>

$chamfflg = false;
$holeflg = false;

$time = 185;

if($time<81){
VIEW_ASSY_R(thetaA=80-$time);
}else if($time<90){
    VIEW_ASSY_R();
}else{
    rotate([0,0,$time-90])
        VIEW_ASSY_R();
}
translate([0,0,RB_V_th+boardAw])
UNIT_S();


z = RB_V_th+boardAw+boardAw+S_V_w/2;

color("red")
translate([0,0,z])
cylinder(r=S_V_r+0.1,h=0.2,$fn=64);




ly = R_V_as+S_V_r*0.9;
lz = 80-22.5;


// lz = oy * sin(t) + oz * cos(t) 
// ly = oy * cos(t) - oz * sin(t)

ot  = 25;
oz = (cos(ot)*lz - sin(ot)*ly) ;
oy = (cos(ot)*ly + sin(ot)*lz) ;




if( $time > 55 ){

tz = oy * sin(80-$time) + oz * cos(80-$time);
ty = oy * cos(80-$time) - oz * sin(80-$time);

if( $time < 69){    

line([
    [-S_V_r,0,z],
    [-S_V_r,-S_V_r*0.5,z+S_V_w/2],
    [-S_V_r*0.9,-S_V_r*0.9,z+S_V_w/2+boardAw],
    [-S_V_r*0.9,-(ty-R_V_as),22.5+tz],
    [0,0,300]
]);
}else if( $time < 71){
line([
    [-S_V_r,0,z],
    [-S_V_r,-S_V_r*0.5,z+S_V_w/2],
    [-S_V_r*0.9,-(ty-R_V_as),22.5+tz],
    [0,0,300]
]);
}else if( $time < 81){
line([
    [-S_V_r,0,z],
    [-S_V_r*0.9,-(ty-R_V_as),22.5+tz],
    [0,0,300]
]);
}else{
line([
    [-S_V_r,0,z],
    [-S_V_r*0.9,-(oy-R_V_as),22.5+oz],
    [0,0,300]
]);
}

}else{
    
line([
    [-S_V_r,0,z],
    [-S_V_r,-S_V_r*0.5,z+S_V_w/2],
    [-S_V_r*0.9,-S_V_r*0.9,z+S_V_w/2+boardAw],
    [-S_V_r*0.9,-(ly-R_V_as),22.5+lz],
    [0,0,300]
]);    
}
/*
line([
    [-S_V_r,0,z],
    [-S_V_r,-S_V_r*0.5,z+S_V_w/2],
    [-S_V_r*0.9,-S_V_r*0.9,z+S_V_w/2+boardAw],
    [-S_V_r*0.9,-(ty-R_V_as),22.5+tz]
//    ,[0,1000,0]
]);
*/