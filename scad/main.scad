// Copyright (c) 2026 tysecgh
// CC BY 4.0 https://creativecommons.org/licenses/by/4.0/

/////////////////////////////////
//// ヘルパー
/////////////////////////////////

_margin_ = 1;
_inflate_ = 3;

$holeflg = true;
$chamfflg = true;


$echoflg = false;
$nameflg = false;   // 1: 各部品の外側に名前ラベルを出す

function join(v, i = 0) =
	i >= len(v) ? "" :
	i == len(v) - 1 ? str(v[i]) :
	str(v[i], "+", join(v, i + 1));

function xytxt(x,y) = str(" x:",x," y:",y);

module rectangle(p1, p2) {
	translate(p1) square(p2 - p1);
}

module board(p, h){
	linear_extrude(h) square(p);
}

module chamf(chmfw,h){
	if( chmfw> 0){
		if( $chamfflg ){
			csize = min(5,chmfw/3);
			csp = min(csize*2.7,chmfw-1);
			translate([0,0,-_margin_])
			linear_extrude(h+_margin_*2){
				text(str(chmfw),size = csize,font = "Noto Sans JP");
				polygon([
					[csp,-_margin_],
					[chmfw,0],
					[0,chmfw],
					[-_margin_,csp]
				]);
			}
		}else{
			translate([0,0,-_margin_])
			linear_extrude(h+_margin_*2)
			polygon([
				[-_margin_,-_margin_],
				[chmfw,0],
				[0,chmfw]
			]);
		}
	}
}

module chamfBoard(p,llw,lrw,rlw,rrw,h){

	x=p[0]; y=p[1];

	difference(){
		linear_extrude(h) square([x,y]);

		chamf(llw,h);
		translate([0,y,0])rotate([0,0,-90])chamf(lrw,h);
		translate([x,y,0])rotate([0,0,-180])chamf(rrw,h);
		translate([x,0,0])rotate([0,0,90])chamf(rlw,h);
	}
}

module cMarker(r,h){
	translate([0,0,0-_margin_])
	difference(){
		cylinder(h=h+_margin_*2,r=r*0.9,$fn=24);
		translate([0,0,0-_margin_]) cube( [r,r,h+_margin_*4] );
	}
}


// 名前ラベル
module name_view(name,namep){
	if( $nameflg ){
		translate(namep+[0,3,0])
		linear_extrude(height = 1)
		text(name, size = 5, font = "Noto Sans JP");
	}
}

module hole(r,h){
	translate([0,0,0-_margin_])
	difference(){
		cylinder(h=h+_margin_*2,r=r,$fn=24);


		if( $holeflg ){
			if( r > 10 ){
				translate([1,1,0-_margin_])
				linear_extrude(height=h+_margin_*4){
					text( str("r",r), size=3);
				}
				cMarker(9,h+_margin_*2);

			}
			else{
				cMarker(r*0.9,h+_margin_*2);
			}
		}
	}

}

module cut(p1, p2, h){
	translate([0,0,0-_margin_])
	translate([p1[0],p1[1],0])
	board(p2-p1, h=h+_margin_*2);
}

module cutOff(p1, p2,h){
	v = p1-p2;
	w = [v.y,-v.x];

	translate([0,0,0-_margin_])
	linear_extrude(h+_margin_*2)
	polygon([
		p1 + 0.5*v,
		p2 - 0.5*v,
		p2 + _inflate_*(w - v) ,
		p1 + _inflate_*(w + v)
	]);
}

module cutOffCorner(p,sw,w,h){
	px = [w,0]; py = [0,w];

	translate([0,0,0-_margin_])
	linear_extrude(h+_margin_*2)
	if( sw == "ll" ){
		polygon([ p+px, p+[-_margin_,-_margin_], p+py ]);
	}else if( sw == "lr" ){
		polygon([ p+px, p+[-_margin_,_margin_], p-py ]);
	}else if( sw == "rr" ){
		polygon([ p-px, p+[_margin_,_margin_], p-py ]);
	}else if( sw == "rl" ){
		polygon([ p-px, p+[_margin_,-_margin_], p+py ]);
	}

}


/////////////////////////////////
//// パラメータ
/////////////////////////////////


// 共通
pin_rad = 1.5;

boardAw = 6;
boardBw = 3;

// GM
GM_K_r = 55;   // 基準半径
GM_K_num = 31; // 歯数
GM_N_or = 60;  // 外半径

// GS
GS_K_r = 12;
GS_K_num = 8;
GS_N_or = 18;

// OC
OCg_K_num = 19;
OCg_K_r = 25;
OCg_K_h = 6; // 歯高

OCc_K_r = 12; // カム基準半径
OCc_K_w = 12; // カムオシレーション距離
OCgs_V_r = 3; // オシレーションギアシャフト半径

// OF
OF_N_xl = OCgs_V_r+6;
OF_N_xr = OCgs_V_r+OCc_K_w+12;
OF_N_yl = 9;
OF_N_yr = 9;

// S（スプール）
S_V_r = 23; // スプール半径
S_V_w = OCc_K_w+1; // スプール幅

// RB（ピンラックホイール）
RB_K_num = 12;
RB_K_r = 21;    // ピンラックホイール基準半径
RB_N_w = 12;    // ピンラックホイール幅
RB_N_or = RB_K_r+3;    // ピンラックホイール外半径

// H（ハンドル）
HS_V_r = 3; // ハンドルシャフト半径
HS_V_wr = RB_N_or; // メインシャフト中心面からGM内側面まで
HS_V_wl = boardAw * 3.5; // メインシャフト中心面からGS内側面まで
HS_N_wrx = 18; // 右余裕 （（本当の）ハンドル付ける）
HS_N_wlx = 12; // 左余裕
HS_N_w = HS_V_wr+HS_V_wl
	+ boardAw*2 // 両側ギア厚
	+ HS_N_wrx+HS_N_wlx;

// MS（メインシャフト）
MS_K_r = 18;  // メインシャフト大構造としての半径
MS_N_dh = 35; // 本体との接合部の長さ
MS_N_th = OCc_K_w + 20; // ローター保持部より先， スプール保持部
MS_K_vr = 3; // 各頂点柱の半径
MS_K_time0  = [0,15,0];
MS_K_time2  = [12,9,0];
MS_K_time4  = [12,-9,0];
MS_K_time8 = [-12,-9,0];
MS_K_time10  = [-12,9,0];

// R（ローター）
RA_N_lrw = 7; // ラインローラー幅

RA_N_sr = boardBw/2; // アーム軸半径

R_V_as = S_V_r + RA_N_lrw/2; // アーム軸位置(MSからの中心地同士の差,AS軸径奇数により.5であってほしい)

R_V_axm = S_V_r -2; // メインアーム位置
R_V_axs = R_V_axm + boardBw; // サブアーム位置

R_V_bw = R_V_axm + R_V_axs + 1; // アーム間の間隔

R_V_sw = 3; // アーム側のストッパー受け欠き幅

// RB
// MS軸中心を原点 l 負方向 ｒ 正方向
//RB_P_xl = R_V_ax + 9;
RB_P_xl = 31;
RB_P_xr = 29; // (落書き:幅60だと板材調達と加工でちょっと嬉しい)
RB_P_yl = 35;
RB_P_yr = 40;
RB_V_th = boardBw*5 + RB_N_w; // RBの底面からMSの受け面までの距離
RB_N_xw = RB_P_xl + RB_P_xr;
RB_N_yw = RB_P_yl + RB_P_yr;
R_V_abm = RB_P_yr - R_V_as ; // アームブリッジとアーム軸間に必要なマージン

// RA（アーム）
// RA 軸中心を原点
RA_N_lr = 4; // ラインローラー半径

RAbo_N_w = R_V_bw+boardBw*5; // アームブリッジ長さ
RAbi_N_w = R_V_bw;
RAb_N_h = 12; // アームブリッジ幅

// 軸中心から糸ローラー軸中心までの長さ
RA_V_val = boardBw/2   // 軸半径
	+ boardBw       // 軸を受けるRBの板 t2
	+ boardAw       // RBを受けるMSの板
	+ boardAw       // スプール下部板厚
	+ S_V_w           // スプール部高さ, ここまでが糸の高さ
	+ RA_N_lr;

// 軸中心から上端までの長さ
RA_P_yr = RA_V_val + RA_N_lr + 6.5;

