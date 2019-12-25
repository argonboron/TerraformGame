public class Wormhole {
  PVector position;
  float mass, rotate;
  int size, gravitationalPull;
  int DisplayHeight = 1000;
  PImage img;
  boolean visible;

  void display() {
    if (visible) {
      push();
      translate(position.x-(size/2), position.y-(size/2));
      rotate(rotate);
      imageMode(CENTER);
      image(img, -2, 0);
      rotate = rotate-(PI/100);
      pop();
    }
  }

  void setVisible(boolean val) {
    visible = val;
  }

  public Wormhole(PVector position) {
    this.position = position;
    this.size = 90;
    mass = 1.0e16 * size/10;
    gravitationalPull = (size*3);
    img = loadImage("Data/wormhole.png");
    img.resize(size, size);
    this.visible = false;
  }
}
