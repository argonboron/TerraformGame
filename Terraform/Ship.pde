public class Ship { //<>//
  PVector acceleration, velocity, position, gravity, drag, origin, force, blast, thrust;
  PShape ship;
  float mass, orientation, orbitAngle;
  boolean pause, inOrbit, clockwise;
  ArrayList<PVector> lineCoords = new ArrayList<PVector>();
  Planet orbitPlanet;

  void display() {  
    if (!pause && !inOrbit) {
      integrate();
      orbitAngle = 0;
    }
    PVector lineCoord = position.copy();
    if (lineCoords.size()>200) {
      lineCoords.remove(0);
    }
    if (!pause && ((int) random(0, 2)==1)) {
      lineCoords.add(lineCoord);
    }
    push();
    rectMode(CENTER);
    translate(position.x, position.y);
    rotate(orientation);
    fill(260, 100, 40);
    square(0, 0, 15);
    pop();
    fill(0);
  }

  public void pause(boolean val) {
    pause = val;
  }

  public void orbit(float radius, PVector planetPos) {
    if (!pause) {
      if (position.y > planetPos.y) {
        clockwise = (velocity.x < 0);
      } else {
        clockwise = (velocity.x > 0);
      }
      float angle = atan2(planetPos.x - position.x, planetPos.y - position.y);
      position = new PVector(planetPos.x+cos(angle)*radius, planetPos.y+sin(angle)*radius);
      orbitAngle = angle;
    }
  }

  public void continueOrbit(float radius, PVector planetPos) {
    if (!pause) {
      position = new PVector(planetPos.x+cos(orbitAngle)*radius, planetPos.y+sin(orbitAngle)*radius);
      orientation = orbitAngle;
      if (clockwise) {
        orbitAngle += PI/160;
      } else {
        orbitAngle -= PI/160;
      }
    }
  }

  void applyGravity(Planet planet) {
    PVector distanceVec = planet.position.copy().sub(position);
    float G = 100;
    float gravForce = (G * planet.mass * mass) / (pow(distanceVec.mag(), 2));
    gravity.add(distanceVec.mult(gravForce));
  }

  //Setter for velocity
  void setVelocity(PVector newVel) {
    velocity = newVel;
  }

  void turnShip(float heading) {
    orientation = heading;
  }


  ////Integrate function
  void integrate() {
    velocity.add(acceleration);
    velocity.normalize();
    position.add(velocity);
    orientation = velocity.heading();
    force.add(gravity);
    gravity = new PVector();
    acceleration = force.copy().div(mass);
  }


  void launch(PVector dragVec) {
    PVector thrust = position.copy().sub(dragVec);
    force = thrust;
    gravity = new PVector();
  }

  ////Getter for Position
  PVector getPosition() {
    return position;
  }

  public Ship() {
    this.position = new PVector(displayHeight/2, displayHeight/2+300);
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.thrust = new PVector();
    this.force = new PVector();
    gravity = new PVector();
    mass = 10;
  }
}
