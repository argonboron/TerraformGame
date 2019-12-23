import java.util.ArrayList;
ArrayList<Planet> planets;
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
Ship ship;
Level level;
Projection project;
int speed;
boolean gameOver, battle, drag, orbit, shoot, meteor, started;
PVector dragDiff, mousePos, offset;
PShape line;
PImage bg;
int DisplayHeight = 1000;
int DisplayWidth = 1800;
float scaleFactor = 1.0;
float translateX = 0.0;
float translateY = 0.0;
Wormhole wormhole;
Alien alien;


public void setup() {
  size(1800, 1000);
  background(0);
  ship = new Ship(true);
  project = new Projection();
  level = new Level();
  planets = level.getPlanets();
  offset = level.getOffset();
  wormhole = level.getWormhole();
  gameOver = false;
  battle = false;
  dragDiff = new PVector(ship.position.x, ship.position.y);
  mousePos = new PVector(mouseX, mouseY);
  drag = false;
  bg = loadImage("background.png");
  bg.resize(1800, 1000);
  meteor = false;
  started = false;
}

public void draw() {
  background(bg);
  if (!gameOver) {
    mousePos = new PVector(mouseX-translateX, mouseY-translateY).div(scaleFactor);
    pushMatrix(); 
    translate(translateX, translateY);
    scale(scaleFactor);
    for (int i = 0; i < planets.size(); i++) {
      planets.get(i).display();

      if (ship.position.dist(planets.get(i).position) < planets.get(i).gravitationalPull && started) {
        ship.applyGravity(planets.get(i));
      }

      if (!ship.inOrbit) {
        if ((planets.get(i).position.dist(ship.position) < planets.get(i).orbitDiameter) && !drag) {
          if (planets.get(i).orbitCount > 200 && planets.get(i).dead) {
            ship.orbitPlanet = planets.get(i);
            ship.inOrbit = true;
            planets.get(i).beingOrbited = true;
            ship.orbit(planets.get(i).size*1.1, planets.get(i).position);
          } else if (planets.get(i).dead) {
            planets.get(i).increaseOrbit();
          }
          if (planets.get(i).position.dist(ship.position) < (planets.get(i).size/2)+7.5) {
            gameOver = true;
          }
        } else {
          planets.get(i).beingOrbited = false;
          planets.get(i).orbitCount = 0;
        }
      } else if (ship.orbitPlanet.equals(planets.get(i))) {
        ship.continueOrbit(planets.get(i).size*1.1, planets.get(i).position);
      }
    }
    if (drag) {
      push();
      stroke(255, 0, 0);
      line(ship.position.x, ship.position.y, mousePos.x, mousePos.y);
      pop();
      project.display(planets, new PVector(mousePos.x, mousePos.y));
    }
    wormhole.display();
    ship.display();
    if (level.alive() >= planets.size()/2) {
      if (!meteor) {
        asteroids = level.meteorShower();
        meteor = true;
      }
    }
    if (level.alive() >= planets.size()/2+1 && alien == null) {
      alien = new Alien();
      alien.findTarget();
      alien.startPath();
    }
    for (int i = 0; i < asteroids.size(); i++) {
      if (!asteroids.get(i).display()) {
        asteroids.remove(i);
        i--;
      } else {
        if (asteroids.get(i).position.dist(ship.position) < ship.size/2+asteroids.get(i).size/3) {
          gameOver = true;
        }
      }
    }
    if (alien !=null) {
      alien.display();
      if (!alien.foundPath && alien.searching) {
        alien.pathFinding();
      }
    }
    popMatrix();
    
        //println(beamPoints.size());
    if (ship.beamPoints.size() > 0 && ship.fireNum > 0) { 
      stroke(255, 0, 0);
      strokeWeight(7);
      for (int i = 1; i < ship.beamPoints.size(); i++) {
        line(ship.beamPoints.get(i-1).x, ship.beamPoints.get(i-1).y, ship.beamPoints.get(i).x, ship.beamPoints.get(i).y);
      }
      stroke(0);
      strokeWeight(1);
      ship.fireNum--;
      if (ship.fireNum == 0) {
        ship.laserCharge = 0;
        ship.beamPoints.clear();
      }
    }

    fill(0);
    fill(200);
    rect(20, 950, 100, 10);
    fill(255, 0, 0);
    rect(20, 950, ship.laserCharge, 10);
    fill(0);
    //Fuel
    text("Fuel", DisplayWidth-50, DisplayHeight-100);
    stroke(255);
    rect(DisplayWidth-50, DisplayHeight-120, 30, 100);
    stroke(0);
    stroke(color(215, 100, 0));
    fill(215, 100, 0);
    rect(DisplayWidth-49, (DisplayHeight-19)-(ship.fuel/10), 28, (ship.fuel/10)-2);
    stroke(0);

    if (ship.fuelProject) {
      stroke(color(225, 194, 153));
      fill(225, 194, 153);
      rect(DisplayWidth-49, (DisplayHeight-19)-(ship.fuel/10), 28, (ship.fuelProjectVal/10));
      stroke(0);
    }
    stroke(255);
    line(0, 0, 0, DisplayHeight);
    line(DisplayWidth, 0, DisplayWidth, DisplayHeight);
    line(DisplayWidth, DisplayHeight, 0, DisplayHeight);
    line(0, 0, DisplayWidth, 0);
    stroke(0);
    if (ship.position.y > DisplayHeight || ship.position.x > DisplayWidth || ship.position.x < 0) {
      gameOver = true;
    }
    if (level.alivePlanets == planets.size()) {
      wormhole.setVisible(true);
    }
    if (wormhole.visible && wormhole.position.dist(ship.position) < 83) {
      planets.clear();
      asteroids.clear();
      planets = level.newLevel();
      offset = level.getOffset();
      wormhole = level.getWormhole();
    }
    fill(255);
    text("FPS: " + frameRate, 30, 30);
    fill(0);
  } else {
    textSize(40);
    fill(255);
    text("Game over!", DisplayWidth/2-105, DisplayHeight/2-50);
    fill(0);
  }
}

