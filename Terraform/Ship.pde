public class Ship { //<>//
  PVector acceleration, velocity, position, gravity, drag, origin, force, blast, thrust;
  PShape ship;
  float invMass, orientation;
  final float DRAG_COEFFICIENT = 0.03;

  void display() {
    //if (!exploded && (position.x > -5 && position.x < displayWidth+5)) {
    //ship.rotate(0.1);
    ship = createShape(TRIANGLE, position.x+10, position.y, position.x, position.y+30, position.x+20, position.y+30);
    ship.setFill(color(260, 100, 40));
    ship.translate(10, 15);
    ship.rotate(orientation);
    shape(ship, 10, 15);
    //  //Integrate the physics
    integrate();
    // println(position.x + " #|" + position.y);
  }

  public Ship() {
    this.position = new PVector(displayHeight/2, displayHeight/2);
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.thrust = new PVector();
    gravity = new PVector();
    invMass = 0.1;
    ship = createShape(RECT, position.x, position.y, 20, 30);
  }

  //Setter for velocity
  void setVelocity(PVector newVel) {
    velocity = newVel;
  }

  void turnShip(float heading) {
    println(heading);
    orientation = heading-position.heading();
  }

  ////Integrate function
  void integrate() {
    velocity.add(acceleration);
    velocity.div(90);
    //println(velocity);
    position.add(velocity);
    //Calculate resultant acceleration = force/mass
    acceleration = getForce().div(getMass());
  }

  void launch(PVector dragVec) {
    PVector newVec = position.copy().sub(dragVec);
    println(newVec);
    thrust.add(newVec);
  }

  //Calculate force
  PVector getForce() {
    //force = mass*acceleration where acceleration is equal to the gravity
    PVector currentForce = thrust.copy().mult(getMass());
    //d=k1v1+k2v2 where k2 is simply the dampening factor.
    return currentForce;
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
