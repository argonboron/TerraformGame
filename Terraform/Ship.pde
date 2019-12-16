public class Ship { //<>//
  PVector acceleration, velocity, position, gravity, drag, origin, force, blast, thrust;
  PShape ship;
  float mass, orientation, orbitAngle, fuel, fuelProjectVal;
  boolean pause, inOrbit, clockwise, fuelProject, lifeSprite;
  ArrayList<PVector> lineCoords = new ArrayList<PVector>();
  Planet orbitPlanet;
  int DisplayHeight = 1000;
  int size, showBlast, lifeFrame;
  PImage shipImg, blastImg, lifeImg1, lifeImg2;

  void display() {  
    if (!pause && !inOrbit) {
      integrate();
      orbitAngle = 0;
    }
    PVector lineCoord = position.copy();
    if (lineCoords.size()>200) {
      lineCoords.remove(0);
    }
    if (!pause && ((int) random(0, 2)==1)) {
      lineCoords.add(lineCoord);
    }
    push();
    rectMode(CENTER);
    translate(position.x, position.y);
    rotate(orientation-4.71239);
    if (showBlast > 0 && !inOrbit) {
      image(blastImg, -15, -15);
      showBlast--;
    } else if (!inOrbit) {
      image(shipImg, -15, -15);
    } else {
      lifeFrame++;
      if (lifeFrame%4==0) {
        lifeSprite = !lifeSprite;
      }
      if (lifeSprite) {
        image(lifeImg1, -15, -15);
      } else {
        image(lifeImg2, -15, -15);
      }
    }
    pop();
    fill(0);
    
    //Fuel
    stroke(255);
    rect(DisplayHeight-50, DisplayHeight-120, 30, 100);
    stroke(0);
    stroke(color(215, 100, 0));
    fill(215, 100, 0);
    rect(DisplayHeight-49, (DisplayHeight-19)-(fuel/10), 28, (fuel/10)-2);
    stroke(0);
    
    if (fuelProject) {
    stroke(color(225, 194, 153));
    fill(225, 194, 153);
    rect(DisplayHeight-49, (DisplayHeight-19)-(fuel/10), 28, (fuelProjectVal/10));
    stroke(0);
    }
  }

  public void pause(boolean val) {
    pause = val;
  }

  public void orbit(float radius, PVector planetPos) {
    if (!pause) {
      if (position.y > planetPos.y) {
        clockwise = (velocity.x < 0);
      } else {
        clockwise = (velocity.x > 0);
      }
      float angle = atan2(planetPos.x - position.x, planetPos.y - position.y);
      position = new PVector(planetPos.x+cos(angle)*radius, planetPos.y+sin(angle)*radius);
      orbitAngle = angle;
    }
  }

  public void continueOrbit(float radius, PVector planetPos) {
    if (!pause) {
      position = new PVector(planetPos.x+cos(orbitAngle)*radius, planetPos.y+sin(orbitAngle)*radius);
      orientation = orbitAngle;
      if (clockwise) {
        orbitAngle += PI/160;
      } else {
        orbitAngle -= PI/160;
      }
    }
  }

  void applyGravity(Planet planet) {
    PVector newPos = this.position.copy().mult(10e8);
    PVector planetPos =  planet.position.copy().mult(10e8);
    PVector distanceVec = planetPos.sub(newPos);
    float G = 10e-5;
    float gravForce = (G * planet.mass * mass) / (pow(distanceVec.mag(), 2));
    gravity.add(distanceVec.mult(gravForce));
  }

  //Setter for velocity
  void setVelocity(PVector newVel) {
    velocity = newVel;
  }

  void turnShip(float heading) {
    orientation = heading+2;
  }


  //Integrate function
  void integrate() {
    force.add(gravity);
    gravity = new PVector();
    acceleration = force.copy().div(mass);
    force = new PVector();
    velocity.add(acceleration);
    orientation = velocity.heading();
    position.add(velocity.copy().div(1500));
  }


  void launch(PVector dragVec) {
    PVector thrust = position.copy().sub(dragVec);
    force = thrust.mult(9);
    gravity = new PVector();
    velocity = new PVector();
    fuel = fuel-(thrust.mag()/20);
    fuelProject = false;
    showBlast = 50;
  }
  
  boolean setFuelProjection(PVector dragVec) {
    fuelProject = true;
    fuelProjectVal = position.copy().sub(dragVec).mult(9).mag()/20;
    return (fuel -fuelProjectVal) > 0;
  }

  public Ship() {
    this.position = new PVector(DisplayHeight/2, DisplayHeight/2+300);
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.thrust = new PVector();
    this.force = new PVector();
    this.fuel = 1000;
    gravity = new PVector();
    size = 40;
    mass = 1;
    shipImg = loadImage("ship.png");
    blastImg = loadImage("blast.png");
    lifeImg1 = loadImage("life1.png");
    lifeImg2 = loadImage("life2.png");
    lifeImg1.resize(size, 101);
    lifeImg2.resize(size, 101);
    shipImg.resize(size, size);
    blastImg.resize(size, size);
  }
}