RAsub_P_yr = 
    RA_V_val - RA_N_lr-0.5 // ここで R_V_abm を超えないといけない
    + 6;


RA_P_xr = RA_N_lrw ;// 軸中心からストッパー受け端までの幅（ライン（ローラー）の両端を支える）
RA_P_xr2 = RA_N_lrw + 6;
RA_P_xl = 6;

// 軸中心から下端までの長さ(回転干渉からRA_P_xr以下)
RA_P_yl = RA_N_lrw;

RA_N_yw = RA_P_yl+RA_P_yr;
RA_N_xw = RA_P_xl+RA_P_xr2;

RAsub_N_yw = RA_P_yl+RAsub_P_yr;
RAsub_N_xw = RA_P_xl+RA_P_xr2;

// 軸中心から右端までの長さ
RA_N_rw = 6;


// RS
RS_P_xr = 6;

RS_P_xl = 6;

RB_N_sx = R_V_axm+RS_P_xr;
RB_N_sy = 7;

RS_P_yr = RB_N_sy + R_V_as - RA_P_xr + R_V_sw - 0.5;

RS_P_yl = RS_P_yr;

RB_N_acuty = R_V_as-RA_P_xr-0.5;

// B
B_K_mhd  = 3; // ハンドル軸とメインシャフトの高さズレ（直交せずねじれ位置にある）
B_K_hodx = 35; // ハンドル軸とオシレションカム軸のx座標差
B_K_hody = 12; // ハンドル軸とオシレションカム軸のy座標差

B_P_ocp = [-B_K_hodx,-B_K_hody];



B_V_ocgsr = OCg_K_r+OCg_K_h/2+1; // オシレーションカム歯車スペース

B_P_xr = GM_K_r  // ピンラックホイール歯の幅真ん中=ハンドルギアの基準半径
	-(RB_N_w/2)  // ピンラックホイール歯の底端まで
	-boardBw; // ピンラックホイールの底厚底圧引いてボディと接触するつら
B_P_xl = B_K_hodx + B_V_ocgsr + 6 ;
B_P_yl = B_K_hody + B_V_ocgsr + 6 ;
B_P_yr = - B_K_hody + B_V_ocgsr + 12 ;

B_N_chamfll = B_P_xl - (floor((B_V_ocgsr+6)/2)+B_K_hodx);
B_N_chamflr = B_P_yr - (floor((B_V_ocgsr+6)/2)- B_K_hody);

B_P_row = 50;
Br_P_xl = B_P_row;
Br_P_yr = B_P_row;

B_N_xw = B_P_xl + B_P_xr;
B_N_yw = B_P_yl + B_P_yr;

Br_N_xw = Br_P_xl + B_P_xr;
Br_N_yw = B_P_yl + Br_P_yr;

Bf_N_h   = 60;   // 足の高さ
Bf_N_w   = 20;   // 足の幅
Bf_N_ox  = 10;   // 足の前への張り出し
B_P_pinp = [B_P_xr-MS_N_dh+17, -B_K_mhd+MS_K_time0[1]+3];  // メインシャフト固定ピン穴の位置

B_N_chamfrl = B_P_yl-B_K_mhd-RB_N_or;

//B_N_chamfrr = B_P_row+B_K_mhd-RB_N_or-2;
Br_N_chamflr = B_P_row*0.6;
Br_N_chamfll = Br_N_chamflr -(B_P_row-B_P_yl);
Br_N_chamfrr = Br_N_chamflr -(B_P_row-B_P_xr);
Br_N_chamfrl = B_N_chamfrl;
//Br_N_chamfrl = Br_N_chamflr -(B_P_row-B_P_xr)-(B_P_row-B_P_yl);

B_N_chamfrr = Br_N_chamflr -(B_P_row-B_P_xr)-(Br_P_yr-B_P_yr);

B_N_chamflr3 = Br_P_yr - B_P_yr;
B_P_xl3 = Br_P_xl - Br_N_chamflr + B_N_chamflr3;


/////////////////////////////////
//// 汎用部品
/////////////////////////////////

module pin(h){
	cylinder(h=h,r=pin_rad,$fn=24);
}

module crown_pins(pr,pnum,ph){
	for( i=[0:pnum-1]){
		rotate([0,0,i*360/pnum])
		translate([pr,0,0])
		pin( ph );
	}
}

module crown_holes(pr,pnum,h){
	for( i=[0:pnum-1]){
		rotate([0,0,i*360/pnum])
		translate([pr,0,0])
		hole( pin_rad,h );
	}
}

module pin_disc_crown_disc(r,h,pr,pnum){
	difference(){
		cylinder(h=h,r=r,$fn=96);
		crown_holes(pr,pnum,h);
	}
}

module pin_disc_crown(r,h,pr,ph,pnum){
	cylinder(h=h,r=r,$fn=96);
	for( i=[0:pnum-1]){
		rotate([0,0,i*360/pnum])
		translate([pr,0,0])
		pin( h+ph );
	}
}

module pin_disc(r,h,ph,pnum){
	cylinder(h=h,r=r,$fn=96);
	for( i=[0:pnum-1]){
		rotate([0,0,i*360/pnum])
		translate([r,0,h/2])
		rotate([0,90,0])
		pin( ph );
	}
}

module heart_cam(r, R, h) {
	min_r = r - pin_rad/2;
	max_r = R - pin_rad/2;
	steps = 24;
	step_angle = 360 / steps;

	points = [
		for (i = [0 : steps - 1])
		let(
			angle = i * step_angle,
			r = max_r - (max_r - min_r) * 2 * abs(i - steps/2) / steps
		)
		[r * cos(angle), r * sin(angle)]
	];

	linear_extrude(height = h) {
		polygon(points);
	}
}


/////////////////////////////////
//// 部品・ユニット
/////////////////////////////////


//////////////////////
// GM
GM_X_name = "PART_GM";

module PART_GM(){
	h = boardAw;
	difference(){
		pin_disc_crown_disc(GM_N_or,h,GM_K_r,GM_K_num);
		hole(HS_V_r,h);
	}

	namep = [-GM_N_or, GM_N_or-5, 0];
	name_view(GM_X_name,namep);
}

	// データ表示部
GM_X_ALL = [
	GM_X_name,
	str("外径:",GM_N_or*2," 板厚:",boardAw),
	str("基準半径:",GM_K_r),
    str(" 歯数:",GM_K_num," ピン r:",pin_rad),
	str("軸穴 r:",HS_V_r)
];

module UNIT_GM(){
	th = 6;
	PART_GM();
	crown_pins(GM_K_r,GM_K_num,boardAw+th);
}


//////////////////////
// GS

GS_X_name = "PART_GS";

module PART_GS(){


	h = boardAw;
	difference(){
		pin_disc_crown_disc(GS_N_or,h,GS_K_r,GS_K_num);

		hole(HS_V_r,h);
	}

	namep = [-GS_N_or, GS_N_or, 0];
	name_view(GS_X_name,namep);
}
GS_X_ALL = [
	GS_X_name,
	str("外径:",GS_N_or*2," 板厚:",boardAw),
	str("基準半径:",GS_K_r," 歯数:",GS_K_num," ピン r:",pin_rad),
	str("軸穴 r:",HS_V_r)
];

module UNIT_GS(){
	th = 6;
	PART_GS();
	crown_pins(GS_K_r,GS_K_num,boardAw+th);
}


//////////////////////
// OC

OCg_X_name = "PART_OC_g";
module PART_OC_g(){



	h = boardAw;
	difference(){
		pin_disc(OCg_K_r-OCg_K_h/2,h,OCg_K_h,OCg_K_num);
		hole(OCgs_V_r,h);
	}

	namep = [-(OCg_K_r+OCg_K_h/2), OCg_K_r+OCg_K_h/2, 0];	name_view(OCg_X_name,namep);
}

OCg_X_ALL = [
	OCg_X_name,
	str("円盤 r:",OCg_K_r-OCg_K_h/2," 板厚:",boardAw),
	str("基準半径:",OCg_K_r," 歯数:",OCg_K_num),
    str(" 歯高:",OCg_K_h," ピン r:",pin_rad),
	str("軸穴 r:",OCgs_V_r)
];

OCc_X_name = "PART_OC_c";
module PART_OC_c(){


	h = boardAw;
	difference(){
		heart_cam(OCc_K_r-OCc_K_w/2,OCc_K_r+OCc_K_w/2,h);

		hole(OCgs_V_r,h);
	}

