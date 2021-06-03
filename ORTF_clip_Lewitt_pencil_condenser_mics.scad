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
plate_thick=5;
cradle_length=50;
cradle_offset=25; // distance from tip of microphone to end of cradle start
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
    difference() {
        cylinder(h=cradle_length,r=mic_d/2+thick, center=true);

        cylinder(h=cradle_length+0.01,r=mic_d/2, center=true);

        translate([0,0.5*mic_d,0])
        cube([mic_d+2*thick,mic_d/2, cradle_length+0.01], center=true);

    }


}

module clip() {
    translate([0,capsul_distance/2,0])
    rotate([0,0,-90-mic_angle/2])
    translate([0,mic_l/2-capsule_depth,-mic_d/2])
    rotate([90,0,0]){
        if (microphone_visible)
            microphone();
        mic_cradle();
    }

    translate([0,-capsul_distance/2,0])
    rotate([0,0,90+mic_angle/2])
    translate([0,-mic_l/2+capsule_depth,mic_d/2])
    rotate([-90,0,0]) {
        if (microphone_visible)
            microphone();
        mic_cradle();
    }
}

//mic_cradle();
union() {
    clip();
    polyhedron(points=[
        [29,-44,-plate_thick/2],  //0
        [29, 29,-plate_thick/2],  //1
        [6, 62,-plate_thick/2],   //2
        [10,-73,-plate_thick/2],   //3

        [29,-29,plate_thick/2],   //4
        [29, 44,plate_thick/2],   //5
        [10, 73,plate_thick/2],    //6
        [5,-63,plate_thick/2],    //7

        ],
        faces=[
        [0,1,2,3],
        [7,6,5,4],
        [0,4,5,1],
        [7,4,0,3],
        [3,2,6,7],
        [5,6,2,1]
        ]
    );
}