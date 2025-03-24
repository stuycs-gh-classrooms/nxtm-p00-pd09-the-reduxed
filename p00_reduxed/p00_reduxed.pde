//declare an instance of class Orb
Orb[] Orbs;
int OrbNumber = 10;

//other variables
boolean moving;
PVector gravity;
PVector previousVel = new PVector(0, 0);

//constants
float gravConstant = 0.01;
float windConstant = 0;
float dragCoefficient = 0.01;

//force toggles
boolean doWallBouncing;
boolean doUniversalGravity;
boolean doUniversalDrag;
boolean doInterBallGravity;
boolean doInterBallSpringForce;

void setup() {
  size(1200, 800);
  textSize(10);
  textAlign(LEFT, TOP);
  doUniversalGravity = true;
  doUniversalDrag = true;
  doWallBouncing = true;
  moving = false;
  Orbs = new Orb[OrbNumber];
  for (int i = 0; i < Orbs.length-1; i++) {
    Orbs[i+1] = new Orb(100+1000*i/(OrbNumber-1), 50, int(random(5, 30)));
  }
  Orbs[0] = new FixedOrb(200, 400, 100);
  Orbs[0].c = color(0,100,255);
  gravity = new PVector(0, 0.5);
  PVector push = new PVector(2, -2);
  for (int i = 0; i < Orbs.length; i++) {
    Orbs[i].applyForce(gravity);
  }
  //b0.applyForce(push);
}//setup


void draw() {
  background(255);
  for (int i = 0; i < Orbs.length; i++) {
    Orbs[i].display();
  }
  if (doUniversalGravity) {
    text("(G)Univ. Gravity: " + gravity.y, 0, 0);
  } else {
    text("(G)Univ. Gravity: Off", 0, 0);
  }
  if (doUniversalDrag) {
    text("(D)Univ. Drag: " + dragCoefficient, 0, 15);
  } else {
    text("(D)Univ. Drag: Off", 0, 15);
  }
  if (doInterBallGravity) {
    text("(H)Inter-Ball Attraction: " + gravConstant, 0, 30);
  } else {
    text("(H)Inter-Ball Attraction: Off", 0, 30);
  }
  if (moving) {
    for (int i = 0; i < Orbs.length; i++) {
      if (doUniversalGravity) {
        Orbs[i].applyForce(gravity);
      }
      if (doUniversalDrag) {
        if (Orbs[i].center.y>200) {
          Orbs[i].applyForce(Orbs[i].getDragForce(dragCoefficient));
        }
      }
      if (doInterBallGravity) {
        PVector sumGravForce = new PVector(0,0);
        for (int j = 0; j < Orbs.length; j++) {
          if(i != j) {
            sumGravForce.x += Orbs[i].getGravForce(gravConstant, Orbs[j]).x;
            sumGravForce.y += Orbs[i].getGravForce(gravConstant, Orbs[j]).y;
          }
        }
        Orbs[i].applyForce(sumGravForce);
      }
      Orbs[i].move(doWallBouncing);
    }
  }//moving
}//draw


void keyPressed() {
  if (key == ' ') {
    moving = !moving;
  }
  if (key == 'r') {
    for (int i = 0; i < Orbs.length-1; i++) {
      Orbs[i+1] = new Orb(100+1000*i/(OrbNumber-1), 50, int(random(5, 30)));
    }
    Orbs[0] = new FixedOrb(200, 400, 100);
    Orbs[0].c = color(0,100,255);
  }
  if (key == 'g') {
    doUniversalGravity = !doUniversalGravity;
  }
  if (key == 'd') {
    doUniversalDrag = !doUniversalDrag;
  }
  if (key == 'h') {
    doInterBallGravity = !doInterBallGravity;
  }
  if (key == 'b') {
    doWallBouncing = !doWallBouncing;
  }
}//keyPressed
