public class Level {
  int numberOfPlanets, repeat, repeatCount, level, alivePlanets, numOfAsteroids;
  private ArrayList<Planet> planets = new ArrayList<Planet>();
  private Wormhole wormhole;
  int MIDDLE = (displayWidth/2)+100;
  int MIDDLEVERT = (displayHeight/2);

  void generateLevel() {
    if (numberOfPlanets%2 != 0) {
      if (numberOfPlanets > 3) {
        int chance = (int) random(1, 10);
        if (chance < 7) {
          int randSize = (int) random(90, 135);
          planets.add(new Planet(new PVector(MIDDLE, MIDDLEVERT), randSize));
        } else {
          int randSize = (int) random(90, 135);
          planets.add(new Planet(new PVector(MIDDLE, MIDDLEVERT), randSize));
          randSize = (int) random(75, 115);
          planets.add(new Planet(new PVector(MIDDLE, (int) random(randSize*2, 300-randSize)), randSize));
          randSize = (int) random(75, 115);
          planets.add(new Planet(new PVector(MIDDLE, (int) random(MIDDLEVERT+randSize, MIDDLE -(randSize*2))), randSize));
        }
      } else {
        int randSize = (int) random(90, 135);
        planets.add(new Planet(new PVector(MIDDLE, MIDDLEVERT), randSize));
      }
    }
    int madePlanets = planets.size();
    for (int i =0; i < (numberOfPlanets-madePlanets)/2; i++) {
      boolean found = true;
      int randSize = (int) random(75, 135);
      int randX = (int) random(300+randSize, (MIDDLE-200)-randSize);
      int randY = (int) random(randSize*1.5, MIDDLE-randSize*1.5);
      PVector randPos = new PVector(randX, randY);
      int count = 0;
      while (!reasonablySpaced(randPos, randSize)) {
        randX = (int) random(350+randSize, (MIDDLE-200)-randSize);
        randY = (int) random(randSize*1.5, MIDDLE-randSize*1.5);
        randPos = new PVector(randX, randY);
        count++;
        if (count > 80) {
          randSize = randSize-5;
          count = 0;
          if (randSize < 40) {
            found = false;
            break;
          }
        }
      }
      if (found) {
        planets.add(new Planet(randPos, randSize));
      }
    }
    symmetry();
    generateWormhole();
  }

  ArrayList<Planet> getPlanets() {
    return planets;
  }

  void symmetry() {
    int sizeNum = planets.size();
    for (int i = 0; i < sizeNum; i++) {
      if (planets.get(i).position.x != MIDDLE) {
        int newX = MIDDLE + (MIDDLE-(int)planets.get(i).position.x);
        planets.add(new Planet(new PVector(newX, planets.get(i).position.y), planets.get(i).size));
      }
    }
  }

  Wormhole getWormhole() {
    return this.wormhole;
  }

  int alive() {
    return alivePlanets;
  }

  void meteorShower() {
    if (numOfAsteroids > 0) {
      if ((int) random (0, 100) == 12) {
        asteroids.add(new Asteroid());
        numOfAsteroids--;
      }      
    }
  }
  

  boolean reasonablySpaced(PVector pos, int size) {
    PVector shipPos = new PVector(200, MIDDLEVERT);
    if (pos.dist(shipPos) <= size) {
      return false;
    }
    for (Planet planet : planets) {
      if (planet.position.dist(pos) <= planet.gravitationalPull) {
        return false;
      }
    }
    return true;
  }
  
  PVector getOffset() {
    float sumX = 0;
    float sumY = 0;
    for (Planet planet : planets) {
      sumX+= planet.position.x;
      sumY+=planet.position.y;
    }
    sumX = sumX/planets.size();
    sumY = sumX/planets.size();
    return new PVector(sumX, sumY).sub(new PVector(MIDDLE, MIDDLEVERT));
  }

  ArrayList<Planet> newLevel() {
    aliens.clear();
    asteroids.clear();
    alivePlanets = 0;
    ship = new Ship(true);
    planets.clear();
    level++;
    repeatCount--;
    meteor = ((int) random (1,3) == 2);
    if (repeatCount == 0) {
      if (numberOfPlanets == 12) {
        numberOfPlanets--;
      } else {
        repeat++;
        repeatCount = repeat;
        numberOfPlanets++;
      }
    }
    generateLevel();
    meteor = false;
    return planets;
  }
  
  void generateWormhole(){
    PVector pos = new PVector((int)random(100, 1700), (int)random(100, 900));
    while (!reasonablySpaced(pos, 80)) {
        int randX = (int)random(100, displayWidth-100);
        int randY = (int)random(100, displayHeight-100);
        pos = new PVector(randX, randY);
    }
    wormhole = new Wormhole(pos);
  }

  void setAlive(boolean up) {
    if (up) {
      alivePlanets++;
    } else {
      alivePlanets--;
    }
  }

  public Level() {
    level = 1;
    numberOfPlanets = 3;
    repeat = 1;
    repeatCount = 1;
    generateLevel();
    generateWormhole();
  }
}
