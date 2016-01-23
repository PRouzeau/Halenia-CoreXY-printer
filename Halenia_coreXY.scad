include <PRZutility.scad>  
// pre-project for a micro sized coreXY printer with a 100x100x100 usable volume (1l)
// Yet this is an 'on hold' project but I think the CoreXY simulation is of interest. See on the Delta simulator how to manage simulation and make films
// It is not a derivative of any other project, however I had a close look at the SmartCore, which was inspirational even if Halenia details are quite different.
// Copyright Pierre ROUZEAU AKA PRZ
// Program license GPL 2.0
// documentation licence cc BY-SA and GFDL 1.2
// Machine and components design licence CERN OHL V1.2

camPos=true; //use the camera position defined below - could be unactivated for animations

//$showcore=true; // change look and camera position to show the CoreXY simulation - need to reduce the edit window width for proper view

// The camera variables shall NOT be included in a module
$vpd=camPos?($showcore)?460:1000:$vpd;   // camera distance
$vpt=camPos?($showcore)?[-37,65,210]:[30,100,137]:$vpt; //camera translation 
$vpr=camPos?($showcore)?[63,0,124]:[65,0,125]:$vpr;   // camera rotation

// animated camera movement 
$vpr = [65+yo($t)*30,0,125+$t*360]; // the camera rotate around the printer
// note that the hotend 'follow' the camera as the variable is also used in the 'view_circle function
// To see how to do animation films and understand animation function, have a look to the OpenScad Delta Simulator

function yo(val)=(val<0.5)?2*val:2-2*val;

echo_camera();

lgX = 180; // ref width (Y sliders)
lgXc = lgX-16; // width at vertical sliders (columns)
Xbelt = lgX/2-8; // half width at motor axis
lgY = 185;
lgZ = 220;
diamZReinfRod = 8;
ZScrewoffset = 5;
motorpos = 12; // Position in Y of the motor axis (vs ref Y)

// pulley diameters are what is visible, so at the outside of the belt
dpMot = 14; //motor pulley diameter 
dpCar = 14; // diam of pulleys on carriage
dpFix = 24; // diam of fixed pulleys
beltw = 6; // belt width
diffPl = (dpFix-dpCar)/2; //pulley radius difference to align belts on carriage while fixed pulleys are different diameter
XbeltFix = Xbelt-diffPl; // half width at fixed pulley axis
// yet assume that motor and carriage pulley are of same diameter

lgDiag = sqrt(pow (lgZ,2)+pow(lgY,2))+10;
floorPos = -9;
bedThk = 10;

//-- Colors -----------------------------------
clr_transp = [0.5,0.5,0.5,0.5];
color_struct= ($showcore)?clr_transp:"lawngreen";
module clst() { color(color_struct) children();}
module clrs() { color("silver") children();}
module clrg() { color("gray")  children();}

view_circle (100,0);
//simul(0,0,0);

module view_circle (dia, height) { //rotation on a given diameter at a set height
  simul (dia/2*cos($t*360),dia/2*sin($t*360),height);//simulate position (x,y,z) 
}

// print parts ----------------
*rot(90) bed_sup();

//-----------------------------

module simul(x=0,y=0,z=0) {
  Ypos = y+lgY/2+13;
  Xpos = x;
  Zpos = lgZ-25-z;
  hotend_offset = 28; // hotend offset/Zpos
  
