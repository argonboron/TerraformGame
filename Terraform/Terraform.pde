import java.util.ArrayList; //<>//
import processing.sound.*; //<>//

ArrayList<Planet> planets;
ArrayList<Alien> aliens;
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
Ship ship;
Level level;
Projection project;
int speed, score;
boolean gameOver, battle, drag, orbit, shoot, meteor, started, show, won;
PVector dragDiff, mousePos, offset;
PShape line;
PImage bg;
String reasonForDeath;
PFont font, fontLarge, fontSmall;
int DisplayHeight = displayHeight;
int DisplayWidth = displayWidth;
float scaleFactor = 1.0;
float translateX = 0.0;
float translateY = 0.0;
Wormhole wormhole;
SoundFile background, wormholeSound, robotdie, spawn, nextlevel, humansave, start, endscreen, prog, powerup, die, bossLoop, humandie;


public void setup() {
  font = createFont("Data/font.ttf", 22);
  fontLarge = createFont("Data/font.ttf", 50);
  fontSmall = createFont("Data/font.ttf", 16);
  size(displayWidth, displayHeight);
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
  bg = loadImage("Data/background.png");
  bg.resize(displayWidth, displayHeight);
  meteor = false;
  started = false;
  asteroids.clear();
  score = 0;
  aliens = new ArrayList<Alien>();
  DisplayHeight = displayHeight;
  DisplayWidth = displayWidth;
  setupSound();
  won = false;
}

public void draw() {
  background(bg);
  DisplayHeight = displayHeight;
  DisplayWidth = displayWidth;
  if (!gameOver) {
    mousePos = new PVector(mouseX-translateX, mouseY-translateY).div(scaleFactor);
    pushMatrix(); 
    translate(translateX, translateY);
    scale(scaleFactor);
    for (int i = 0; i < planets.size(); i++) {
      planets.get(i).display();

      if (ship.position.dist(planets.get(i).position) < planets.get(i).gravitationalPull && started && !ship.pause) {
        ship.applyGravity(planets.get(i));
      }

      if (!ship.inOrbit) {
        if ((planets.get(i).position.dist(ship.position) < planets.get(i).orbitDiameter) && !drag && !ship.pause) {
          if (planets.get(i).orbitCount > 200 && planets.get(i).dead) {
            ship.orbitPlanet = planets.get(i);
            ship.inOrbit = true;
            planets.get(i).beingOrbited = true;
            ship.orbit(planets.get(i).size*1.1, planets.get(i).position);
          } else if (planets.get(i).dead && !ship.pause) {
            planets.get(i).increaseOrbit();
          }
          if (planets.get(i).position.dist(ship.position) < (planets.get(i).size/2)+7.5) {
            gameOver = true;
            reasonForDeath = "Crashed on planet";
          }
        } else {
          planets.get(i).beingOrbited = false;
          planets.get(i).orbitCount = 0;
        }
      } else if (ship.orbitPlanet.equals(planets.get(i)) && !ship.pause) {
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
        level.numOfAsteroids = level.level+3;
        meteor = true;
      }
    }
    if (level.alive() >= planets.size()/2+1 && aliens.size() == 0) {
      for (int i = 0; i < (level.numberOfPlanets-1)/2; i++) {
        Alien alien = new Alien();
        alien.findTarget();
        alien.startPath();
        aliens.add(alien);
      }
    }
    for (int i = 0; i < asteroids.size(); i++) {
      if (!asteroids.get(i).display()) {
        asteroids.remove(i);
        i--;
      } else {
        if (asteroids.get(i).position.dist(ship.position) < ship.size/2+asteroids.get(i).size/3) {
          if (ship.fuel > 100) {
            ship.fuel -= 100;
          } else {
            gameOver = true;
            reasonForDeath = "Hit by asteroids with low/no fuel";
          }
        }
      }
    }
    if (aliens.size() > 0) {
      for (Alien alien : aliens) {
        alien.display();
        if (!alien.foundPath && alien.searching) {
          alien.pathFinding();
        }
      }
    }
    popMatrix();
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
    rect(20, displayHeight-50, 100, 10);
    fill(255, 0, 0);
    rect(20, displayHeight-50, ship.laserCharge, 10);
    fill(0);

    //Fuel
    stroke(255);
    fill(0);
    rect(DisplayWidth-60, DisplayHeight-130, 30, 100);
    stroke(0);
    stroke(color(215, 100, 0));
    fill(215, 100, 0);
    rect(DisplayWidth-59, (DisplayHeight-19)-(ship.fuel/10)-10, 28, (ship.fuel/10)-2);
    stroke(0);

    if (ship.fuelProject) {
      stroke(color(225, 194, 153));
      fill(225, 194, 153);
      rect(DisplayWidth-59, (DisplayHeight-19)-(ship.fuel/10)-10, 28, (ship.fuelProjectVal/10));
      stroke(0);
    }
    stroke(255);
    line(0, 0, 0, DisplayHeight);
    line(DisplayWidth, 0, DisplayWidth, DisplayHeight);
    line(DisplayWidth, DisplayHeight, 0, DisplayHeight);
    line(0, 0, DisplayWidth, 0);
    stroke(0);
    if (ship.position.y > DisplayHeight+300 || ship.position.x > DisplayWidth+300 || ship.position.x < -300 || ship.position.y < -300) {
      gameOver = true;
      reasonForDeath = "Lost in Space";
    }
    if (level.alivePlanets == planets.size() && !wormhole.visible) {
      wormhole.setVisible(true);
      wormholeSound.play();
    }
    if (wormhole.visible && wormhole.position.dist(ship.position) < wormhole.size) {
      planets.clear();
      asteroids.clear();
      if (level.level != 10) {
        planets = level.newLevel();
        score += 150;
        offset = level.getOffset();
        wormhole = level.getWormhole();
      } else {
        gameOver = true;
        won = true;
      }
    }
    fill(1, 255, 209);
    textFont(fontLarge);
    text("Terraform", 18, 80);
    text("Score: " + Integer.toString(score), (displayWidth/2)-250, 80);
    text("Level: " + Integer.toString(level.level), (displayWidth)-500, 80);
    if (level.numOfAsteroids > 0&& !ship.pause) {
      level.meteorShower();
    }
    if (level.numOfAsteroids > 0 || asteroids.size()>0) {
      fill(255, 100, 0);
      text("METEOR SHOWER!", (displayWidth/2)-380, 200);
      fill(255);
    }
    textFont(fontSmall);
    fill(1, 255, 209);
    if (wormhole.visible) {
      text("Next Level", wormhole.position.x-130, wormhole.position.y-100);
    }
    textFont(fontSmall);
    if (show) {
      fill(5, 130, 240);
      text("stay in here to enter orbit", planets.get(0).position.x-200, planets.get(0).position.y-(planets.get(0).orbitDiameter-60));
      fill(5, 240, 30);
      text("gravitational pull", planets.get(0).position.x-130, planets.get(0).position.y-(planets.get(0).gravitationalPull-90));
      fill(255, 10, 10);
      text("'Shift' click to charge/fire Laser", 20, 930);
      fill(255);
      text("Drag and launch", ship.position.x-120, ship.position.y+40);
      if (asteroids.size()>0) {
        fill(220, 180, 0);
        text("Space debris will hurt you and your terraformed planets", 540, 250);
        text("dodge and shoot them with your laser!", 660, 270);
      }
      if (aliens.size() > 0) {
        fill(255);
        text("Alien will attack your living planets!", aliens.get(0).position.x-120, aliens.get(0).position.y+40);
      }
    } else {
      fill(255);
      text("Press 'h' for help", 750, 120);
      fill(255, 10, 10);
      text("Laser charge:", 20, displayHeight-60);
    }
    fill(255);
    fill(225, 194, 153);
    text("Fuel:", displayWidth-150, 970);
  } else if (!won) {
    textSize(40);
    fill(255);
    text("Game over!", (DisplayWidth/2)-170, DisplayHeight/2-50);
    textFont(font);
    fill(255);
    text(reasonForDeath, (DisplayWidth/2)-((reasonForDeath.length()*25)/2), DisplayHeight/2+170);
    textFont(fontSmall);
    text("Press 'r' to restart", (DisplayWidth/2)-150, DisplayHeight/2-20);
    fill(0);
  } else {
    textSize(40);
    fill(255);
    text("You won!", (DisplayWidth/2)-170, DisplayHeight/2-50);
    textFont(font);
    fill(255);
    String text = "You successfully spread life throughout the galaxy!";
    text(text, (DisplayWidth/2)-((text.length()*25)/2), DisplayHeight/2+100);
    textFont(fontLarge);
    text("Score: " + Integer.toString(score), (DisplayWidth/2)-190, DisplayHeight/2+310);
    textFont(fontSmall);
    String text2 = "Think you can beat your score? Press 'r' to restart";
    text(text2,  (DisplayWidth/2)-((text2.length()*18)/2), DisplayHeight/2+190);
    fill(0);
  }
}

