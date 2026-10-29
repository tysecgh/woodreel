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
        PART_MS_b();
    }

    svgtxt( MSb_X_ALL , [x+30,y+30] );
}


union(){
    x = 50+basex; y =180+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_MS_t0();
    }

    svgtxt( MSt0_X_ALL , [x+30,y+30] );
}

union(){
    x = 50+basex; y =120+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_MS_t1();
    }

    svgtxt( MSt1_X_ALL , [x+30,y+30] );
}


