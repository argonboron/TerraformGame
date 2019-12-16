public class Ship { //<>//
  PVector acceleration, velocity, position, gravity, drag, origin, force, blast, thrust;
  PShape ship;
  float mass, orientation, orbitAngle, fuel;
  boolean pause, inOrbit, clockwise;
  ArrayList<PVector> lineCoords = new ArrayList<PVector>();
  Planet orbitPlanet;
  int DisplayHeight = 1000;

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
    
    //Fuel
    stroke(255);
    rect(DisplayHeight-50, DisplayHeight-120, 30, 100);
    stroke(0);
    stroke(color(215, 100, 0));
    fill(215, 100, 0);
    rect(DisplayHeight-49, (DisplayHeight-19)-(fuel/10), 28, (fuel/10)-2);
    stroke(0);
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
    float G = 0.1;
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


  //Integrate function
  void integrate() {
    velocity.add(acceleration);
    velocity.div(30);
    orientation = velocity.heading();
    position.add(velocity);
    force.add(gravity);
    gravity = new PVector();
    acceleration = force.copy().div(mass);
  }


  void launch(PVector dragVec) {
    PVector thrust = position.copy().sub(dragVec);
    force = thrust.mult(2);
    gravity = new PVector();
    println(thrust.mag() + "!");
    fuel = fuel-(thrust.mag()/2);
  }

  ////Getter for Position
  PVector getPosition() {
    return position;
  }

  public Ship() {
    this.position = new PVector(DisplayHeight/2, DisplayHeight/2+300);
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.thrust = new PVector();
    this.force = new PVector();
    this.fuel = 1000;
    gravity = new PVector();
    mass = 10;
  }
}
