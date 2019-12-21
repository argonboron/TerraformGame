public class Asteroid {
  PVector acceleration, velocity, position, gravity, drag, origin, force, blast, thrust;
  float mass, orientation, orbitAngle, fuel, fuelProjectVal;
  boolean pause;
  ArrayList<PVector> lineCoords = new ArrayList<PVector>();
  Planet orbitPlanet;
  int DisplayHeight = 1000;
  int DisplayWidth = 1800;
  int size, frame;
  PImage asteroid1, asteroid2;

  boolean display() {  
    if (!pause) {
      for (Planet planet : planets) {
        if (this.position.dist(planet.position) < planet.gravitationalPull*2+size/4) {
          this.applyGravity(planet);
        }
        if (planet.position.dist(this.position) < (planet.size/2)) {
          planet.hit();
          return false;
        }
      }
      integrate();
    }
    push();
    rectMode(CENTER);
    translate(position.x, position.y);
    rotate(orientation-4.71239);
    if (frame>5) {
      image(asteroid1, -15, -15);
    } else {
      image(asteroid2, -15, -15);
    }
    if(!pause) {
      frame++;
    }
    if (frame > 10) {
      frame =0;
    }
    pop();
    fill(0);
    if (position.y > DisplayHeight || position.x > DisplayWidth || position.x < 0) {
      return false;
    }
    return true;
  }

  public void pause(boolean val) {
    pause = val;
  }



  void applyGravity(Planet planet) {
    PVector newPos = this.position.copy().mult(10e8);
    PVector planetPos =  planet.position.copy().mult(10e8);
    PVector distanceVec = planetPos.sub(newPos);
    float G = 10e-5;
    float gravForce = (G * planet.mass * mass) / (pow(distanceVec.mag(), 2));
    gravity.add(distanceVec.mult(gravForce));
  }


  //Integrate function
  void integrate() {
    force.add(gravity);
    gravity = new PVector();
    acceleration = force.copy().div(mass);
    force = new PVector();
    velocity.add(acceleration);
    orientation = velocity.heading();
    for (int i =0; i < 15; i++) {
      position.add(velocity.copy().div(9000));
    }
  }


  public Asteroid() {
    switch((int) random(1, 5)) {
    case 1:
      this.position = new PVector(0, random(0, 1000));
      this.force = new PVector(6000, random(-1000, 1000));
      break;
    case 2:
      this.position = new PVector(random(0, 1800), 0);
      this.force = new PVector(random(-1000, 1000), 6000);
      break;
    case 3:
      this.position = new PVector(random(0, 1800), 1000);
      this.force = new PVector(random(-1000, 1000), -6000);
      break;
    case 4:
      this.position = new PVector(1800, random(0, 1000));
      this.force = new PVector(-6000, random(-1000, 1000));
      break;
    }
    this.force.div(5);
    this.velocity = new PVector();
    frame = 0;
    this.acceleration = new PVector();
    this.thrust = new PVector();
    gravity = new PVector();
    size = (int) random (50, 80);
    mass = 1;
    asteroid1 = loadImage("asteroid1.png");
    asteroid2 = loadImage("asteroid2.png");
    asteroid1.resize(size, size);
    asteroid2.resize(size, size);
    planets = level.getPlanets();
  }
}
