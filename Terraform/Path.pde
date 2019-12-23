public class Path {
  Alien self;
  int depth;
  PVector launch;
  Planet target;
  ArrayList<PVector> pathCoords = new ArrayList<PVector>();

  boolean check() {
    self.position = alien.position.copy();
    self.velocity = alien.velocity.copy();
    self.acceleration = alien.acceleration.copy();
    self.thrust = alien.thrust.copy();
    self.force = alien.force.copy();
    self.gravity = alien.gravity.copy();
    //println(self.clockwise);
    // println("LAUNCH - " + launch);
    self.launchAlien(launch);
    pathCoords.clear();

    for (int j = 0; j < depth; j++) {
      for (Planet planet : planets) {
        if (self.position.dist(planet.position) < planet.gravitationalPull) {
          self.applyGravity(planet);
        }
        if (alien.onPlanet) {
          if (self.position.dist(planet.position) < (planet.size/2)) {
            //display();
            // println("hit planet1");
            return planet.position.equals(target.position);
          }
        } else {
          if (self.position.dist(planet.position) < (planet.size/2)+7.5) {
            //display();
            //println("hit planet2");
            return planet.position.equals(target.position);
          }
        }
      }
      //PVector oldPos = self.position.copy();
      PVector lineCoord = self.position.copy();
      pathCoords.add(lineCoord);
      self.integrate();
      //if (oldPos.dist(target.position) > self.position.dist(target.position)) {
      //  display();
      //  println("wrong direction");
      //  return false;
      //}
    }
    //this.display();
    // println("couldnt find");
    return false;
  }

  void display() {
    for (int i = 0; i < pathCoords.size(); i++) {
      if (i > 0) {
        stroke(200, 200, 0);
        line(pathCoords.get(i-1).x, pathCoords.get(i-1).y, pathCoords.get(i).x, pathCoords.get(i).y);
        stroke(0);
      }
    }
  }

  void resetMag() {
    launch.setMag(3000);
  }

  void changeMag(int num) {
    //println("increase Mag");
    launch.setMag(launch.mag()+(num*55));
  }

  void clockwise() {
   //println("change angle");
    launch.rotate(PI/8);
  }

  void anticlockwise() {
    //println("change angle anti");
    launch.rotate((PI/8)*-1);
  }

  public Path(PVector launch, int depth, Planet target) {
    self = new Alien();
    launch.setMag(5000);
    this.launch = launch;
    this.depth = depth;
    this.target = target;
    self.mass = alien.mass;
    self.position = alien.position.copy();
    self.velocity = alien.velocity.copy();
    self.acceleration = alien.acceleration.copy();
    self.thrust = alien.thrust.copy();
    self.force = alien.force.copy();
    self.gravity = alien.gravity.copy();
  }
}
