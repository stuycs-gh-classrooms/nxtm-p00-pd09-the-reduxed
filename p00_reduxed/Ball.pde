class Orb {
  //instance variables aka attributes
  PVector center;
  PVector velocity;
  PVector acceleration;
  float bsize;
  float mass;
  color c;
  
  //default constructor
  Orb() {
    bsize = random(10, 100);
    float x = random(bsize/2, width-bsize/2);
    float y = random(bsize/2, height-bsize/2);
    center = new PVector(x, y);
    mass = random(10, 100);
    velocity = new PVector();
    acceleration = new PVector();
    setColor();
  }
  
  Orb(float x, float y, float s) {
    bsize = s;
    mass = s;
    center = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    setColor();
  }

  //movement behavior
  void move(boolean b) {
    if (b) {
      xBounce();
      yBounce();
    }

    velocity.add(acceleration);
    center.add(velocity);
    acceleration.mult(0);
  }//move

  void applyForce(PVector force) {
    PVector scaleForce = force.copy();
    scaleForce.div(mass);
    acceleration.add(scaleForce);
  }

  PVector getDragForce(float coeff) {
    PVector NVelocity = velocity.copy();
    NVelocity.normalize();
    PVector returner = new PVector(-0.5*coeff*(velocity.mag()*velocity.mag())*NVelocity.x, -0.5*coeff*(velocity.mag()*velocity.mag())*NVelocity.y);
    return returner;
  }

  PVector getGravForce(float G, Orb other) {
    float strength = G*mass*other.mass;
    float r = max(center.dist(other.center), 0.01);
    strength = strength/pow(r, 2);
    PVector force = other.center.copy();
    force.sub(center);
    force.mult(strength);
    return force;
  }
  
  PVector getSpring(Orb other, int springLength, float springK) {
    if(other != null) {
      PVector direction = PVector.sub(other.center, this.center);
      direction.normalize();
  
      float displacement = this.center.dist(other.center) - springLength;
      float mag = springK * displacement;
      direction.mult(mag);
  
      return direction;
    } else {
      PVector direction = new PVector(0,0);
      return direction;
    }
  }//getSpring
  
  PVector getElectroStaticForce(Orb other) {
    PVector mysteriousForce;
    if (mass != other.mass) {
      float magConstant = (velocity.mag()+other.velocity.mag())/(mass-other.mass);
      mysteriousForce = new PVector(center.x-other.center.x, center.y-other.center.y);
      mysteriousForce.mult(magConstant);
    } else {
      mysteriousForce = new PVector(0,0);
    }
    return mysteriousForce;
  }

  boolean yBounce() {
    if (center.y > height - bsize/2) {
      center.y = height - bsize/2;
      velocity.y *= -1;
      return true;
    }//bottom bounce
    else if (center.y < bsize/2) {
      velocity.y*= -1;
      center.y = bsize/2;
      return true;
    }
    return false;
  }//yBounce

  boolean xBounce() {
    if (center.x > width - bsize/2) {
      center.x = width - bsize/2;
      velocity.x *= -1;
      return true;
    } else if (center.x < bsize/2) {
      center.x = bsize/2;
      velocity.x *= -1;
      return true;
    }
    return false;
  }//xbounce

  boolean collisionCheck(Orb other) {
    return ( this.center.dist(other.center)
      <= (this.bsize/2 + other.bsize/2) );
  }//collisionCheck

  void setColor() {
    c = color(random(220), random(220), random(220));
  }//setColor

  //visual behavior
  void display() {
    fill(c);
    circle(center.x, center.y, bsize);
  }//display
}//Orb

class FixedOrb extends Orb {
  PVector center;
  PVector velocity;
  PVector acceleration;
  float bsize;
  float mass;
  color c;
  
  FixedOrb(float x, float y, float s) {
    super(x, y, s);
  }

  void move() {
    //nothing lol
  }
}

class OrbNode extends Orb {
  //attributes aka instance variables
  OrbNode next;
  OrbNode previous;
  
  void display(int springLength) {
    if(next != null) {
      if (springLength < dist(center.x, center.y, next.center.x, next.center.y)){
        stroke(255,0,0);
      } else {
        stroke(0,255,0);
    }
      line(center.x, center.y, next.center.x, next.center.y);
    }
    if(previous != null) {
      if (springLength < dist(center.x, center.y, previous.center.x, previous.center.y)){
        stroke(255,0,0);
      } else {
        stroke(0,255,0);
      }
      line(center.x + 2, center.y + 2, previous.center.x + 2, previous.center.y + 2);
    }
  }
}//OrbNode