	namep = [-(OCc_K_r+OCc_K_w/2), OCc_K_r+OCc_K_w/2, 0];
	name_view(OCc_X_name,namep);
}
OCc_X_ALL =[
	OCc_X_name,
	str("カム半径:",OCc_K_r-OCc_K_w/2,"〜",OCc_K_r+OCc_K_w/2," 板厚:",boardAw),
	str("ストローク:",OCc_K_w),
	str("軸穴 r:",OCgs_V_r),
    str("外形位置に無数のd3穴")
];

module ASSY_OC(){
	PART_OC_g();
	translate([0,0,boardAw]) PART_OC_c();
}


//////////////////////
// OF

OF_X_name = "PART_OF";
module PART_OF(){


	h=boardAw;
	//translate([-OCc_K_w,0,0])
	difference(){
		translate([-OF_N_xl,-OF_N_yl,0])
		board([OF_N_xr,OF_N_yr]-[-OF_N_xl,-OF_N_yl],h);

		// カム軸スペース
		hole(OCgs_V_r,h);
		translate([OCc_K_w,0,0]) hole(OCgs_V_r,h);
		cut([0,-OCgs_V_r],[OCc_K_w,OCgs_V_r],h);

		// オシレション伝達シャフト連結ピン用穴
		translate([OCc_K_r+OCc_K_w/2+5,0,0]) hole(pin_rad,h);

		// カム接触子ピン穴
		translate([OCc_K_r+OCc_K_w/2,0,0]) hole(pin_rad,h);
		translate([-(OCc_K_r-OCc_K_w/2),0,0]) hole(pin_rad,h);

	}

	namep = [-OF_N_xl, OF_N_yr, 0];
	name_view(OF_X_name,namep);
}
OF_X_ALL = [
	OF_X_name,
	str("外接長方形:",OF_N_xl+OF_N_xr,"X",OF_N_yl+OF_N_yr),
	str("カム軸スペース ",
        " x:", join([OF_N_xl,OCc_K_w,OF_N_xr-OCc_K_w]),
        " y:", join([OF_N_yl-OCgs_V_r,OCgs_V_r*2,OF_N_yr-OCgs_V_r])
    ),
	str("連結ピン穴 x:",
        OF_N_xl+OCc_K_r+OCc_K_w/2+5,"+",OF_N_xr-(OCc_K_r+OCc_K_w/2+5),
        " y:",OF_N_yl,"+",OF_N_yr
    ),
	str("カム接触子ピン穴 ",
        " x:",OF_N_xl-(OCc_K_r-OCc_K_w/2),"+",OCc_K_r*2,"+",
        OF_N_xr-(OCc_K_r+OCc_K_w/2)," y:",OF_N_yl,"+",OF_N_yr
    )
];

module UNIT_OF(){
	PART_OF();


	translate([OCc_K_r+OCc_K_w/2+5,0,0]) pin(boardAw*2);

	translate([OCc_K_r+OCc_K_w/2,0,-boardAw]) pin(boardAw*2);
	translate([-(OCc_K_r-OCc_K_w/2),0,-boardAw]) pin(boardAw*2);
}

OCs_N_r = 3; // 伝達シャフト半径
OCs_V_l = B_K_hodx - OCgs_V_r + B_P_xr // 最も埋まった時のボディ内部の長さ
    + RB_V_th + boardAw + (S_V_w+boardAw*2)+2;

// オシレション伝達シャフト
OCs_X_name = "PART_OC_s";
module PART_OC_s(){
    cylinder(r=OCs_N_r,h=OCs_V_l,$fn=12);

	namep = [0,OCs_N_r];
    rotate([0,-90,0])
	name_view(OCs_X_name,namep);
}
OCs_X_ALL = [
    OCs_X_name,
    str("円柱 r:",OCs_N_r," h:",OCs_V_l)
];



module ASSY_OF(){
	UNIT_OF();

	// オシレション伝達シャフト
	translate([OCc_K_w+OCgs_V_r,0,3+boardAw])
	rotate([0,90,0])
	PART_OC_s();

translate([
    OCc_K_w+OCgs_V_r+
    B_K_hodx - OCgs_V_r + B_P_xr + RB_V_th + boardAw+2,
    9,boardAw*1.5
])
rotate([0,90,0])
UNIT_S();

}
//////////////////////
// RB

module PART_RB_abstract(h,r){
	difference(){

		translate([-RB_P_xl,-RB_P_yl,0])
		chamfBoard([RB_N_xw,RB_N_yw],12,0,12,0,h);

		// 中央穴
		hole(h=h,r=r);

		// ストッパー軸
		translate([-RB_N_sx,-RB_N_sy,0]) hole(pin_rad, h);


		// アーム用切り欠き
		cut(
			[-RB_P_xl-_margin_,RB_N_acuty],
			[-R_V_axm, RB_P_yr+_margin_],
			h
		);

		cut(
			[R_V_axs,RB_N_acuty],
			[RB_P_xl+_margin_, RB_P_yr+_margin_],
			h
		);

		// 切り欠き後の橋丸め
		edgecutr = 6;
		translate([-R_V_axm,RB_P_yr])rotate([0,0,-90])
		chamf(edgecutr,h);
		translate([R_V_axs,RB_P_yr])rotate([0,0,-180])
		chamf(edgecutr,h);

	}
}

RBb_X_name = "PART_RB_b";
module PART_RB_b(){
	h = boardBw;
	difference(){
		//		pin_disc_crown(RB_N_or,boardBw,RB_K_r,RB_N_w,RB_K_num);
		pin_disc_crown_disc(RB_N_or,h,RB_K_r,RB_K_num);

		hole(MS_K_r,h);
	}

	namep = [-RB_N_or, RB_N_or, 0];
	name_view(RBb_X_name,namep);   // 名前表示($name_sw=1)
}
RBb_X_ALL = [
	RBb_X_name,
	str("内半径",MS_K_r),
	str("外半径",RB_N_or),
	str("基準半径",RB_K_r,",歯数",RB_K_num)
];

RB_X_outrct = str("外接長方形:",RB_N_xw,"X",RB_N_yw);
RB_X_orgp = str("基準点: x:",RB_P_xl,"+",RB_P_xr," y:",RB_P_yl,"+",RB_P_yr);
RB_X_acut = str("切り欠き: x:",
	RB_P_xl-R_V_axm,"+",
	R_V_axm+R_V_axs,"+",
	RB_P_xr-R_V_axs,
	" y:",RB_P_yl+RB_N_acuty,"+",RB_P_yr-RB_N_acuty
);


RBt0_X_name = "PART_RB_t0";
module PART_RB_t0(){
	h = boardAw;
	difference(){
		PART_RB_abstract(h,MS_K_r);

		crown_holes(RB_K_r,RB_K_num,h);
	}

	namep = [-RB_P_xl, RB_P_yr, 0];
	name_view(RBt0_X_name,namep);
}
RBt0_X_ALL = [
	RBt0_X_name,
	RB_X_outrct,
	RB_X_orgp,
	RB_X_acut
];



RBt1_N_scutx = MS_K_r-6;
RBt1_N_scuty = MS_K_r+6;

RBt1_P_yr = R_V_as-RA_N_sr;

// ストッパー干渉切り落とし値
RBt1_P_srx = 7;
RBt1_P_sry = 15;

RBt1_X_name = "PART_RB_t1";
module PART_RB_t1(){
	difference(){
		PART_RB_abstract(boardBw,MS_K_r);

		// RA軸スリット
		cut(
			[-RB_P_xl-_margin_,R_V_as-RA_N_sr],
			[ RB_P_xr+_margin_,R_V_as+RA_N_sr],
			boardBw
		);

		// ストッパースぺース用切り欠き
		cutOff(
			[-R_V_axm,-RB_P_yl],
			[-R_V_axm,RB_P_yr],
			boardBw
		);

		// 新左下座標
		p = [-R_V_axm,-RBt1_N_scuty];

		// ストッパ干渉切り落とし
		cutOff(
			p - [-RBt1_P_srx,0],
			p - [0,-RBt1_P_sry],
			boardBw
		);


		// ストッパーバネスぺース用切り欠き
		cut(
			[-R_V_axm-_margin_,-RB_P_yl-_margin_],
			[RBt1_N_scutx,-RBt1_N_scuty],
			boardBw
		);


	}

	namep = [-RB_P_xl, RB_P_yr, 0];
	name_view(RBt1_X_name,namep);
}