  belt_show(Xpos, Ypos);
  tsl (0,Ypos-5, lgZ)
    clrs() 
      dmirrorz() { // X axis
        cylx (-6,lgX-10, 0,10,12);
      }
  color(($showcore)?clr_transp:"silver")
    cubez (25,15,25, Xpos,Ypos-30,lgZ-10); // cooling block (finned)    
  dmirrorx()  {
    clst() {
       tsl (lgX/2,Ypos-5,lgZ) mirrory() 
         difference() {
           union() {
             hull() {
               cylz (-8,14, -8.5,12,0);
               cubez (2,8,10,  -15,12,-10/2);
               cubez (2,8,14,  -6,12,-14/2);
             }  
             hull() {
               cylz  (-8,15,   8.5,-12,0);
               cubez (1,8,15,  0,-12,-15/2);
             }
             hull() { // carriages
               cubez (2,32,12, 8,0,-6); 
               cyly (-18,32,   0,0,0);
             } 
             cubez (12,12,40, -10.01,-10.01,-20);  
             cubez (12,12,18, -6,-10,-18/2);  
             hull() {
               cubez (12,12,24, -10,-10,-12);  
               cubez (12,12,10, -10,-5,-5);  
             }  
             cubez (16,32,10, -8,0,-5);  
           }  //:: then whats removed
           cylz (-3,66, -9,12,0); // pinch screw
           cylz (-3,66, 9,-12,0);
           dmirrorz()  // X axis
             cyly (-3,66, 3,-15,17);
          * cubez (50, 4, 10, 0,0,6);
         }
       bed_sup(Zpos);
     } 
     clrs() duplz(-55)  //LM8UU bearings for bed
       dmirrorx()
         cylz (-15,24,    lgXc/2 ,0,Zpos-bedThk-5);  
     
     clrs() // bearing LM6LUU on carriage
       cyly (-12,35, lgX/2,Ypos-5,lgZ);
  }  // end mirror
  clrg() tsl (0,0,Zpos-42)
    rot(0,17)
      cylx (-4,lgX+20, 0,-10);
  clst() tsl (Xpos,Ypos-5,lgZ) { // hotend support
    dmirrorz()  hull() {
      cylx (-18,32,    0,10,12);
      cubex (32, 2,12, -16,18.02,12);
    }  
    hull() {
      cubey (25,12,38, 0,-15); 
      cubey (16,18,38, 0,1); 
    }  
  }  
  clrs() { //hotend details
    tsl(Xpos,Ypos-5,lgZ)
      dmirrorz()  
        dmirrorx() 
          cylx (12,19,    2,10,12); // bearing LM6UU, pairs , on hotend support
    
    cconez (4,1, -1,-30, Xpos,Ypos-hotend_offset,lgZ-9-14); // hotend
    cubez (15,20,7, Xpos,Ypos-hotend_offset-6,lgZ-20); // heating block
  } 
  
  struct(Xpos, Ypos, Zpos);  
//--- parts which will not view in transparency (on purpose)
  
  
  color ("white") 
    cylz (4,50, Xpos,Ypos-hotend_offset,lgZ); // bowden tube
  tsl (Xpos, Ypos-38, lgZ+3)
    rot (90) build_fan(25,10); // hotend fan
     
  clst() {
    cylz (12,12, 0,ZScrewoffset,Zpos);
    hull() 
      dmirrorx() 
        cylz (12,4, 12,ZScrewoffset,Zpos);
  }  
  color ("burlywood")  // bed
    difference() {
      hull() {
        cubez (lgX+10,30,-bedThk, 0,0,Zpos);  
        cubez (120,120,  -bedThk, 0,lgY/2-15,Zpos); 
      }
      dmirrorx() 
        cylz (-16,66, lgX/2-8,0,Zpos); 
    }  
  color ("white")cubez (120,120,1, 0,lgY/2-15,Zpos);     
    
  
}

module bed_sup(Zpos=0) {
  htsup = 65; // inter-axis diff
  //render() 
  difference() { // bed support
    union() {
      duplz(-htsup+10) {
        tsl (lgXc/2) 
          hull() {
            cylz (24,-10,   0,0,Zpos-bedThk);
            dmirrorx()
              cylz (10,-10,  4,7,Zpos-bedThk);
            cubez (18,2,-10, 0,-12,Zpos-bedThk);
          }  
      }  
      cubez (18,2,-htsup, lgXc/2,-12,Zpos-bedThk);
      tsl (lgXc/2) 
        dmirrorx() 
          hull() {
            cubez (2,1,-htsup, 8,-10.6,Zpos-bedThk);
            cubez (4,1,-htsup, 9.7,0,Zpos-bedThk);
          }  
    } // ::: then whats removed :::
    hull() {
      cylz (-15,199, lgXc/2,0,Zpos);
      tsl (lgXc/2) 
        dmirrorx()
          cylz (-1,199, 4,7,Zpos);
    }  
  }  
  
} 

