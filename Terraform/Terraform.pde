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
  planets.add(new Planet(1));
  planets.add(new Planet(2));
  gameOver = false;
  battle = false;
  level = 1;
  dragDiff = new PVector(ship.position.x, ship.position.y);
  dragPos = new PVector(ship.position.x, ship.position.y);
  drag = false;
}

public void draw() {
  background(50);
  for (int i = 0; i < planets.size(); i++) {
    planets.get(i).display();
    ship.applyGravity(planets.get(i));
  }
  if (drag) {
   push();
   //PShape line = createShape(LINE, );
   //line.setStroke(255);
   //shape(line);
   stroke(255);
   line(ship.position.x, ship.position.y, dragPos.x, dragPos.y);
   pop();
  }
  ship.display();
}

public void mousePressed(){
  drag = true;
  ship.pause(true);
  PVector currentDrag = new PVector(mouseX, mouseY);
  dragDiff = currentDrag.copy().sub(ship.position);
  dragPos = ship.position.copy().add(dragDiff);
  ship.turnShip(ship.position.heading()+dragDiff.heading());
}

public void mouseDragged(){
  PVector currentDrag = new PVector(mouseX, mouseY);
  dragDiff = currentDrag.copy().sub(ship.position);
  dragPos = ship.position.copy().add(dragDiff);
  ship.turnShip(ship.position.heading()+dragDiff.heading());
}
 
public void mouseReleased() {
  drag = false;
  ship.pause(false);
  ship.launch(dragPos);
  dragPos = new PVector(ship.position.x, ship.position.y);
  dragDiff = new PVector(ship.position.x, ship.position.y);
 }