RBt1_X_ALL = [
	RBt1_X_name,
	str("外接長方形:",R_V_axm+R_V_axs,"X",RB_P_yl+RB_P_yr),
	str("RA軸用スリット: y",join([
		RB_P_yl+R_V_as-RA_N_sr,
		RA_N_sr*2,
		RB_P_yr-R_V_as-RA_N_sr
	])),
	str("メインシャフト穴: r:",MS_K_r," x:",R_V_axm,"+",RB_P_xr," y:",RB_P_yl,"+",RBt1_P_yr),
	str("切り欠き右上: x:",
		R_V_axm+R_V_axs,"+",RB_P_xr-R_V_axs,
		" y:",RB_P_yl+RB_N_acuty,"+",RBt1_P_yr-RB_N_acuty
	),
	str("切り欠き左下: x:",
		R_V_axm+RBt1_N_scutx,"+",
		RB_P_xr-RBt1_N_scutx,
		" y:",RBt1_P_yr+RBt1_N_scuty,"+",RB_P_yl-RBt1_N_scuty
	),
	str(
		"ストッパー可動用欠き: x:",RBt1_P_srx,
		" y:",RBt1_P_sry
	)
];


RBt2_X_name = "PART_RB_t2";
module PART_RB_t2(){
	PART_RB_abstract(boardBw,MS_K_r);

	namep = [-RB_P_xl, RB_P_yr, 0];
	name_view(RBt2_X_name,namep);   // 名前表示($name_sw=1)
}
RBt2_X_ALL = [
	RBt2_X_name,
	RB_X_outrct,
	RB_X_orgp,
	RB_X_acut,
	str("中央穴 r:",MS_K_r," x:",RB_P_xl," y:",RB_P_yl)
];

RBt3_X_name = "PART_RB_t3";
module PART_RB_t3(){
	PART_RB_abstract(boardBw,MS_K_r+4);

	namep = [-RB_P_xl, RB_P_yr, 0];
	name_view(RBt3_X_name,namep);
}
RBt3_X_ALL = [
	RBt3_X_name,
	RB_X_outrct,
	RB_X_orgp,
	RB_X_acut,
	str("中央穴 r:",MS_K_r+4," x:",RB_P_xl," y:",RB_P_yl)
];

// ストッパー
RS_X_name = "PART_RS";
module PART_RS(){
	h = boardBw;

	difference(){
		linear_extrude(h)
		intersection(){
			rectangle( [-RS_P_xl,-RS_P_yl],[RS_P_xr,RS_P_yr]);
			// circle(RS_P_yl); // あんま変わらんので現物合わせに投げる
		}

		hole( pin_rad, h );
	}

	namep = [-RS_P_xl, RS_P_yr, 0];
	name_view(RS_X_name,namep);
}
RS_X_ALL = [
	RS_X_name,
	str("外接長方形:",RS_P_xl+RS_P_xr,"X",RS_P_yl+RS_P_yr),
	str("基準点: x:",RS_P_xl,"+",RS_P_xr," y:",RS_P_yl,"+",RS_P_yr),
	str("ピン穴 r:",pin_rad," x:",RS_P_xl," y:",RS_P_yl)
];

module ASSY_RB(){
	PART_RB_b();

	h1 = boardBw+RB_N_w;
	translate([0,0,h1]) PART_RB_t0();

	h2 = h1+boardAw;
	crown_pins(RB_K_r,RB_K_num,h2);
	translate([0,0,h2]) PART_RB_t1();


	h3 = h2+boardBw;
	translate([0,0,h3]) PART_RB_t2();
	h4 = h3+boardBw;
	translate([0,0,h4]) PART_RB_t3();
}


//////////////////////
// RA

module PART_RA_abstract(){
	h = boardBw;
	difference(){
		translate([-RA_P_xl,-RA_P_yl,0])
		board([RA_N_xw,RA_N_yw],h);


		// 糸ローラー部
		translate([0,RA_V_val+1,0])
		cut(
			[0,-RA_N_lr-0.5-_margin_],
			[RA_N_lrw,RA_N_lr+0.5]
			,h);

		// 糸移動経路
		translate([0,RA_V_val-RA_N_lr+1,0])
		cut(
			[0,-10],
			[RA_P_xr2+_margin_,0]
			,h);


		// RB用切り欠き
		cut(
			[RA_P_xr,-RA_P_yl-_margin_],
			[RA_P_xr2+_margin_,-RA_P_yl+boardAw+boardBw*3]
			,h);


		// ストッパー受け
		cut(
			[RA_P_xr-R_V_sw,-boardBw/2],
			[RA_P_xr+_margin_,boardBw/2]
			,h);

		// 軸
		hole( boardBw/2,h);
	}
}

RA_X_outrct = str("外接長方形:",RA_N_xw,"X",RA_N_yw);
RA_X_shp = str(
	"軸穴: x:",RA_P_xl,"+",RA_P_xr2,
	" y:",RA_P_yl,"+",RA_P_yr
);

RAi_X_name = "PART_RA_i";
module PART_RA_i(){
	PART_RA_abstract();

	namep = [-RA_P_xl, RA_P_yr, 0];
	name_view(RAi_X_name,namep);
}
RAi_X_ALL = [
	RAi_X_name,
	RA_X_outrct,
	RA_X_shp,
	str(
		"RB干渉切り欠き x:",RA_P_xl+RA_P_xr,"+",RA_P_xr2-RA_P_xr,
		" y:",boardAw+boardBw*3,"+",RA_N_yw-(boardAw+boardBw*3)
	),
	str("ラインローラ窓 x:",
		RA_P_xl,"+",RA_N_lrw,"+",RA_P_xr2-RA_N_lrw,
		" y:", RA_P_yl+RA_V_val+1-RA_N_lr-0.5,"+",RA_N_lr*2+1,"+",
		RA_P_yr - (RA_V_val+1+RA_N_lr+0.5)
	),
	str("ライン移動用 x:",
		RA_P_xl,"+",RA_P_xr2,
		" y:", RA_P_yl+RA_V_val+1-RA_N_lr-0.5-10,"+",10,"+",
		RA_P_yr - (RA_V_val+1-RA_N_lr-0.5)
	),
	str("ラインローラーまでの間隔",RA_V_val)
];

RAc_X_name = "PART_RA_c";
module PART_RA_c(){
	difference(){
		PART_RA_abstract();

		// 糸ローラー軸受け穴
		translate([0,RA_V_val+1,0])
		cut(
			[-RA_P_xl-_margin_,-1.5],
			[RA_P_xr2+_margin_,+1.5]
			,boardBw
		);
	}

	namep = [-RA_P_xl, RA_P_yr, 0];
	name_view(RAc_X_name,namep);
}
RAc_X_ALL = [
	RAc_X_name,
	RA_X_outrct,
	str(RAi_X_name," 参照"),
	str(
		"ラインローラー軸スリット: ",
		join([
			RA_P_yl+RA_V_val+1-1.5,3,RA_P_yr -(RA_V_val+1+1.5)
		])
	)
];

RAo_X_name = "PART_RA_o";
module PART_RA_o(){
	PART_RA_abstract();

	namep = [-RA_P_xl, RA_P_yr, 0];
	name_view(RAo_X_name,namep);
}
RAo_X_ALL = [
	RAo_X_name,
	RA_X_outrct,
	str(RAi_X_name," 参照")
];



RAbo_X_name = "PART_RA_bo";
module PART_RA_bo(){
	h=boardBw;
	difference(){
		board([RAbo_N_w,RAb_N_h],h);

	}

	namep = [0, RAb_N_h, 0];
	name_view(RAbo_X_name,namep);
}
RAbo_X_ALL = [
	RAbo_X_name,
	str("外接長方形:",RAbo_N_w,"X",RAb_N_h)
];

RAbi_X_name = "PART_RA_bi";
module PART_RA_bi(){
	h=boardBw;
	difference(){
		board([RAbi_N_w,RAb_N_h],h);

	}

	namep = [0, RAb_N_h, 0];
	name_view(RAbi_X_name,namep);
}
RAbi_X_ALL = [
	RAbi_X_name,
	str("外接長方形:",RAbi_N_w,"X",RAb_N_h)
];

RAr_N_d = RAbo_N_w;
RAr_N_fl = R_V_as+0.5+RA_P_xl + 9;