module belt_show(Xpos, Ypos) {
  belthR= lgZ+12;
  belthL= lgZ-12;
  beltH = 12;
  beltL = -12;
  offY=-11; // offset carriage pulley/carriage
  clrBH = ($showcore)?"blue":"black"; 
  clrBL = ($showcore)?"red":"black"; 

  module beltd (dpuls, dpule, angle, x,y, dx,dy, dz) { // display belt
    hull() {
      tsl (x,y,lgZ+dz) rotz (angle) cylz (-1.5, beltw, dpuls/2-0.75); 
      tsl (x+dx,y+dy,lgZ+dz) rotz (angle) cylz (-1.5, beltw, dpule/2-0.75);   
    }
  }
  module pulley (diam, x,y, dz) {
    cylz (-diam,beltw, x,y, lgZ+dz);
  }
  color (clrBH) { // belts
    pulley (dpMot, Xbelt,motorpos, beltH); // motor pulley
    beltd (dpMot,dpFix, 0,   Xbelt, motorpos, -diffPl,lgY-motorpos, beltH);
    beltd (dpMot,dpCar, 180, Xbelt, motorpos, 0,Ypos-motorpos+offY, beltH);
    pulley (dpCar, Xbelt-12,Ypos+offY, beltH); // carriage pulley
    beltd  (dpCar, dpCar, 90,  Xbelt-12,Ypos+offY, -(Xbelt-Xpos-12),0, beltH);
    beltd (dpCar,dpCar, 270, -Xbelt,  Ypos+offY,-(-Xbelt-Xpos),0,beltH);
    beltd (dpFix,dpCar, 180, -XbeltFix,  lgY, -diffPl,-(lgY-Ypos-offY), beltH);
    pulley (dpCar, -Xbelt,Ypos+offY, beltH); // carriage pulley
    dmirrorx() 
      pulley (dpFix, XbeltFix,lgY, beltH);
    beltd (dpFix, dpFix, 90, -XbeltFix,lgY,  XbeltFix*2,0, beltH);
  }
  color (clrBL) {  
    beltd (dpFix,dpCar, 0,   XbeltFix,  lgY, diffPl,-(lgY-Ypos-offY), beltL);
    pulley (dpCar, Xbelt,Ypos+offY, beltL);
    beltd  (dpCar, dpCar, 270, Xbelt, Ypos+offY, -(Xbelt-Xpos),0, beltL);
    pulley (dpMot, -Xbelt,motorpos, beltL);
    beltd (dpMot,dpFix, 180, -Xbelt, motorpos, diffPl,lgY-motorpos, beltL);
    beltd (dpMot,dpCar,   0, -Xbelt, motorpos,  0,Ypos-motorpos+offY, beltL);
    pulley (dpCar, -Xbelt+12,Ypos+offY, beltL);
    beltd (dpCar,dpCar, 90,  -Xbelt+12, Ypos+offY,-(-Xbelt-Xpos+12),0,beltL);
    dmirrorx() 
      pulley (dpFix, XbeltFix,lgY, beltL);
    beltd (dpFix, dpFix, 90, -XbeltFix,lgY,  XbeltFix*2,0, beltL);
  } 
  clrg() { //Carriage pulley shafts
    cylz (-5,14, Xbelt-12,Ypos+offY, lgZ+beltH); 
    cylz (-5,14, -Xbelt,Ypos+offY, lgZ+beltH);
    cylz (-5,14, Xbelt,Ypos+offY, lgZ+beltL);
    cylz (-5,14, -Xbelt+12,Ypos+offY, lgZ+beltL);
  }
}


