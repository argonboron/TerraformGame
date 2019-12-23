public class Alien { //<>//
  PVector acceleration, velocity, position, gravity, drag, force, thrust;
  float mass, orientation;
  boolean pause, onPlanet, clockwise, foundPath, searching, dead;
  ArrayList<PVector> lineCoords = new ArrayList<PVector>();
  Planet currentPlanet, target, lastPlanet;
  int DisplayHeight = 1000;
  int DisplayWidth = 1800;
  int size, mag, startOffLaunch, onPlanetCount;
  PImage fly, land, deadimg;
  Path path;

  void display() {
    push();
    rectMode(CENTER);
    translate(position.x, position.y);  
    if (dead) {
      currentPlanet.beingAttacked = false;
      tint(99);
      image(deadimg, -15, -15);
      velocity.normalize();
      for (Planet planet : planets) {
        if (position.dist(planet.position) < planet.gravitationalPull) {
          applyGravity(planet);
        }
      }
      for (Planet planet : planets) {
        if (planet.position.dist(this.position) < (planet.size/2)+7.5) {
          velocity = new PVector();
          gravity = new PVector();
        }
      }
      integrate();
      rotate(orientation-4.71239);
    } else {
      if (onPlanet) {
        rotate(currentPlanet.position.copy().sub(this.position).heading()+4.71239);
        image(land, -15, -15);
        currentPlanet.beingAttacked = true;
        onPlanetCount--;
        if (onPlanetCount == 0 && (currentPlanet.lifeForce == 0 || ((position.dist(ship.position) < 180 && comingMyDirection()) || position.dist(ship.position) < 110))) {
          startPath();
        }
      } else if ((!searching || startOffLaunch > 0) && !ship.pause && !dead) {
        for (Planet planet : planets) {
          if (position.dist(planet.position) < planet.gravitationalPull) {
            applyGravity(planet);
          }
        }
        integrate();
        rotate(orientation-4.71239);
        image(fly, -15, -15);
        if (startOffLaunch ==1) {
          startPath();
          startOffLaunch--;
        } else if (startOffLaunch > 0) {
          startOffLaunch--;
        }
        if (target == null) {
          findTarget();
          startPath();
        }
      } else {
        rotate(orientation-4.71239);
        image(land, -15, -15);
      }
      if (target != null) {
        if (target.position.dist(this.position) < (target.size/2)+7.5) {
          currentPlanet = target;
          target = null;
          onPlanet = true;
          onPlanetCount = (int) random(100, 700);
        } else {
          for (Planet planet : planets) {
            if (planet.position.dist(this.position) < (planet.size/2)+7.5) {
              currentPlanet = planet;
              findTarget();
              startPath();
              onPlanet = true;
              onPlanetCount = (int) random(100, 700);
            }
          }
        }
      }
    }
    fill(0);
    pop();
  }

  public void pause(boolean val) {
    pause = val;
  }

  boolean comingMyDirection() {
    PVector shipPos = ship.position.copy();
    PVector myPos = position.copy();
    PVector shipVel = ship.velocity.copy();
    PVector direction = myPos.sub(shipPos);
    direction.normalize();
    shipVel.normalize();
    float dot = direction.dot(shipVel);
    return (dot>0.75);
  }

  void findTarget() {
    int maxValue = -100000;     
    int maxIndex = 0;
    for (int i = 0; i < planets.size(); i++) {
      if (!planets.get(i).equals(lastPlanet) && !planets.get(i).equals(currentPlanet)) {
        int currentMaxValue = planets.get(i).lifeForce*2 - ((int) this.position.dist(planets.get(i).position));     
        if (currentMaxValue > maxValue) {
          maxValue = currentMaxValue;
          maxIndex = i;
        }
      }
    }
    if (planets.size() > 0) {
      target = planets.get(maxIndex);
    }
  }

  void startPath() {
    if (!onPlanet) {
      PVector start = target.position.copy().sub(this.position);
      start.setMag(4000);
      int sightLength = (int) this.position.dist(target.position);
      path = new Path(start, sightLength, target);
      clockwise = random(0, 10) > 5;
      mag = 0;
      foundPath = false;
      searching = true;
    } else {
      PVector start = this.position.copy().sub(currentPlanet.position);
      start.setMag(10000);
      launchAlien(start);
      startOffLaunch = 20;
      onPlanet = false;
      onPlanetCount = 0;
      currentPlanet.beingAttacked = false;
      lastPlanet = currentPlanet;
      currentPlanet = null;
    }
  }

  void pathFinding() {
    if (mag > 11) {
      mag = 0;
      path.resetMag();
      if (clockwise) {
        path.clockwise();
      } else {
        path.anticlockwise();
      }
    } else {

      path.changeMag(mag);
      mag++;
    }
    foundPath = path.check();
    if (foundPath) {
      //println("FOUND");
      this.launchAlien(path.launch);
      searching = false;
      foundPath = false;
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


  void launchAlien(PVector launchVec) {
    force = launchVec;
    gravity = new PVector();
    velocity = new PVector();
  }

  public Alien() {
    switch((int) random(1, 4)) {
    case 1:
      this.position = new PVector(0, random(0, 1000));
      break;
    case 2:
      this.position = new PVector(random(0, 1800), 0);
      break;
    case 3:
      this.position = new PVector(random(0, 1800), 1000);
      break;
    case 4:
      this.position = new PVector(1800, random(0, 1000));
      break;
    }
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.thrust = new PVector();
    this.force = new PVector();
    gravity = new PVector();
    dead = false;
    size = 40;
    mass = 1;
    fly = loadImage("alienFly.png");
    land = loadImage("alienLand.png");
    deadimg = loadImage("alienDead.png");
    fly.resize(size, size);
    land.resize(size, size);
    deadimg.resize(size, size);
  }
}
