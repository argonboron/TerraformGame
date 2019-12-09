public class Projection {
  Ship invisShip;
  ArrayList<PVector> lineCoords = new ArrayList<PVector>();

  void display(ArrayList<Planet> planets, PVector potential) {
    invisShip.position = ship.position.copy();
    invisShip.velocity = ship.velocity.copy();
    invisShip.acceleration = ship.acceleration.copy();
    invisShip.thrust = ship.thrust.copy();
    invisShip.force = ship.force.copy();
    invisShip.gravity = ship.gravity.copy();
    lineCoords.clear();
    invisShip.launch(potential);
  outer: for (int j = 0; j < (abs(potential.mag()-1000))*9; j++) {
      for (Planet planet : planets) {
        invisShip.applyGravity(planet);
        if (planet.position.dist(invisShip.position) < planet.size/2) {
          break outer;
        }
      }
      PVector lineCoord = invisShip.position.copy();
      lineCoords.add(lineCoord);
      invisShip.integrate();
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

  public Projection() {
    invisShip = new Ship();
    invisShip.mass = ship.mass;
    invisShip.position = ship.position.copy();
    invisShip.velocity = ship.velocity.copy();
    invisShip.acceleration = ship.acceleration.copy();
    invisShip.thrust = ship.thrust.copy();
    invisShip.force = ship.force.copy();
    invisShip.gravity = ship.gravity.copy();
  }
}
