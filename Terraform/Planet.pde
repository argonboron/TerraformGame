public class Planet {
  boolean dead, beingOrbited, tint, beingAttacked;
  PVector position;
  float mass, lifeLimit, orbitDiameter;
  int size, lifeForce, gravitationalPull, orbitCount;
  int DisplayHeight = 1000;
  color c;

  PImage p0, p1, p2, p3, p4;

  boolean display() {
    if (beingOrbited && lifeForce < lifeLimit && !ship.pause) {
      lifeForce++;
    }
    if (beingAttacked && lifeForce>0 && !ship.pause) {
      lifeForce--;
    }
    if (lifeForce >= lifeLimit && dead) {
      dead = false;
      score+=size;
      level.setAlive(true);
      ship.addFuel(size*2.2);
    }
    if (lifeForce == 0 && !dead) {
      dead = true;
      level.setAlive(false);
    }
    push();
    if (show) {
      ellipseMode(CENTER);
      fill(0, 200, 40, 50);
      ellipse(position.x, position.y, gravitationalPull*2, gravitationalPull*2);
      fill(0, 40, 200, 50);
      ellipse(position.x, position.y, orbitDiameter*2, orbitDiameter*2);
      fill(0);
    }
    if (tint) {
      tint(c);
    }
    if (lifeForce < lifeLimit/4 && dead) {
      image(p0, position.x-(size/2), position.y-(size/2));
    } else if (lifeForce < (lifeLimit/2) && dead) {
      image(p1, position.x-(size/2), position.y-(size/2));
    } else if (lifeForce < (lifeLimit/4)*3 && dead) {
      image(p2, position.x-(size/2), position.y-(size/2));
    } else if (lifeForce < (lifeLimit) && dead) {
      image(p3, position.x-(size/2), position.y-(size/2));
    } else {
      image(p4, position.x-(size/2), position.y-(size/2));
    }
    float num = (lifeForce/lifeLimit)*255.0;
    if (num > 255) {
      num = 255;
    }
    pop();
    fill(200);
    rect(position.x-size/2, position.y+size/1.5, size, 5);
    fill(0);
    float life = lifeForce/lifeLimit*size;
    if (life > size) {
      life = size;
    }
    fill(255-num, num, 0);
    rect(position.x-size/2, position.y+size/1.5, life, 5);
    fill(0);
    return position.y-size > DisplayHeight;
  }

  void increaseOrbit() {
    orbitCount++;
  }

  void hit() {
    lifeForce = lifeForce-((int) lifeLimit/5);
    if (lifeForce < 0) {
      lifeForce = 0;
      if (!dead) {
        dead = true;
        level.setAlive(false);
      }
    }
  }

  public Planet(PVector position, int size) {
    this.position = position;
    this.size = size;
    mass = 1.0e16 * size/10;
    lifeForce = 0;
    lifeLimit = size*5.0;
    dead = true;
    tint = random(1, 10) > 7;
    colorMode(HSB, 100);
    c = color(random(0, 100), random(25, 95), 100);
    colorMode(RGB, 255);
    orbitDiameter = size+70;
    gravitationalPull = (size*3);
    p0 = loadImage("Data/planet0.png");
    p1 = loadImage("Data/planet1.png");
    p2 = loadImage("Data/planet2.png");
    p3 = loadImage("Data/planet3.png");
    p4 = loadImage("Data/planet4.png");
    p0.resize(size, size);
    p1.resize(size, size);
    p2.resize(size, size);
    p3.resize(size, size);
    p4.resize(size, size);
  }
}
