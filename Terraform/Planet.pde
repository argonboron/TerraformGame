public class Planet {
  boolean dead;
  PVector position, gravitationalPull;
  int size, lifeForce, orbitDiameter;

  boolean display() {
    fill(50, 200, 200);
    ellipse(position.x, position.y, size, size);
    fill(0);
    return position.y-size > displayHeight;
  }

  public Planet() {
    size = 100;
    position = new PVector((displayHeight/2)+100, displayHeight/2);
    orbitDiameter = size + size/3;
  }
}
