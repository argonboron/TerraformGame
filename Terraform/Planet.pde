public class Planet {
  boolean dead, beingOrbited;
  PVector position;
  float mass, lifeLimit;
  int size, lifeForce, orbitDiameter, gravitationalPull;
  int DisplayHeight = 1000;
  PImage p0, p1, p2, p3, p4;

  boolean display() {
    if (!ship.pause) {
      position.add(0, 0.1);
    }
    if (beingOrbited && dead) {
      lifeForce++;
    }
    if (lifeForce >= lifeLimit) {
      dead = false;
    }
    push();
    if (lifeForce < lifeLimit/5) {
      image(p0, position.x-(size/2), position.y-(size/2));
    } else if (lifeForce < (500/5)*2) {
      image(p1, position.x-(size/2), position.y-(size/2));
    } else if (lifeForce < (500/4)*3) {
      image(p2, position.x-(size/2), position.y-(size/2));
    } else if (lifeForce < (500/4)*4) {
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

  public Planet(int i) {
    if (i==1) {
      position = new PVector((DisplayHeight/2)+350, DisplayHeight/2+100);
      size = 50;
    } else {
      position = new PVector((DisplayHeight/2)-200, DisplayHeight/2-200);
      size = 120;
    }
    mass = 1.0e16 * pow(size/50, 3);
    lifeForce = 0;
    lifeLimit = size*5.0;
    dead = true;
    orbitDiameter = size*2;
    gravitationalPull = (size*2);
    p0 = loadImage("planet0.png");
    p1 = loadImage("planet1.png");
    p2 = loadImage("planet2.png");
    p3 = loadImage("planet3.png");
    p4 = loadImage("planet4.png");
    p0.resize(size, size);
    p1.resize(size, size);
    p2.resize(size, size);
    p3.resize(size, size);
    p4.resize(size, size);
  }
}
