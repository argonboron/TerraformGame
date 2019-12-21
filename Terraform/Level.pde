public class Level {
  int numberOfPlanets, repeat, repeatCount, level, alivePlanets;
  private ArrayList<Planet> planets = new ArrayList<Planet>();

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
        if (count > 40) {
          randSize = 80;
          count = 0;
        }
      }
      planets.add(new Planet(randPos, randSize));
    }
    symmetry();
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
    ship = new Ship();
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
  }
}