public void mousePressed() {
  if (!shoot) {
    drag = true;
    ship.pause(true);
    for (Asteroid asteroid : asteroids) {
      asteroid.pause(true);
    }
    PVector currentDrag = new PVector(mouseX, mouseY);
    dragDiff = currentDrag.copy().sub(ship.position);
    ship.setFuelProjection(currentDrag);
    ship.turnShip(ship.position.heading()+dragDiff.heading());
    if (ship.inOrbit) {
      ship.inOrbit = false;
      ship.orbitPlanet.beingOrbited = false;
      ship.orbitPlanet = null;
    }
  } else {
    ship.laserChargeBool = true;
  }
}

public void mouseDragged() {
  if (drag) {
    PVector currentDrag = new PVector(mouseX, mouseY);
    dragDiff = currentDrag.copy().sub(ship.position);
    ship.turnShip(ship.position.heading()+dragDiff.heading());
    ship.setFuelProjection(currentDrag);
  }
}

public void mouseReleased() {
  if (drag) {
    if (!started) {
      started = true;
    }
    drag = false;
    ship.pause(false);
    for (Asteroid asteroid : asteroids) {
      asteroid.pause(false);
    }
    ship.launchShip(mousePos);
  } else {
    ship.laserChargeBool = false;
  }
  if (gameOver) {
    setup();
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shoot = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shoot = false;
    } else if (keyCode == ENTER) {
      setup();
    }
  }
}

//Zoom function
void mouseWheel(MouseEvent e) {
  if ((scaleFactor > 0.4 || e.getCount() < 0) && (scaleFactor < 1.5 || e.getCount() > 0)) {
    translateX -= mouseX;
    translateY -= mouseY;
    float delta = e.getCount() < 0 ? 1.05 : e.getCount() > 0 ? 1.0/1.05 : 1.0;
    scaleFactor *= delta;
    translateX *= delta;
    translateY *= delta;
    translateX += mouseX;
    translateY += mouseY;
  }
}
