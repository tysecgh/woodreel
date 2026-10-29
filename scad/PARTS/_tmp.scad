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
    x = 60+basex; y =200+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_RA_r();
    }
    svgtxt( RAr_X_ALL, [x-25,y+10] );
}


union(){
    x = 120+basex; y =230+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_HK_b();
    }
    svgtxt( HKb_X_ALL, [x-10,y-5] );
}

union(){
    x = 160+basex; y =170+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_HK_k();
    }
    svgtxt( HKk_X_ALL, [x-70,y+25] );
}
union(){
    x = 110+basex; y =155+basey;     
    switch_proj()
    translate([x,y,0]){
        PART_HK_n();
    }
    svgtxt( HKn_X_ALL, [x-60,y] );
}

union(){
    x = 40+basex; y =175+basey;     
    switch_proj()
    translate([x,y,0]){
        rotate([0,90,0]) PART_HK_s();
    }
    svgtxt( HKs_X_ALL, [x-10,y-5] );
}

union(){
    x = 30+basex; y =120+basey;     
    switch_proj()
    translate([x,y,0]){
        rotate([0,90,0]) PART_MS_s0();
    }
    svgtxt( MSs0_X_ALL, [x+100,y+10] );
}
union(){
    x = 30+basex; y =105+basey;     
    switch_proj()
    translate([x,y,0]){
        rotate([0,90,0]) PART_MS_s2();
    }
    svgtxt( MSs2_X_ALL, [x+100,y+10] );
}
union(){
    x = 30+basex; y =90+basey;     
    switch_proj()
    translate([x,y,0]){
        rotate([0,90,0]) PART_MS_s4();
    }
    svgtxt( MSs4_X_ALL, [x+100,y+10] );
}
union(){
    x = 30+basex; y =75+basey;     
    switch_proj()
    translate([x,y,0]){
        rotate([0,90,0]) PART_MS_s8();
    }
    svgtxt( MSs8_X_ALL, [x+100,y+10] );
}
union(){
    x = 30+basex; y =60+basey;     
    switch_proj()
    translate([x,y,0]){
        rotate([0,90,0]) PART_MS_s10();
    }
    svgtxt( MSs10_X_ALL, [x+100,y+10] );
}

union(){
    x = 30+basex; y =40+basey;     
    switch_proj()
    translate([x,y,0]){
        rotate([0,90,0]) PART_OC_s();
    }
    svgtxt( OCs_X_ALL, [x+100,y+17] );
}
union(){
    x = 30+basex; y =25+basey;     
    switch_proj()
    translate([x,y,0]){
        rotate([0,90,0]) PART_HS();
    }
    svgtxt( HS_X_ALL, [x+100,y+10] );
}
