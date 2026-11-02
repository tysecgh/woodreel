module beam(p1, p2, w=1) {
    v = p2 - p1;
    L = norm(v); // 2点間の距離
    
    // 水平方向（XY平面）の角度と、垂直方向（Z軸からの傾き）を計算
    xy_dist = norm([v.x,v.y]);
    rot_y = atan2(xy_dist, v.z); 
    rot_z = atan2(v.y, v.x);     

    translate(p1)
    rotate([0, 0, rot_z])
    rotate([0, rot_y, 0])
    // Z軸方向に長さ L の直方体を伸ばす（底面の中央が p1 に一致する）
    translate([-w/2,-w/2,0])cube([w, w, L]);
}



module line(pSq){
    color("red"){
        for( i=[0:1:len(pSq)-2] ){
            beam(pSq[i], pSq[i+1],0.3);
        }
    }
}
