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
basex = 0; basey = -50;
union(){
    x = 35; y =260+basey;     
    switch_proj()
    translate([x,y,0])
    PART_RA_i();
    
    svgtxt( RAi_X_ALL, [x+40,y+50] );
}
union(){
    x = 60; y =215+basey;     
    switch_proj()
    translate([x,y,0])
    PART_RA_c();
    
    svgtxt( RAc_X_ALL, [x+40,y+50] );
}
union(){
    x = 90; y =185+basey;     
    switch_proj()
    translate([x,y,0])
    PART_RA_o();
    
    svgtxt( RAo_X_ALL, [x+35,y+40] );
}

union(){
    x = 35; y =150+basey;     
    switch_proj()
    translate([x,y,0])
    PART_RA_subi();
    
    svgtxt( RAsubi_X_ALL, [x+70,y+15] );
}
union(){
    x = 70; y =130+basey;     
    switch_proj()
    translate([x,y,0])
    PART_RA_subo();
    
    svgtxt( RAsubo_X_ALL, [x+35,y+10] );
}

union(){
    x = 30; y =100+basey;     
    switch_proj()
    translate([x,y,0])
    PART_RA_bo();
    
    svgtxt( RAbo_X_ALL, [x+80,y+10] );
}

union(){
    x = 30; y =75+basey;     
    switch_proj()
    translate([x,y,0])
    PART_RA_bi();
    
    svgtxt( RAbi_X_ALL, [x+80,y+15] );
}