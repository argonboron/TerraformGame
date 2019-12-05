import java.util.ArrayList;

ArrayList<Planet> planets = new ArrayList<Planet>();
Ship ship;
int level, speed;
boolean gameOver, battle, drag;
PVector dragPos, dragDiff, dragOrigin;
PShape line;


public void setup() {
  size(displayHeight, displayHeight);
  background(50);
  ship = new Ship();
  planets.add(new Planet());
  gameOver = false;
  battle = false;
  level = 1;
  dragDiff = new PVector(ship.position.x+10, ship.position.y+15);
  dragPos = new PVector(ship.position.x+10, ship.position.y+15);
  drag = false;
  ArrayList<Planet> planets = new ArrayList<Planet>();
}

public void draw() {
  background(50);
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).display();
  }
  if (drag) {
   PShape line = createShape(LINE, ship.position.x+10, ship.position.y+15, dragPos.x, dragPos.y);
   line.setStroke(255);
   shape(line);
  }
  ship.display();
}

public void mousePressed(){
  drag = true;
  //ship.pause();
}

public void mouseDragged(){
  PVector currentDrag = new PVector(mouseX, mouseY);
  dragDiff = currentDrag.copy().sub(ship.position);
  dragPos = ship.position.copy().add(dragDiff);
  ship.turnShip(dragPos.heading());
}
 
public void mouseReleased() {
  drag = false;
  ship.launch(dragPos);
  dragPos = new PVector(ship.position.x+10, ship.position.y+15);
  dragDiff = new PVector(ship.position.x+10, ship.position.y+15);
 }
