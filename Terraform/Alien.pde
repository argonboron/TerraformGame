public class Alien {
  PVector acceleration, velocity, position, gravity, drag, force, thrust;
  float mass, orientation;
  boolean pause, onPlanet;
  ArrayList<PVector> lineCoords = new ArrayList<PVector>();
  Planet currentPlanet, targetPlanet;
  int DisplayHeight = 1000;
  int DisplayWidth = 1800;
  int size, showBlast, lifeFrame;
  PImage fly, land;

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
      image(AlienImg, -15, -15);
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
  }

  public void pause(boolean val) {
    pause = val;
  }
  
  void findTarget(){
    int maxValue = 0;
    int maxIndex = 0;
    for(int i = 0; i < planets.size(); i++) {
      int currentMaxValue = planets.get(i).lifeForce*2 + (int) this.position.dist(planets.get(i).position);     
      if (currentMaxValue > maxValue) {
        maxValue = currentMaxValue;
        maxIndex = i;
      }
    }
    targetPlanet = planets.get(maxIndex);
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


  void launchAlien(PVector dragVec) {
    PVector thrust = position.copy().sub(dragVec);
    force = thrust.mult(15);
    gravity = new PVector();
    velocity = new PVector();
    showBlast = 50;
  }

  boolean setFuelProjection(PVector dragVec) {
    fuelProject = true;
    fuelProjectVal = position.copy().sub(dragVec).mult(9).mag()/30;
    return (fuel -fuelProjectVal) > 0;
  }

  void addFuel(float add) {
    fuel += add;
  }

  public Alien() {
    this.position = new PVector(150, 500);
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.thrust = new PVector();
    this.force = new PVector();
    this.fuel = 1000;
    gravity = new PVector();
    size = 40;
    mass = 1;
    fly = loadImage("Alienfly.png");
    land = loadImage("AlienLand.png");
    fly.resize(size, size);
    land.resize(size, size);
  }
}