RAr_X_name = "PART_RA_r";
module PART_RA_r(){
    fl = R_V_as+0.5+RA_P_xl;
    x = 9;
    
    translate([0,fl+x,-3])
    linear_extrude(6){
        intersection(){
            difference(){
                circle(RAr_N_d/2+1);
                circle(RAr_N_d/2);
            }
            translate([-RAr_N_d/2-1,0,0])
            square([RAr_N_d+2,RAr_N_d/2]);
        }
        difference(){
            translate([-RAr_N_d/2-1,-RAr_N_fl,0])
            square([RAr_N_d+2,RAr_N_fl]);
        
            translate([-RAr_N_d/2,-RAr_N_fl,-_margin_])
            square([RAr_N_d,RAr_N_fl+2*_margin_]);
        }
    }

    namep = [-RAr_N_d/3,RAr_N_fl/3,0];
	name_view(RAr_X_name,namep);
}
RAr_X_ALL = [
	RAr_X_name,
	str("円弧径 d:",RAr_N_d),
	str("足長:",RAr_N_fl),
	str("全長概値:",RAr_N_d*1.6+RAr_N_fl*2)
];


 
module PART_RA_subabstract(){
	difference(){
		translate([-RA_P_xl,-RA_P_yl,0])
		board([RAsub_N_xw,RAsub_N_yw],boardBw);

		// 軸
		hole( boardBw/2,boardBw);
	}

}

RA_X_outrctsub = str("外接長方形:",RAsub_N_xw,"X",RAsub_N_yw);
RA_X_shpsub = str("軸穴: x:",RA_P_xl,"+",RA_P_xr2," y:",RA_P_yl,"+",RAsub_P_yr);

RAsubi_X_name = "PART_RA_subi";
module PART_RA_subi(){
	PART_RA_subabstract();

	namep = [-RA_P_xl, RAsub_P_yr, 0];
	name_view(RAsubi_X_name,namep);
}
RAsubi_X_ALL = [
	RAsubi_X_name,
	RA_X_outrctsub,
	RA_X_shpsub
];

RAsubo_X_name = "PART_RA_subo";
module PART_RA_subo(){
	PART_RA_subabstract();

	namep = [-RA_P_xl, RAsub_P_yr, 0];
	name_view(RAsubo_X_name,namep);
}
RAsubo_X_ALL = [
	RAsubo_X_name,
	RA_X_outrctsub,
	RA_X_shpsub
];


module ASSY_RA(){

	rotate([0,0,-90]){
		PART_RA_i();
		translate([0,0,boardBw]) PART_RA_c();
		translate([0,0,boardBw*2]) PART_RA_o();

		translate([0,0,-R_V_bw]){
			translate([0,0,-boardBw]) PART_RA_subi();
			translate([0,0,-boardBw*2]) PART_RA_subo();
		}
	}

	translate([R_V_abm+1.5,RA_N_rw,-(R_V_bw+boardBw*2)])
	rotate([0,-90,-90]){
        PART_RA_bo();
        translate([boardBw*2,0,-boardBw])
        PART_RA_bi();
    }
translate([RAsub_P_yr-3,RA_P_xl,-RAbo_N_w/2+boardBw*3])
rotate([0,90,180])
PART_RA_r();

}


//////////////////////
// MS

module PART_MS_abstract(r){
	h = boardAw;
	difference(){
		cylinder(r=r,h=h,$fn=24);

		translate(MS_K_time0) hole(MS_K_vr,h);
		translate(MS_K_time2) hole(MS_K_vr,h);
		translate(MS_K_time4) hole(MS_K_vr,h);
		translate(MS_K_time8) hole(MS_K_vr,h);
		translate(MS_K_time10) hole(MS_K_vr,h);

		translate([0,-9,0]) hole(3.1,h);
	}
}

MS_X_holes = [
	str("シャフト穴(0時) r:",MS_K_vr," x:",MS_K_time0[0]," y:",MS_K_time0[1]),
	str("シャフト穴(2時) r:",MS_K_vr," x:",MS_K_time2[0]," y:",MS_K_time2[1]),
	str("シャフト穴(4時) r:",MS_K_vr," x:",MS_K_time4[0]," y:",MS_K_time4[1]),
	str("シャフト穴(8時) r:",MS_K_vr," x:",MS_K_time8[0]," y:",MS_K_time8[1]),
	str("シャフト穴(10時) r:",MS_K_vr," x:",MS_K_time10[0]," y:",MS_K_time10[1]),
	str("オシレーションシャフト穴 r:3 x:0 y:-9")
];

MSb_X_name = "PART_MS_b";
module PART_MS_b(){
	PART_MS_abstract(MS_K_r);

	namep = [-MS_K_r, MS_K_r, 0];
	name_view(MSb_X_name,namep);   // 名前表示($name_sw=1)
}
MSb_X_ALL = [
	MSb_X_name,
	str("外径:",(MS_K_r)*2," 板厚:",boardAw),
	each MS_X_holes
];

MSt0_X_name = "PART_MS_t0";
module PART_MS_t0(){
	PART_MS_abstract(MS_K_r);

	namep = [-MS_K_r, MS_K_r, 0];
	name_view(MSt0_X_name,namep);
}
MSt0_X_ALL = [
	MSt0_X_name,
	str("外径:",(MS_K_r)*2," 板厚:",boardAw),
	each MS_X_holes
];

MSt1_X_name = "PART_MS_t1";
module PART_MS_t1(){
	PART_MS_abstract(MS_K_r+3);

	namep = [-(MS_K_r+3), MS_K_r+3, 0];
	name_view(MSt1_X_name,namep);
}

MSt1_X_ALL = [MSt1_X_name,
	str("外径:",(MS_K_r+3)*2," 板厚:",boardAw),
	each MS_X_holes
];

MS_N_hl = MS_N_dh+RB_V_th+boardAw+MS_N_th;
MS_N_hs = MS_N_dh+RB_V_th+boardAw;

MS_X_s0 = str("円柱 r:",MS_K_vr," 長さ:",MS_N_hl);

MSs0_X_name = "PART_MS_s0";
module PART_MS_s0(){
	cylinder(r=3,h=MS_N_hl,$fn=24);

	namep = [0, MS_K_vr, 0];
    rotate([0,-90,0])
	name_view(MSs0_X_name,namep);

}
MSs0_X_ALL = [MSs0_X_name,MS_X_s0];


MS_X_s2 = str("円柱 r:",MS_K_vr," 長さ:",MS_N_hs);

MSs2_X_name = "PART_MS_s2";
module PART_MS_s2(){
	cylinder(r=3,h=MS_N_hs,$fn=24);

	namep = [0, MS_K_vr, 0];
    rotate([0,-90,0])
	name_view(MSs2_X_name,namep);
}
MSs2_X_ALL = [MSs2_X_name,MS_X_s2];

MSs4_X_name = "PART_MS_s4";
module PART_MS_s4(){
	cylinder(r=3,h=MS_N_hl,$fn=24);

	namep = [0, MS_K_vr, 0];
    rotate([0,-90,0])
	name_view(MSs4_X_name,namep);
}
MSs4_X_ALL = [MSs4_X_name,MS_X_s0];

MSs8_X_name = "PART_MS_s8";
module PART_MS_s8(){
	cylinder(r=3,h=MS_N_hl,$fn=24);

	namep = [0, MS_K_vr, 0];
    rotate([0,-90,0])
	name_view(MSs8_X_name,namep);
}
MSs8_X_ALL = [MSs8_X_name,MS_X_s0];

MSs10_X_name = "PART_MS_s10";
module PART_MS_s10(){
	cylinder(r=3,h=MS_N_hs,$fn=24);

	namep = [0, MS_K_vr, 0];
    rotate([0,-90,0])
	name_view(MSs10_X_name,namep);
}
MSs10_X_ALL = [MSs10_X_name,MS_X_s2];

module ASSY_MS(){
	PART_MS_b();
	h2 = RB_V_th;
	translate([0,0,h2]) PART_MS_t1();
	h1 = h2 - boardAw;
	translate([0,0,h1]) PART_MS_t0();

	translate([0,0,-MS_N_dh]){
		translate(MS_K_time0) PART_MS_s0();
		translate(MS_K_time2) PART_MS_s2();
		translate(MS_K_time4) PART_MS_s4();
		translate(MS_K_time8) PART_MS_s8();
		translate(MS_K_time10) PART_MS_s10();
	}
}


//////////////////////
// S