module struct(Xpos, Ypos, Zpos) {
  color ("burlywood")  cubez (lgX+20,lgY+35,-10, 0,lgY/2,floorPos); // floor
  dmirrorx() { // after plastic parts to not be seen by transparency
    clrg() 
      tsl (0,-15, Zpos-75)
         rot (-52)  
            cylz(5,110, lgX/2-20);  
   clrs() {
      cylz (8,lgZ+15, lgXc/2,0,floorPos); // Z axis
      cyly (6,lgY+10, lgX/2,-10,lgZ); // Y axis
    }  
  }  
  clrg() {
    cylx (-5,lgX+30, 0,-8,lgZ+1);   // X reinforcment top
    cylx (-5,lgX+20, 0,lgY+8,lgZ+2);   // X reinforcment  top end
    cylx (-5,lgX+15, 0,8); // X reinf bottom
  }

  tsl (Xbelt,motorpos,lgZ+20.01) // motor 1
      rot(180) nema17(32);   
  tsl (-Xbelt,motorpos,lgZ+6.01) // motor 2
      rot(180) nema17(32);   

  dmirrorx() {
   
    clrg() {
      *tsl (0,0,3) rot (41) 
        cyly (5,lgDiag+20, lgX/2+5,-22); // diagonals
      // diagonals abandoned, simpler to use larger rods (M8 instead of M5)
      cylz (diamZReinfRod,lgZ+30,  XbeltFix,lgY,-10); // Z reinf
    }
    clst() {
      difference() {
        hull() {
          //cubez (15,15,20, lgX/2,0,     floorPos); // foot
          cylz (15,20,    lgXc/2,0,     floorPos);
          cylx (-11,14, lgXc/2,8); // X reinf holder  
         * tsl (0,0,3) rot (41) 
            cyly (11,20, lgXc/2+5,-8); // diagonals holder
        }  
       * tsl (0,0,3) rot (41) {
          cyly (-5,99, lgXc/2+5,-8); // diagonals holes
          cyly (9,9, lgXc/2+5,-17.5); // diagonals holes
        } 
       * cubez (30,30,-20, lgXc/2,0,-9); //cut below diagonal cylinder
        cubez (1.5,20,50, lgXc/2,7,-1); // cut split
      }  
      hull() {  
        cuben (28,20,15, lgX/2-7,lgY-2, lgZ, true); // top end
        cylx (-11,28, lgX/2-7,lgY+8, lgZ+2);
      }  
     * cubez (15,15,20, XbeltFix,lgY, floorPos); // foot end
    }
  } // end dmirrorx()
  clst() 
    difference() { 
    dmirrorx() 
      difference () {
        union() {
          hull() {
            cubez (2 ,32,2, lgX/2+8,motorpos,   lgZ+15); // top - motor support
            cyly (-11,36,  lgX/2, motorpos,  lgZ);
          }
          cubez (8,34,10, lgX/2+4,motorpos,   lgZ-3.99); // top - motor support
          hull() {
            cylz (15,22,    lgXc/2,0,   lgZ-17);
            cylz (-6,24,  lgXc/2+7,0, lgZ-5);
          }  
          tsl (Xbelt,motorpos,lgZ-4) {
            dmirrory () 
              cylz (8, 24, 15.5,15.5); 
            cylz (8, 24, -15.5,-15.5); 
            cubez (4,30,24, 15.5,0);
            cubez (30,4,24, 0,-15.5);
          }  
          hull() {
            cylx (10,40, Xbelt-20, -8, lgZ+1);
            cylx (2,38, Xbelt-19, -5, lgZ+15);
            cylx (2,38, Xbelt-20, -5, lgZ-3);
          }  
          hull() {
            cylz (-6,24,  lgXc/2+7,0, lgZ-5);
            cyly (-5,36,  lgXc/2+11,motorpos, lgZ-2);
          }
        } // then whats removed 
        cylz (-6,25, Xbelt,motorpos, lgZ-4); 
        
        cylz (-8,25,  lgXc/2,0, lgZ-4);
        tsl (Xbelt,motorpos,lgZ-12) 
          dmirrorx() dmirrory() 
            cylz (-3.2,99, 15.5,15.5);
      }
      cubez (50,50,50, -Xbelt, motorpos, lgZ+5.99); // cut the low motor support
      cconez (15, 2, 12,6, -Xbelt,motorpos, lgZ-14);
    }
  
