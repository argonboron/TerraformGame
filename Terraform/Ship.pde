public class Ship { //<>// //<>// //<>//
  PVector acceleration, velocity, position, gravity, drag, force;
  float mass, orientation, orbitAngle, fuel, fuelProjectVal, laserCharge, fireNum;
  boolean pause, inOrbit, clockwise, fuelProject, lifeSprite, visible, fire, laserChargeBool;
  ArrayList<PVector> beamPoints = new ArrayList<PVector>();
  Planet orbitPlanet;
  int DisplayHeight = 1000;
  int DisplayWidth = 1800;
  int size, showBlast, lifeFrame, maxFuel;
  PImage shipImg, blastImg, lifeImg1, lifeImg2;

  void display() { 
    if (!pause) {
      if (laserChargeBool && fireNum == 0) {
        laserCharge+=3;
      } else {
        laserCharge = 0;
      }
      if (laserCharge >= 100) {
        fireNum = 15;
        fire();
      }
      if (!inOrbit) {
        integrate(); 
        orbitAngle = 0;
      }
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
  }

  public void pause(boolean val) {
    pause = val;
  }

  void fire() {
    PVector beamVector = new PVector(mouseX, mouseY).sub(position);
    beamVector.normalize();
    beamPoints.add(position.copy());
  beamLoop: 
    for (int i = 0; i < 9000; i++) {
      PVector newBeam = beamPoints.get(i).copy().add(beamVector);
      if (aliens.size() > 0) {
        for (Alien alien : aliens) {
          if (newBeam.dist(alien.position) < alien.size/2) {
            alien.dead = true;
            alien.velocity.div(100);
            score+=50;
            break beamLoop;
          }
        }
      } 
      for (int j = 0; j < asteroids.size(); j++) {
        if (newBeam.dist(asteroids.get(j).position) < asteroids.get(j).size/2) {
          asteroids.remove(j);
          score+=10;
          break beamLoop;
        }
      }
      for (int j = 0; j < planets.size(); j++) {
        if (newBeam.dist(planets.get(j).position) < planets.get(j).size/2) {
          break beamLoop;
        }
      }
      if (newBeam.y > DisplayHeight+300 || newBeam.x > DisplayWidth+300 || newBeam.x < -300 || newBeam.y < -300) {
        break;
      }

      beamPoints.add(newBeam);
    }
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

  void addLaser() {
    laserCharge++;
  }


  void launchShip(PVector dragVec) {
    PVector thrust = position.copy().sub(dragVec);
    if (fuel-(thrust.mag()/20) > 0 || !visible) {
      thrust.mult(15);
      force = thrust.add(thrust.copy().mult(log((mass+(maxFuel/2000))/mass+(fuel/2000))));
      gravity = new PVector();
      velocity = new PVector();
      fuel = fuel-(thrust.mag()/30);
      fuelProject = false;
      showBlast = 50;
      if (orbitPlanet != null) {
        orbitPlanet.orbitCount = 0;
      }
    }
  }

  boolean setFuelProjection(PVector dragVec) {
    fuelProject = true;
    if (fuel - position.copy().sub(dragVec).mult(9).mag()/30 > 0) {
      fuelProjectVal = position.copy().sub(dragVec).mult(9).mag()/30;
    } else {
      fuelProjectVal = fuel;
    }
    return (fuel -fuelProjectVal) > 0;
  }

  void addFuel(float add) {
    if (fuel + add > maxFuel) {
      fuel = maxFuel;
    } else {
      fuel += add;
    }
  }

  public Ship(boolean visible) {
    this.position = new PVector(150, displayHeight/2);
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.force = new PVector();
    this.fuel = 1000;
    this.visible = visible;
    gravity = new PVector();
    maxFuel = 1000;
    size = 40;
    mass = 1;
    shipImg = loadImage("Data/ship.png");
    blastImg = loadImage("Data/blast.png");
    lifeImg1 = loadImage("Data/life1.png");
    lifeImg2 = loadImage("Data/life2.png");
    lifeImg1.resize(size, 101);
    lifeImg2.resize(size, 101);
    shipImg.resize(size, size);
    blastImg.resize(size, size);
  }
}