module PART_S_abstract(r,h){
	difference(){
		cylinder(r=r,h=h,$fn=24);

		translate(MS_K_time0) hole(3,21);
		translate(MS_K_time4) hole(3,21);
		translate(MS_K_time8) hole(3,21);

		translate([0,-9,0]) hole(3,21);
	}
}

S_X_holes = [
	MS_X_holes[0],
	MS_X_holes[2],
	MS_X_holes[3],
	MS_X_holes[5]
];

Sb_X_name = "PART_S_b";
module PART_S_b(){
	r =  S_V_r+2;
	PART_S_abstract(r,boardAw);

	namep = [-r, r, 0];
	name_view(Sb_X_name,namep);
}
Sb_X_ALL = [
    Sb_X_name,
    str(" r:",S_V_r+2," h:",boardAw),
    each S_X_holes
];

Sm_X_name = "PART_S_m";
module PART_S_m(){
	r =  S_V_r;
	PART_S_abstract(r,S_V_w);

	namep = [-r, r, 0];
	name_view(Sm_X_name,namep);
}
Sm_X_ALL = [
    Sm_X_name,
    str(" r:",S_V_r," h:",S_V_w),
    each S_X_holes
];

St_X_name = "PART_S_t";
module PART_S_t(){
	r =  S_V_r+2;
	PART_S_abstract(r,boardAw);

	namep = [-r, r, 0];
	name_view(St_X_name,namep);
}
St_X_ALL = [
    St_X_name,
    str(" r:",S_V_r+2," h:",boardAw),
    each S_X_holes
];

module UNIT_S(){
	PART_S_b();
	translate([0,0,boardAw]) PART_S_m();
	translate([0,0,boardAw+S_V_w]) PART_S_t();

}


//////////////////////
// B

module PART_B_boardL(h){
	translate([-B_P_xl,-B_P_yl,0])
	chamfBoard([B_N_xw,B_N_yw],
		B_N_chamfll,
		B_N_chamflr,
		B_N_chamfrl,
		B_N_chamfrr
		,h);
}

module PART_B_boardL2(h){
	difference(){
		union(){
			translate([-B_P_xl,-B_P_yl,0])
			board([B_N_xw,B_N_yw],h);
			translate([-B_P_xl3,B_P_yr,0])
			board([B_P_xl3+B_P_xr,Br_P_yr-B_P_yr],h);
		}

		translate([-B_P_xl,-B_P_yl,0])
		chamf(B_N_chamfll,h);
		translate([B_P_xr,-B_P_yl,0])
		rotate([0,0,90])
		chamf(B_N_chamfrl,h);
		translate([B_P_xr,Br_P_yr,0])
		rotate([0,0,-180])
		chamf(Br_N_chamfrr,h);
		translate([-B_P_xl,B_P_yr,0])
		rotate([0,0,-90])
		chamf(B_N_chamflr,h);

		translate([-B_P_xl3,Br_P_yr,0])
		rotate([0,0,-90])
		chamf(B_N_chamflr3,h);
	}
}

module PART_B_boardR(h){

	translate([-Br_P_xl,-B_P_yl,0])
	chamfBoard([Br_N_xw,Br_N_yw],
		Br_N_chamfll,
		Br_N_chamflr,
		Br_N_chamfrl,
		Br_N_chamfrr,
		h);


}

module PART_B_boardC(h){
	translate([-B_P_xl,-B_P_yl,0])
	chamfBoard([B_N_xw,B_N_yw],
		B_N_chamfll,
		B_N_chamflr,
		B_N_chamfrl,
		0
		,h);

}


module PART_B_holes(h){
	// ハンドル軸穴
	hole(HS_V_r,h);
	// オシレーションクランク軸穴
	translate(B_P_ocp) hole(OCgs_V_r,h);
	// メインシャフト固定ピン用穴
	translate(B_P_pinp) hole(3,h);

}

B_X_outrct = str("外接長方形:",B_N_xw,"X",B_N_yw);


Bc_X_hhp = str(
	"ハンドル軸穴 r:",HS_V_r,
	xytxt(B_P_xl,B_P_yl)
);

B_X_ochpxy = xytxt(
	B_P_xl+B_P_ocp[0],B_P_yl+B_P_ocp[1]
);
B_X_ochp = str(
	"オシレーションクランク軸穴 r:",OCgs_V_r,B_X_ochpxy
);

B_X_msphp = str(
	"メインシャフト固定ピン穴 r:",3,xytxt(
		B_P_xl+B_P_pinp[0],
		B_P_yl+B_P_pinp[1]
	)
);

Bc_X_name = "PART_B_c";
module PART_B_c(){
	h = boardAw;
	difference(){
		PART_B_boardC(h);

		PART_B_holes(h);

		//  メインシャフト0時
		translate([0,-B_K_mhd+MS_K_time0[1],0])
		cut([B_P_xr-MS_N_dh,-3],[B_P_xr+_margin_,3],h);

		// オシレーションシャフト
		translate([0,-B_K_hody,0])
		cut([-B_P_xl-_margin_,-3],[B_P_xr+_margin_,3],h);


	}


	namep = [-B_P_xl, B_P_yr, 0];
	name_view(Bc_X_name,namep);
}
Bc_X_ALL = [
	Bc_X_name,
	B_X_outrct,
	Bc_X_hhp,
	B_X_ochp,
	B_X_msphp,
	str(
		"メインシャフト0時スリット: 深さ:",MS_N_dh,
		" y:",
		join([
			B_P_yl-B_K_mhd+MS_K_time0[1]-3,
			6,
			B_P_yr-(-B_K_mhd+MS_K_time0[1]+3)
		])
	),
	str(
		"オシレーションシャフトスリット: y:",
		join([
			B_P_yl-B_K_hody-3,6,
			B_P_yr+B_K_hody-3
		])
	)
];

Bf_X_name = "PART_B_f";
module PART_B_f(){
	h = boardAw;

	translate([B_P_xr-Bf_N_w+Bf_N_ox,B_P_yr])
	chamfBoard([Bf_N_w,Bf_N_h],0,0,Bf_N_ox,0,h);

	x = 12;
	translate([B_P_xr-Bf_N_w-x+Bf_N_ox,Br_P_yr,0])
	chamfBoard([x,x],0,x,0,0,h);

	translate([-B_P_xl3,B_P_yr,0])
	chamfBoard([B_P_xl3+B_P_xr,Br_P_yr-B_P_yr],0,Br_P_yr-B_P_yr,0,0,h);

	namep = [-B_P_xl3, Br_P_yr, 0];
	name_view(Bf_X_name,namep);
}

Bf_X_ALL = [
	Bf_X_name,
	str(
		"外接長方形: x",B_P_xl3+B_P_xr+Bf_N_ox,
		" y",Bf_N_h
	),
	str(
		"切り欠き: x",
		B_P_xl3+B_P_xr-Bf_N_w+Bf_N_ox,"+",Bf_N_w,
		" y",
		Br_P_yr-B_P_yr,"+",Bf_N_h-(Br_P_yr-B_P_yr)
	)
];

Bl1_X_name = "PART_B_l1";
module PART_B_l1(){
	h = boardAw;
	difference(){
		PART_B_boardC(h);

		PART_B_holes(h);

		// オシレーションカム受け子スペース
		translate(B_P_ocp)
		cut([-(OF_N_xl+OCc_K_w),-OF_N_yl],[OF_N_xr,OF_N_yr],h);

	}
	// translate(B_P_ocp) PART_OF();

	namep = [-B_P_xl, B_P_yr, 0];
	name_view(Bl1_X_name,namep);
}
Bl1_X_ALL = [
	Bl1_X_name,
	B_X_outrct,
	Bc_X_hhp,
	B_X_msphp,
	str("オシレーションカム受け子スペース:",
		join([
			B_P_xl + B_P_ocp[0]-(OF_N_xl+OCc_K_w),
			(OF_N_xl+OCc_K_w)+OF_N_xr,
			B_P_xr - (B_P_ocp[0]+OF_N_xr)
		])
	)
];

B_X_outrct3 = str("外接長方形: x",B_N_xw," y",Br_N_yw);

