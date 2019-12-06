public class Projection {
  PVector acceleration, velocity, position, gravity, drag, force, thrust;
  PShape Projection;
  float mass;
  boolean pause;
  ArrayList<PVector> lineCoords = new ArrayList<PVector>();

  void display(ArrayList<Planet> planets, PVector potential) {
    this.position = ship.position.copy();
    this.velocity = ship.velocity.copy();
    this.acceleration = ship.acceleration.copy();
    this.thrust = ship.thrust.copy();
    this.force = ship.force.copy();
    gravity = ship.gravity.copy();
    lineCoords.clear();
    launch(potential);
  outer: for (int j = 0; j < (abs(potential.mag()-1000))*4; j++) {
      for (Planet planet : planets) {
        applyGravity(planet);
        if (planet.position.dist(this.position) < planet.size/2) {
          break outer;
        }
      }
      PVector lineCoord = this.position.copy();
      lineCoords.add(lineCoord);
      integrate();
    }
    for (int i = 0; i < lineCoords.size(); i++) {
      if (i > 0) {
        stroke(200);
        fill(200);
        line(lineCoords.get(i-1).x, lineCoords.get(i-1).y, lineCoords.get(i).x, lineCoords.get(i).y);
        stroke(0);
      }
    }
  }

  void launch(PVector dragVec) {
    PVector thrust = position.copy().sub(dragVec);
    force = thrust;
    gravity = new PVector();
  }

  void applyGravity(Planet planet) {
    if (!pause) {
      PVector distanceVec = planet.position.copy().sub(position);
      float G = 100;
      float gravForce = (G * planet.mass * mass) / (pow(distanceVec.mag(), 3));
      gravity.add(distanceVec.mult(gravForce));
    }
  }

  ////Integrate function
  void integrate() {
    velocity.add(acceleration);
    velocity.div(10);
    position.add(velocity);

    //Calculate resultant acceleration = force/mass
    force.add(gravity);
    gravity = new PVector();
    acceleration = force.copy().div(mass);
  }

  public Projection() {
    this.position = ship.position.copy();
    this.velocity = ship.velocity.copy();
    this.acceleration = ship.acceleration.copy();
    this.thrust = ship.thrust.copy();
    this.force = ship.force.copy();
    gravity = ship.gravity.copy();
    mass = 10;
  }
}
