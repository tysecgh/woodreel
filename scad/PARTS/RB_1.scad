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
    x = 100+basex; y =240+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_RB_b();
    }

    svgtxt( RBb_X_ALL , [x+30,y+10] );
}

union(){
    x = 60+basex; y =160+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_RB_t0();
    }

    svgtxt( RBt0_X_ALL , [x+33,y+10] );
}

union(){
    x = 55+basex; y =70+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_RB_t1();
    }

    svgtxt( RBt1_X_ALL , [x+33,y+10] );
}