Bl2_X_name = "PART_B_l2";
module PART_B_l2(){
	h = boardAw;
	difference(){
		PART_B_boardL2(h);

		PART_B_holes(h);

		//  メインシャフト2時
		translate([0,-B_K_mhd+MS_K_time2[1],0])
		cut([B_P_xr-MS_N_dh,-3],[B_P_xr+_margin_,3],h);

		//  メインシャフト4時
		translate([0,-B_K_mhd+MS_K_time4[1],0])
		cut([B_P_xr-MS_N_dh,-3],[B_P_xr+_margin_,3],h);

		// オシレーションカムスペース
		translate(B_P_ocp)
		hole(OCc_K_r+OCc_K_w/2+1,h);
	}

	namep = [-B_P_xl, Br_P_yr, 0];
	name_view(Bl2_X_name,namep);
}

Bl2_X_ALL = [
	Bl2_X_name,
	B_X_outrct3,
	str(
		"左上欠け :",xytxt(
			join([B_P_xl-Br_P_xl,Br_P_xl+B_P_xr]),
			join([B_P_yl+B_P_yr,Br_P_yr-B_P_yr])
		)
	),
	Bc_X_hhp,
	str(
		"オシレーションカムスペース r:",OCc_K_r+OCc_K_w/2+1,
		B_X_ochpxy
	),
	B_X_msphp,
	str(
		"メインシャフト2時スリット: 深さ:",MS_N_dh,
		" y:",
		join([
			B_P_yl-B_K_mhd+MS_K_time2[1]-3,
			6,
			Br_P_yr-(-B_K_mhd+MS_K_time2[1]+3)
		])
	),
	str(
		"メインシャフト4時スリット: 深さ:",MS_N_dh,
		" y:",
		join([
			B_P_yl-B_K_mhd+MS_K_time4[1]-3,
			6,
			Br_P_yr-(-B_K_mhd+MS_K_time4[1]+3)
		])
	)
];


Bl3_X_name = "PART_B_l3";
module PART_B_l3(){
	h = boardAw;
	difference(){
		PART_B_boardL(h);

		PART_B_holes(h);

		// GS歯部分可動スペース
		hole(GS_K_r+2,h);

		// オシレーションカム歯車スペース
		translate(B_P_ocp) hole(B_V_ocgsr,h);
	}

	namep = [-B_P_xl, B_P_yr, 0];
	name_view(Bl3_X_name,namep);
}
Bl3_X_ALL =[
	Bl3_X_name,
	B_X_outrct,
	str(
		"GS歯部分可動スペース r:",GS_K_r+2,
		xytxt(Br_P_xl,B_P_yl)
	),
	str(
		"オシレーションカム歯車スペース r:",B_V_ocgsr,
		B_X_ochpxy
	),
	B_X_msphp
];

Bl4_X_name = "PART_B_l4";
module PART_B_l4(){
	h = boardAw;
	difference(){
		PART_B_boardL(h);

		PART_B_holes(h);

		// GS歯車スペース
		hole(GS_N_or+1,h);

	}
	namep = [-B_P_xl, B_P_yr, 0];
	name_view(Bl4_X_name,namep);
}
Bl4_X_ALL = [
	Bl4_X_name,
	B_X_outrct,
	str(
		"GS歯車スペース r:",GS_N_or+1,
		xytxt(Br_P_xl,B_P_yl)
	),
	B_X_ochp,
	B_X_msphp
];

Br1_X_name = "PART_B_r1";
module PART_B_r1(){
	h = boardAw;
	difference(){
		PART_B_boardC(h);

		PART_B_holes(h);
	}

	namep = [-B_P_xl, B_P_yr, 0];
	name_view(Br1_X_name,namep);
}
Br1_X_ALL = [
	Br1_X_name,
	B_X_outrct,
	Bc_X_hhp,
	B_X_ochp,
	B_X_msphp
];

B_X_outrct2 = str("外接長方形:",Br_N_xw,"X",Br_N_yw);
Bc_X_hhp2 = str(
	"ハンドル軸穴 r:",HS_V_r,
	xytxt(Br_P_xl,B_P_yl)
);
B_X_ochp2 = str(
	"オシレーションクランク軸穴 r:",OCgs_V_r,xytxt(Br_P_xl+B_P_ocp[0],B_P_yl+B_P_ocp[1])
);
B_X_msphp2 = str(
	"メインシャフト固定ピン穴 r:",3,
	xytxt(Br_P_xl+B_P_pinp[0],B_P_yl+B_P_pinp[1])
);

Br2_X_name = "PART_B_r2";
module PART_B_r2(){
	h = boardAw;
	difference(){
		PART_B_boardR(h);

		PART_B_holes(h);

		//  メインシャフト10時
		translate([0,-B_K_mhd+MS_K_time10[1],0])
		cut([B_P_xr-MS_N_dh,-3],[B_P_xr+_margin_,3],h);

		//  メインシャフト8時
		translate([0,-B_K_mhd+MS_K_time8[1],0])
		cut([B_P_xr-MS_N_dh,-3],[B_P_xr+_margin_,3],h);


		//
	}

	namep = [-Br_P_xl, Br_P_yr, 0];
	name_view(Br2_X_name,namep);
}
Br2_X_ALL = [
	Br2_X_name,
	B_X_outrct2,
	Bc_X_hhp2,
	B_X_ochp2,
	B_X_msphp2,
	str(
		"メインシャフト10時スリット: 深さ:",MS_N_dh,
		" y:",
		join([
			B_P_yl-B_K_mhd+MS_K_time10[1]-3,
			6,
			Br_P_yr-(-B_K_mhd+MS_K_time10[1]+3)
		])
	),
	str(
		"メインシャフト8時スリット: 深さ:",MS_N_dh,
		" y:",
		join([
			B_P_yl-B_K_mhd+MS_K_time8[1]-3,
			6,
			Br_P_yr-(-B_K_mhd+MS_K_time8[1]+3)
		])
	)
];

Br3_X_name = "PART_B_r3";
module PART_B_r3(){
	h = boardAw;
	difference(){
		PART_B_boardR(h);

		PART_B_holes(h);
	}

	namep = [-Br_P_xl, Br_P_yr, 0];
	name_view(Br3_X_name,namep);
}
Br3_X_ALL = [
	Br3_X_name,
	B_X_outrct2,
	Bc_X_hhp2,
	B_X_ochp2,
	B_X_msphp2
];

module UNIT_B(){
	translate([0,0,-boardAw/2-boardAw*3]) PART_B_l3();
	translate([0,0,-boardAw/2-boardAw*2]) PART_B_l2();
	translate([0,0,-boardAw/2-boardAw]) PART_B_l1();
	translate([0,0,-boardAw/2]) PART_B_c();
	translate([0,0,-boardAw/2+boardAw]) PART_B_r1();
	translate([0,0,-boardAw/2+boardAw*2]) PART_B_r2();
	translate([0,0,-boardAw/2+boardAw*3]) PART_B_r3();

	translate([0,0,-boardAw/2-boardAw]) PART_B_f();
	translate([0,0,-boardAw/2]) PART_B_f();
	translate([0,0,-boardAw/2+boardAw]) PART_B_f();

}

module ASSY_B(){
	translate([0,0,-boardAw/2-boardAw*4]) PART_B_l4();
	UNIT_B();
}


//////////////////////
// H
HS_X_name = "PART_HS";
module PART_HS(){
    cylinder(r=HS_V_r,h=HS_N_w,$fn=24);

	namep = [0, HS_V_r, 0];
    rotate([0,-90,0])
	name_view(HS_X_name,namep);
}
HS_X_ALL = [
    HS_X_name,
    str(" r:",HS_V_r," h:",HS_N_w)
];


module ASSY_H(){
	UNIT_GM();
	translate([0,0,HS_V_wr+HS_V_wl+boardAw*2])rotate([180,0,0]) UNIT_GS();

	// ハンドルシャフト
	translate([0,0,-HS_N_wrx])
	PART_HS();
    
    rotate([-90,0,0]) UNIT_HK();
}


HKb_V_dx = 10;
HKb_V_dy = 10;
HKb_V_dw = 6;
HKb_V_ax = 35;
HKb_V_ay = 30;

HKb_P_xl = 10;
HKb_P_xr = 3.5*HKb_V_dx+HKb_V_ax;
HKb_P_yr = HKb_V_ay+HKb_V_dy;

HKb_X_name = "PART_HK_b";
module PART_HK_b(){
    dx = HKb_V_dx;
    dy = HKb_V_dy;
    dw = HKb_V_dw;
    ax = HKb_V_ax;
    ay = HKb_V_ay;
    
