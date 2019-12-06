public class Planet {
  boolean dead;
  PVector position, gravitationalPull;
  int size, lifeForce, orbitDiameter;

  boolean display() {
    push();
    fill(50, 200, 200);
    ellipse(position.x, position.y, size, size);
    fill(0);
    pop();
    return position.y-size > displayHeight;
  }

  public Planet(int i) {
    if (i==1) {
      position = new PVector((displayHeight/2)+350, displayHeight/2+100);
    size = 100;
    } else {
     position = new PVector((displayHeight/2)-200, displayHeight/2-200);
    size = 100;
    }
    orbitDiameter = size + size/3;
  }
}
