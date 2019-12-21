public class Level {
  int numberOfPlanets, repeat, repeatCount, level, alivePlanets;
  private ArrayList<Planet> planets = new ArrayList<Planet>();
  private Wormhole wormhole;

  void generateLevel() {
    if (numberOfPlanets%2 != 0) {
      if (numberOfPlanets > 3) {
        int chance = (int) random(1, 10);
        if (chance < 7) {
          int randSize = (int) random(90, 135);
          planets.add(new Planet(new PVector(1000, 500), randSize));
        } else {
          int randSize = (int) random(90, 135);
          planets.add(new Planet(new PVector(1000, 500), randSize));
          randSize = (int) random(75, 115);
          planets.add(new Planet(new PVector(1000, (int) random(randSize*2, 300-randSize)), randSize));
          randSize = (int) random(75, 115);
          planets.add(new Planet(new PVector(1000, (int) random(500+randSize, 1000 -(randSize*2))), randSize));
        }
      } else {
        int randSize = (int) random(90, 135);
        planets.add(new Planet(new PVector(1000, 500), randSize));
      }
    }
    int madePlanets = planets.size();
    for (int i =0; i < (numberOfPlanets-madePlanets)/2; i++) {
      boolean found = true;
      int randSize = (int) random(75, 135);
      int randX = (int) random(200+randSize, 700-randSize);
      int randY = (int) random(randSize*1.5, 1000-randSize*1.5);
      PVector randPos = new PVector(randX, randY);
      int count = 0;
      while (!reasonablySpaced(randPos, randSize)) {
        randX = (int) random(200+randSize, 700-randSize);
        randY = (int) random(randSize*1.5, 1000-randSize*1.5);
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
      if (planets.get(i).position.x != 1000) {
        int newX = 1000 + (1000-(int)planets.get(i).position.x);
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

  ArrayList<Asteroid> meteorShower() {
    ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
    for (int i =0; i < level+3; i++) {
      asteroids.add(new Asteroid());
    }
    return asteroids;
  }

  boolean reasonablySpaced(PVector pos, int size) {
    PVector shipPos = new PVector(200, 500);
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

  ArrayList<Planet> newLevel() {
    alivePlanets = 0;
    ship = new Ship(true);
    planets.clear();
    level++;
    repeatCount--;
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
    return planets;
  }
  
  void generateWormhole(){
    PVector pos = new PVector((int)random(100, 1700), (int)random(100, 900));
    while (!reasonablySpaced(pos, 80)) {
        int randX = (int)random(100, 1700);
        int randY = (int)random(100, 900);
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
