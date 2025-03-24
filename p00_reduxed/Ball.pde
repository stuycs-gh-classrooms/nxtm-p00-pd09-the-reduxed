class Orb {
  //instance variables aka attributes
  PVector center;
  PVector velocity;
  PVector acceleration;
  float bsize;
  float mass;
  color c;

  //default constructor
  Orb(float x, float y, int s) {
    bsize = s;
    mass = s;
    center = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
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
    acceleration.add(force);
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
  
  PVector getMysteriousForce(Orb other) {
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

  void setColor(color newC) {
    c = newC;
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
  
  FixedOrb(int x, int y, int s) {
    super(x, y, s);
  }

  void move() {
    //nothing lol
  }
}