//Setup sounds
void setupSound() {
  //https://freesound.org/people/PatrickLieberkind/sounds/396024/
  String path = "";
  path = sketchPath("Data/bg.wav");
  background = new SoundFile(this, path);
  background.amp(0.6);
  //https://freesound.org/people/MATTIX/sounds/441225/
  path = sketchPath("Data/wormhole.wav");
  wormholeSound = new SoundFile(this, path);
  background.rate(1);
  background.loop();
}

public void mousePressed() {
  if (!shoot && !show && ship.fuel > 0) {
    drag = true;
    ship.pause(true);
    PVector currentDrag = new PVector(mouseX, mouseY);
    dragDiff = currentDrag.copy().sub(ship.position);
    ship.setFuelProjection(currentDrag);
    ship.turnShip(ship.position.heading()+dragDiff.heading());
    if (ship.inOrbit) {
      ship.inOrbit = false;
      ship.orbitPlanet.beingOrbited = false;
      ship.orbitPlanet = null;
    }
  } else if (shoot) {
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
    ship.launchShip(mousePos);
  } else {
    ship.laserChargeBool = false;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shoot = true;
    }
  }
  if (key == 'h') {
    show = true;
    ship.pause = true;
    ;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shoot = false;
    } else if (key == TAB && ship.inOrbit) {
      ship.orbitPlanet.lifeForce += 20;
    }
  }
  if (key == 'h') {
    show = false;
    if (!drag) {
      ship.pause = false;
    }
  }
  if (key == 'r' && gameOver) {
    setup();
  }
}

//Zoom function
void mouseWheel(MouseEvent e) {
  if ((scaleFactor > 0.85 || e.getCount() < 0) && (scaleFactor < 1.1 || e.getCount() > 0)) {
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
