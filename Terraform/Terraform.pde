import java.util.ArrayList;

ArrayList<Planet> planets = new ArrayList<Planet>();
Ship ship;
Projection project;
int level, speed, orbitCount;
boolean gameOver, battle, drag, orbit;
PVector dragPos, dragDiff, dragOrigin;
PShape line;
int DisplayHeight = 1000;


public void setup() {
  size(1000, 1000);
  background(0);
  ship = new Ship();
  project = new Projection();
  planets.add(new Planet(1));
  planets.add(new Planet(2));
  gameOver = false;
  orbitCount = 0;
  battle = false;
  level = 1;
  dragDiff = new PVector(ship.position.x, ship.position.y);
  dragPos = new PVector(ship.position.x, ship.position.y);
  drag = false;
}

public void draw() {
  background(50);
  if (!gameOver) {
    for (int i = 0; i < planets.size(); i++) {
      planets.get(i).display();
      if (!ship.inOrbit) {
        if ((planets.get(i).position.dist(ship.position) < planets.get(i).orbitDiameter) && !drag) {
          if (orbitCount > 200) {
            ship.orbitPlanet = planets.get(i);
            ship.inOrbit = true;
            planets.get(i).beingOrbited = true;
            ship.orbit(planets.get(i).size*1.1, planets.get(i).position);
          } else {
            orbitCount++;
          }
          if (planets.get(i).position.dist(ship.position) < (planets.get(i).size/2)+7.5 && (!ship.pause)) {
            gameOver = true;
          }
        } else {
          planets.get(i).beingOrbited = false;
        }
        ship.applyGravity(planets.get(i));
      } else if (ship.orbitPlanet.equals(planets.get(i))) {
        ship.continueOrbit(planets.get(i).size*1.1, planets.get(i).position);
      }
    }
    if (drag) {
      push();
      stroke(255, 0, 0);
      line(ship.position.x, ship.position.y, dragPos.x, dragPos.y);
      pop();
      project.display(planets, dragPos);
    }
    ship.display();
    if (ship.position.y > DisplayHeight || ship.position.x > DisplayHeight || ship.position.x < 0) {
      gameOver = true;
    }
  } else {
    textSize(40);
    fill(255);
    text("Game over!", DisplayHeight/2-105, DisplayHeight/2-50);
    fill(0);
  }
}

public void mousePressed() {
  drag = true;
  ship.pause(true);
  PVector currentDrag = new PVector(mouseX, mouseY);
  dragDiff = currentDrag.copy().sub(ship.position);
  dragPos = ship.position.copy().add(dragDiff);
  ship.turnShip(ship.position.heading()+dragDiff.heading());
  if (ship.inOrbit) {
    ship.inOrbit = false;
    ship.orbitPlanet.beingOrbited = false;
    ship.orbitPlanet = null;
  }
}

public void mouseDragged() {
  PVector currentDrag = new PVector(mouseX, mouseY);
  dragDiff = currentDrag.copy().sub(ship.position);
  dragPos = ship.position.copy().add(dragDiff);
  ship.turnShip(ship.position.heading()+dragDiff.heading());
}

public void mouseReleased() {
  drag = false;
  ship.pause(false);
  ship.launch(dragPos);
  orbitCount = 0;
  dragPos = new PVector(ship.position.x, ship.position.y);
  dragDiff = new PVector(ship.position.x, ship.position.y);
}
