module scale(p){
    linear_extrude(0.2){
        translate(p)
        square([100,0.1]);
        
        for( i=[0:1:100] ){
            translate(p+[i,0,0])
            square([0.1,1]);
        }
        for( i=[0:10:100] ){
            translate(p+[i,0,0])
            square([0.1,3]);
        }
        for( i=[5:10:95] ){
            translate(p+[i,0,0])
            square([0.1,2]);
        }
    }
}