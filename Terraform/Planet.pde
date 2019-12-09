public class Planet {
  boolean dead, beingOrbited;
  PVector position;
  int size, lifeForce, orbitDiameter, gravitationalPull, mass;

  boolean display() {
    if (!ship.pause) {
      //position.add(0, 0.1);
    }
    if (beingOrbited) {
      lifeForce++;
    }
    push();
    float num = (lifeForce/500.0)*255.0;
    if (num > 255) {
      num = 255;
    }
    fill(num);
    ellipse(position.x, position.y, size, size);
    fill(0);
    pop();
    fill(200);
    rect(position.x-size/2, position.y+size/1.5, size, 5);
    fill(0);
    float life = lifeForce/500.0*size;
    if (life > size) {
      life = size;
    }
    fill(255-num, num, 0);
    rect(position.x-size/2, position.y+size/1.5, life, 5);
    fill(0);
    return position.y-size > displayHeight;
  }

  public Planet(int i) {
    if (i==1) {
      position = new PVector((displayHeight/2)+350, displayHeight/2+100);
      size = 50;
    } else {
      position = new PVector((displayHeight/2)-200, displayHeight/2-200);
      size = 100;
    }
    lifeForce = 0;
    mass = size / 10;
    orbitDiameter = size*2;
    gravitationalPull = (size*2);
  }
}
