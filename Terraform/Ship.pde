public class Ship { //<>//
  PVector acceleration, velocity, position, gravity, drag, origin, force, blast, thrust;
  PShape ship;
  float invMass, orientation;
  boolean pause;
  ArrayList<PVector> lineCoords = new ArrayList<PVector>();

  void display() {
    //if (!exploded && (position.x > -5 && position.x < displayWidth+5)) {
    //ship.rotate(0.1);

    //ship = createShape(TRIANGLE, 0, -15, -10, 15, 10, 15);
    //ship.setFill(color(260, 100, 40));
    ////ship.translate(10, 15);
    //ship.rotate(orientation);
    //ship.translate(position.x, position.y);
    //shape(ship);
    if (!pause) {
      integrate();
    }

    push();
    rectMode(CENTER);
    //translate(0,0);
    translate(position.x, position.y);
    rotate(orientation);
    square(0, 0, 15);
    pop();
    PVector lineCoord = position.copy();
    lineCoords.add(lineCoord);
    for (int i = 0; i < lineCoords.size(); i++) {
      if (i > 0) {
        stroke(255);
        fill(255);
        line(lineCoords.get(i-1).x, lineCoords.get(i-1).y, lineCoords.get(i).x, lineCoords.get(i).y);
        stroke(0);
      }
    }

    // println(position.x + " #|" + position.y);
  }

  public void pause(boolean val) {
    pause = val;
  }

  public Ship() {
    this.position = new PVector(displayHeight/2, displayHeight/2+300);
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.thrust = new PVector();
    this.force = new PVector();
    gravity = new PVector();
    invMass = 0.1;
  }

  void applyGravity(Planet planet) {
    if (!pause) {
      PVector distanceVec = planet.position.copy().sub(position);
      float G = 1;
      float gravForce = (G * planet.size * getMass()) / (pow(distanceVec.mag(), 3));
      gravity.add(distanceVec.mult(gravForce));
    }
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
    velocity.div(10);
    position.add(velocity);
    orientation = velocity.heading();

    //Calculate resultant acceleration = force/mass
    force.add(gravity);
    acceleration = force.copy().div(getMass());
  }

  void launch(PVector dragVec) {
    PVector thrust = position.copy().sub(dragVec);
    force = thrust;
    gravity = new PVector();
  }

  ////Calculate mass as 1/inverse mass
  float getMass() {
    return 1/invMass;
  }

  ////Getter for Position
  PVector getPosition() {
    return position;
  }
}
