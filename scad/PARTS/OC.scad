include <../main.scad>
include <../lib/svgtxt.scad>
include <../lib/scale.scad>
$nameflg = true;

$prjflg = false; // 調整時 false にしておくとpreviewが軽い
module switch_proj() {
    if ($prjflg) projection() children();
    else children();
}

// A4外枠 & 余白マーカー
difference(){ 
    w = 210; h = 297; 
    d = $prjflg ? 1 : 20 ;
    square([w,h]); translate([d,d]) square([w-2*d,h-2*d]); 
}
// これが実寸に会うと縮小されてない
scale([20,15,0]);

///////////////////////////////
///////////////////////////////
basex = 0; basey = 0;

union(){
    x = 60+basex; y =230+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_OC_g();
    }

    svgtxt( OCg_X_ALL , [x+40,y+30] );
}

union(){
    x = 110+basex; y =200+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_OC_c();
    }

    svgtxt( OCc_X_ALL , [x+15,y+15] );
}

union(){
    x = 40+basex; y =170+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_OF();
    }

    svgtxt( OF_X_ALL , [x+35,y+10] );
}

union(){
    x = 85+basex; y =90+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_GM();
    }

    svgtxt( GM_X_ALL , [x+45,y-43] );
}