  color("green") // control board (Duet 100x105)
    cubez (100,105,2, 18,150,2);
  color("black")
    cubez (165,38,65, 0,70,-10); // power supply

    
  tsl (0,ZScrewoffset,38) {
   rot(0,0) nema17(34); // Z motor
    clrg() cylz (6,145, 0,0,25);
  }
  if (!$showcore) {
    tsl (-40,172,150) rot (12) set_extru();
    clrg() cylz (5, 240,  -45,190,-15);  // extruder rod support
    clst() cubez (12,16,14, -45,192,lgZ-7);
    tsl (-150,40, lgZ+42) //pen draft  for scale
      rot(90, 0,70) pen();
  }  
}

module set_extru() { // display extruder
plthk=2.5;   //extruder base plate thickness
diagear = 9;  // MK8 gear drive room in the lever (diam 8, filament diameter )
BBposx = 0;  
BBpos = -6.5-diagear/2-0.5-0.3;  // Position of the ball bearing / motor axis  
dec= -4.5;  // filament axis dist to motor axis
angle = -10;  // for rod attached extruder
tens_angle = -87; // bolt tensioner angle (relative to lever)  
tens_h = 22;  // one coordinate of tensioner rotation axis position
wdist= -11.5;  // distance between filament axis and motor plane
  // extruders are rotated and they are designed 'flat on table' 
angle=-10;  
  rotz (-90)
     rot (0,90,90) {
        clst()
          mirrorz() import("Dex_base_rod.stl");
      // accessories 
          color ("grey")  rot(180) nema17(52); 
          color ("silver") cylz (8,-12, 0,0,-5); // ??
          rotz (angle) {
            color ("yellow") // filament
              cylx (1.75,100,   -10,dec,wdist);
            color ("white")
              cylx (4,-30, -10,dec,wdist);
            color ("orange") 
              tsl (0,0,wdist)
                rot (90) import("Dex_lever.stl");
            color ("grey") {
              cylz (-13,5, BBposx,BBpos,wdist); // bearing
              cylz (-4,15, BBposx,BBpos,wdist); // bearing shaft
              tsl (tens_h, 5, wdist)  // tensioner bolt
                rotz(tens_angle) 
                  cylx (4,-45,  2); 
            }
            color ("blue") 
            tsl (tens_h, 5, wdist)  // tensioner arti
              rotz(tens_angle)
                rot (-90) import("Dex_tensioner.stl");
          }  
      }
}

//-- Miscellaneous utilities--------------------------------------------------

module nema17(lg=40) { // NEMA 17 stepper motor. - replace by STL ??
  clrg()
    difference() {
      union() {
        intersection() {
          cubez(42.2, 42.2, lg,0,0,-lg);
          cylz(50.1,lg+1,0,0,-lg-0.5,60);
        }
        cylz(22,2,0,0,0,32);
        cylz(5,24,0,0,0,24);
      }
      for (a = [0:90:359]) 
        rotz(a) cylz(-3,10, 15.5,15.5);
    }
}

module build_fan(size=40, thk=6) { //~ok for 25,30,40,60,80,120. Not ok for 92
  holesp = size==120?52.5:size==80?35.75:size==60?25:0.4*size;
  color ("black") {
    difference() {
      hull() 
        dmirrorx() dmirrory() cylz (2,thk,size/2-1,size/2-1);
      cylz (-size *0.95,55);
      dmirrorx() dmirrory() cylz (-(size*0.03+2),55,holesp,holesp);
    }
    cylz (12+size/8, thk-1,0,0,0.5);
  }  
}  

module pen() { // for scale referencing
  color ("gold")cconez (1,6, 10,0.5);
  color ("blue") {
    cylz (3.5, 130, 0,0,10);
   cconez (8,3, 0.6,0.4, 0,0,145, 8);
  }  
  color ([0.5,0.5,0.5,0.5]) cconez (8,6, -10,-125, 0,0,20, 8);
}

module echo_camera () { // Echo camera variables on console
  echo ("Camera distance: ",$vpd); 
  echo ("Camera translation vector: ",$vpt);  
  echo ("Camera rotation vector: ",$vpr);
}