    difference(){
        translate([0,0,-HKb_V_dw])
        linear_extrude(HKb_V_dw*2)
        polygon([
            [-dx,0],[dx,0],[dx+ax,ay],
            [3*dx+ax-dx/2,ay],[3*dx+ax-dx/2,ay+dy],
            [dx+ax-dx/2,ay+dy],[dx-dx/2,dy],[-dx,dy]
        ]);
        
        rotate([-90,0,0]) hole(3,dy);
        translate([2*dx+ax-dx/2,ay])
        rotate([-90,0,0]) hole(3,dy);
    }
	namep = [-dx,ay];
	name_view(HKb_X_name,namep);
}
HKb_X_ALL = [
    HKb_X_name,
    str("外形 :", 
        HKb_V_dx*2.5+HKb_V_ax, " X ",
        HKb_V_dy + HKb_V_ay, " X ", HKb_V_dw*2
    ),
    str(
        "x:",join([HKb_V_dx*2,HKb_V_ax-HKb_V_dx,HKb_V_dx*2]),
        " y:",join([HKb_V_ay,HKb_V_dy])
    ),
    str(
        "x:",join([HKb_V_dx*1.5,HKb_V_ax,HKb_V_dx]),
        " y:",join([HKb_V_dy,HKb_V_ay])
    )
];

HKs_N_r =3;

HKk_N_h =12;
HKk_N_r =18;

HKk_X_name = "PART_HK_k";
module PART_HK_k(){
    difference(){
        cylinder(r=HKk_N_r,h=HKk_N_h);
        hole(HKs_N_r,HKk_N_h);
    }
	namep = [-HKk_N_r,HKk_N_r];
	name_view(HKk_X_name,namep);
}
HKk_X_ALL = [
    HKk_X_name,
    str("外径 r:",HKk_N_r," h:",HKk_N_h),
    str("軸穴 r:",HKs_N_r)
];

HKn_N_h =6;
HKn_N_r =10;

HKn_X_name = "PART_HK_n";
module PART_HK_n(){
    difference(){
        cylinder(r=HKn_N_r,h=HKn_N_h);
        hole(HKs_N_r,HKn_N_h);
    }
	namep = [-HKn_N_r,HKn_N_r];
	name_view(HKn_X_name,namep);
}
HKn_X_ALL = [
    HKn_X_name,
    str("外径 r:",HKn_N_r," h:",HKn_N_h),
    str("軸穴 r:",HKs_N_r)
];



HKs_N_h = HKn_N_h+HKk_N_h+HKb_V_dy*1.5;

HKs_X_name = "PART_HK_s";
module PART_HK_s(){
    cylinder(r=HKs_N_r,h=HKs_N_h);
	namep = [0,HKs_N_r];
    rotate([0,-90,0])
	name_view(HKs_X_name,namep);
}
HKs_X_ALL = [
    HKs_X_name,
    str("円柱 r:",HKs_N_r," h:",HKs_N_h),
];

module UNIT_HK(){
    PART_HK_b();
    
    
    translate([2*HKb_V_dx+HKb_V_ax-HKb_V_dx/2,HKb_V_ay-HKb_V_dy/2])
    rotate([-90,0,0]) PART_HK_s();

    translate([2*HKb_V_dx+HKb_V_ax-HKb_V_dx/2,HKb_V_ay+HKb_V_dy+HKn_N_h])
    rotate([-90,0,0]) PART_HK_k();

    translate([2*HKb_V_dx+HKb_V_ax-HKb_V_dx/2,HKb_V_ay+HKb_V_dy])
    rotate([-90,0,0]) PART_HK_n();
}


//ASSY_H();
/////////////////////////////////
//// 表示
/////////////////////////////////

module VIEW_ASSY_R(thetaA=0,thetaS=0){
	ASSY_RB();

	translate([-R_V_axm-0.5,R_V_as,RB_V_th-boardBw/2-boardBw])
	rotate([0,-90,0])
	rotate([0,0,thetaA])
	ASSY_RA();

	h1 = boardBw+RB_N_w;
	//translate([0,0,h1-2]) cylinder(r=43,h=1,$fn=64); // 回転干渉視覚的チェック用

	// ストッパー
	h2 = h1+boardAw;
	translate([-RB_N_sx,-RB_N_sy,h2]) rotate([0,0,thetaS])
	PART_RS();
}

module VIEW_LINE(){
    VIEW_ASSY_R(0,20);
    translate([0,0,2+RB_V_th+boardAw+OCc_K_w]) UNIT_S();
}



////// 整合する空間配置


module VIEWX_ASSY_MS(){
    translate([B_P_xr+0.5,0,0])
	rotate([0,90,0])
	rotate([0,0,90]) ASSY_MS();
}

module VIEWX_ASSY_B(){
	translate([0,0,2*pin_rad]) rotate([90,0,0]) ASSY_B();
}

module VIEWX_ASSY_H(theta=0){
    translate([0,-boardAw-RB_N_or,0])
    rotate([-90,0,0])
    rotate([0,0,theta])
    ASSY_H();
}

module VIEWX_UNIT_GM(theta=0){
    translate([0,-boardAw-RB_N_or,0])
    rotate([-90,0,0])
    rotate([0,0,theta])
    UNIT_GM();
}

module VIEWX_UNIT_GS(theta=0){
    translate([0,-boardAw-RB_N_or,0])
    rotate([-90,0,0])
    rotate([0,0,theta])
	translate([0,0,HS_V_wr+HS_V_wl+boardAw*2])
    rotate([180,0,0]) UNIT_GS();
}


module VIEWX_ASSY_R(theta=0){
	translate([B_P_xr+0.5,0,0])
	rotate([0,90,0])
	rotate([0,0,90+theta]) VIEW_ASSY_R();
}

module VIEWX_UNIT_RB(theta=0){
	translate([B_P_xr+0.5,0,0])
	rotate([0,90,0])
	rotate([0,0,90+theta]) ASSY_RB();
}

module VIEWX_ASSY_OC(theta=0){
	translate([-B_K_hodx,0,-12+pin_rad*2])
	rotate([90,0,0])
	translate([0,0,-3/2*boardAw-boardAw*2])
    rotate([0,0,theta])
	ASSY_OC();
}

module VIEWX_PART_OC_c(theta=0){
	translate([-B_K_hodx,0,-12+pin_rad*2])
	rotate([90,0,0])
	translate([0,0,-3/2*boardAw-boardAw])
    rotate([0,0,theta])
	PART_OC_c();
}

module VIEWX_ASSY_OF(theta=0){
    dx = (180-abs(180-(theta % 360)))/180 * OCc_K_w;
    
	translate([-B_K_hodx,0,-12+pin_rad*2])
	rotate([90,0,0])
	translate([-OCc_K_w+dx,0,-3/2*boardAw])
    ASSY_OF();
}

module VIEWX_UNIT_OF(theta=0){
    dx = (180-abs(180-(theta % 360)))/180 * OCc_K_w;
    
	translate([-B_K_hodx,0,-12+pin_rad*2])
	rotate([90,0,0])
	translate([-OCc_K_w+dx,0,-3/2*boardAw])
    UNIT_OF();
}


//// 組み合わせ表示

module VIEW_SKELETON(t=0){
    tt = t*0.3;
    VIEWX_ASSY_R(tt*GM_K_num);
    VIEWX_ASSY_H(tt*RB_K_num);
    VIEWX_ASSY_OC(tt*RB_K_num*GS_K_num/OCg_K_num);
    VIEWX_ASSY_OF(tt*RB_K_num*GS_K_num/OCg_K_num);
 }

module VIEW_TOTAL(t=0){
    VIEW_SKELETON(t);
    VIEWX_ASSY_MS();
    VIEWX_ASSY_B();
}

//VIEW_TOTAL(0);
/////////////////////////////////
//// 呼び出し例（コメントアウト）
/////////////////////////////////

//PART_B_l1([100,0,0]);
//PART_B_r2([100,0,0]);
//ASSY_B();
//VIEW_GMMSRS();

//PART_RB_t1([40,0,0]);

//projection()
//PART_RB_t1();
//ASSY_RB();
//ASSY_R();
//PART_B_abstract(boardAw);
//VIEW_MSRS();
//VIEW_TOTAL(0);
//VIEW_OCOF();
//PART_S_b();






//UNIT_B();
//translate([0,0,boardAw+HS_V_wr]) rotate([180,0,0])ASSY_H();
//PART_RA_C([50,0,0]);
//ASSY_RB();
