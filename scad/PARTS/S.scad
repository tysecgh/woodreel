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
basex = 0; basey = -20;

union(){
    x = 50+basex; y =240+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_S_b();
    }

    svgtxt( Sb_X_ALL , [x+30,y+30] );
}

union(){
    x = 160+basex; y =200+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_S_m();
    }

    svgtxt( Sm_X_ALL , [x-130,y+10] );
}

union(){
    x = 50+basex; y =140+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_S_t();
    }

    svgtxt( St_X_ALL , [x+30,y+10] );
}

union(){
    x = 50+basex; y =80+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_GS();
    }

    svgtxt( GS_X_ALL , [x+30,y+10] );
}