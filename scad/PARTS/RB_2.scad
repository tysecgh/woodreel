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
    x = 60+basex; y =220+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_RB_t2();
    }

    svgtxt( RBt2_X_ALL , [x+33,y+10] );
}

union(){
    x = 55+basex; y =120+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_RB_t3();
    }

    svgtxt( RBt3_X_ALL , [x+33,y+10] );
}

union(){
    x = 70+basex; y =50+basey;     
    switch_proj()
    translate([x,y,0]){
        rotate([0,0,90])
        PART_RS();
    }

    svgtxt( RS_X_ALL , [x+40,y+10] );
}
