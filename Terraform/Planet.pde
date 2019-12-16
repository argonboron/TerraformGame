public class Planet {
  boolean dead, beingOrbited;
  PVector position;
  int size, lifeForce, orbitDiameter, gravitationalPull, mass;
  int DisplayHeight = 1000;

  boolean display() {
    if (!ship.pause) {
      //position.add(0, 0.1);
    }
    if (beingOrbited && dead) {
      lifeForce++;
    }
    if (lifeForce >= 500) {
      dead = false;
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
    return position.y-size > DisplayHeight;
  }

  public Planet(int i) {
    if (i==1) {
      position = new PVector((DisplayHeight/2)+350, DisplayHeight/2+100);
      size = 50;
    } else {
      position = new PVector((DisplayHeight/2)-200, DisplayHeight/2-200);
      size = 100;
    }
    lifeForce = 0;
    dead = true;
    mass = size*6;
    orbitDiameter = size*2;
    gravitationalPull = (size*2);
  }
}
