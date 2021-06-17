$fn=100;


// microphone properties
mic_l=163; // total length of microphone
mic_d=24;  // the diameter of the microphone
capsule_depth=10; // how far in from the end of the 
mic_color= "#5F5F5F";
microphone_visible = false;

// ORTF spec
capsul_distance=170; // the distance between capsules
mic_angle=110;  // angle (in degrees)

// plastic printing
thick=3;    // thickness of plastic parts.
plate_thick=8;
cradle_length=90;
cradle_offset=25; // distance from tip of microphone to end of cradle start

ph=30; // height of the clip on z axis
module mic_ring() {
    difference() {
        color(mic_color)
        cylinder (h=2.2, r=mic_d/2+0.01, center=true);   
    
        color(mic_color)
        cylinder (h=2.2+0.01, r=mic_d/2-1, center=true);   
        
        rotate([0,0,-60])translate([mic_d/4,0,0])
        color(mic_color)
        cube([mic_d/2,3.5,2.2+0.01],center=true);
        
        rotate([0,0,60])translate([mic_d/4,0,0])
        color(mic_color)
        cube([mic_d/2,3.5,2.2+0.01],center=true);
        
        rotate([0,0,180])translate([mic_d/4,0,0])
        color(mic_color)
        cube([mic_d/2,3.5,2.2+0.01],center=true);
    }    
}

module mic_body() {
    
    color(mic_color)cylinder(h=mic_l-6, r = mic_d/2, center=true);
    
    translate([0,0,mic_l/2-1.5])
    color(mic_color)
    cylinder(h=3, r1 = mic_d/2, r2 = mic_d/2-3, center=true);
    
    translate([0,0,-mic_l/2+1.5])
    color(mic_color)
    cylinder(h=3, r2 = mic_d/2, r1 = mic_d/2-3, center=true);
}

module microphone() {
    difference() {
    mic_body();
        
    translate([0,0,mic_l/2 -13.8])mic_ring();
    translate([0,0,mic_l/2 -13.8 - 4])mic_ring();
    translate([0,0,mic_l/2 -13.8 - 8])mic_ring();
    }    
}

module mic_cradle() {
    translate([0,0,mic_l/2-cradle_length/2 - cradle_offset])
    rotate([0,0,90])
    {
    difference() {
        cylinder(h=cradle_length,r=mic_d/2+thick, center=true);

        cylinder(h=cradle_length+0.01,r=mic_d/2, center=true);

        translate([0,0.5*mic_d,0])
        cube([mic_d+2*thick,mic_d/2, cradle_length+0.01], center=true);
    }
    }
}

module mic_cradle_footprint() {
    translate([0,0,mic_l/2-cradle_length/2+25 - cradle_offset])
    rotate([0,0,90]){

        cylinder(h=cradle_length,r=mic_d/2+thick, center=true);
    
    translate([15,18.5,8])cube([16,25,60],center=true);
    }
}

module bridge() {
  
  pl=170;
    
  difference() {
    union() {
        translate([ph/2,0,0])cube([ph,pl,plate_thick], center=true); 
    }
   
     
    translate([0,capsul_distance/2,0]) {
            rotate([0,0,-90-mic_angle/2])
            translate([0,mic_l/2-capsule_depth,-mic_d/2])
            rotate([90,0,0]){
                union() {
                    mic_cradle_footprint();
                }
            }
 
            }
   translate([0,-capsul_distance/2,0]) {
       
            rotate([0,0,90+mic_angle/2])
            translate([0,-mic_l/2+capsule_depth,mic_d/2])
            rotate([-90,0,0]) {
                mic_cradle_footprint();
            }  
        }

  // mounting hole
  translate([ph/2,0,0])cylinder(r=2.5, h=10, center=true);
  }
  
  rm=14.87;
  
  difference() {
  translate([ph/2,0,7+plate_thick/2])cylinder(r=24
      /2, h=14, center=true);
  
  
  translate([ph/2,0,7+plate_thick/2])cylinder(r=rm/2, h=14+0.01, center=true);
  }
}

module clip(){
    rotate([0,-90,0]) {
    difference() {
        union() {
            translate([0,capsul_distance/2,0])
            rotate([0,0,-90-mic_angle/2])
            translate([0,mic_l/2-capsule_depth-23.5,-mic_d/2])
            rotate([90,0,0]){
                mic_cradle();
            }

            
            translate([0,-capsul_distance/2,0])
            rotate([0,0,90+mic_angle/2])
            translate([0,-mic_l/2+capsule_depth+23.5,mic_d/2])
            rotate([-90,0,0]) {
                mic_cradle();
            }
           
            bridge(); 
        }

    // trim edge off bottom
    translate([-9,0,0])cube([18,195,60], center=true);
        
    // trim edge off top
    bt=25;
    translate([bt/2+ph,0,0])cube([bt,140,55], center=true);
    
    // trim off bottom points of clip 
    translate([0,capsul_distance/2,0])
    translate([0,6,0])cube([20,12,60], center=true);    

    translate([0,-capsul_distance/2,0])
    translate([0,-6,0])cube([20,12,60], center=true);    

    }

}
    
}

module microphones(){
    rotate([0,-90,0])
        union() {
            translate([0,capsul_distance/2,0])
            rotate([0,0,-90-mic_angle/2])
            translate([0,mic_l/2-capsule_depth,-mic_d/2])
            rotate([90,0,0]){
                if (microphone_visible)
                    microphone();
            }

            translate([0,-capsul_distance/2,0])
            rotate([0,0,90+mic_angle/2])
            translate([0,-mic_l/2+capsule_depth,mic_d/2])
            rotate([-90,0,0]) {
                if (microphone_visible)
                    microphone();
            }
        }
}



//mic_cradle();
//bridge();
clip();
microphones();

