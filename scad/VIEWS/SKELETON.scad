include <../main.scad>

$holeflg = false;
$chamfflg = false;

$time = 30;

VIEW_SKELETON($time);

//[25,25,0] rotate=[45,0,160] distance=500
// "C:\Program Files (x86)\OpenSCAD\openscad" -o out.png --camera=30,-10,0,45,0,160,500 SKELETON.scad