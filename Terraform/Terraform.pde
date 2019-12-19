import java.util.ArrayList;

ArrayList<Planet> planets = new ArrayList<Planet>();
Ship ship;
Projection project;
int level, speed, orbitCount;
boolean gameOver, battle, drag, orbit, launch;
PVector dragPos, dragDiff, dragOrigin;
PShape line;
PImage bg;
int DisplayHeight = 1000;
int DisplayWidth = 1800;


public void setup() {
  size(1800, 1000);
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
  bg = loadImage("background.png");
  bg.resize(1800, 1000);
}

public void draw() {
  background(bg);
  if (!gameOver) {
    for (int i = 0; i < planets.size(); i++) {
      planets.get(i).display();
      if (ship.position.dist(planets.get(i).position) < planets.get(i).gravitationalPull){
        ship.applyGravity(planets.get(i));
      }
      if (!ship.inOrbit) {
        if ((planets.get(i).position.dist(ship.position) < planets.get(i).orbitDiameter) && !drag) {
          if (orbitCount > 200 && planets.get(i).dead) {
            ship.orbitPlanet = planets.get(i);
            ship.inOrbit = true;
            planets.get(i).beingOrbited = true;
            ship.orbit(planets.get(i).size*1.1, planets.get(i).position);
          } else if (planets.get(i).dead) {
            orbitCount++;
          }
          if (planets.get(i).position.dist(ship.position) < (planets.get(i).size/2)+7.5 && (!ship.pause)) {
            gameOver = true;
          }
        } else {
          planets.get(i).beingOrbited = false;
        }
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
    if (ship.position.y > DisplayHeight || ship.position.x > DisplayWidth || ship.position.x < 0) {
      gameOver = true;
    }
  } else {
    textSize(40);
    fill(255);
    text("Game over!", DisplayWidth/2-105, DisplayHeight/2-50);
    fill(0);
  }
}

public void mousePressed() {
  if (launch){
    drag = true;
    ship.pause(true);
    PVector currentDrag = new PVector(mouseX, mouseY);
    dragDiff = currentDrag.copy().sub(ship.position);
    dragPos = ship.position.copy().add(dragDiff);
    ship.setFuelProjection(dragPos);
    ship.turnShip(ship.position.heading()+dragDiff.heading());
    if (ship.inOrbit) {
      ship.inOrbit = false;
      ship.orbitPlanet.beingOrbited = false;
      ship.orbitPlanet = null;
    }
  }
}

public void mouseDragged() {
  if (drag){
    PVector currentDrag = new PVector(mouseX, mouseY);
    dragDiff = currentDrag.copy().sub(ship.position);
    dragPos = ship.position.copy().add(dragDiff);
    ship.turnShip(ship.position.heading()+dragDiff.heading());
    ship.setFuelProjection(dragPos);
  }
}

public void mouseReleased() {
  if (drag) {
    drag = false;
    ship.pause(false);
    ship.launch(dragPos);
    orbitCount = 0;
    dragPos = new PVector(ship.position.x, ship.position.y);
    dragDiff = new PVector(ship.position.x, ship.position.y);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      launch = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      launch = false;
    }
  }
}
