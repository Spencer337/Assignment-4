class Grenade {
  PVector location, speed, acceleration;
  int direction, lifespan;

  Grenade(PVector origin, int d){
    // Set the grenade spawn location based on the given PVector
    location = new PVector(origin.x, origin.y);
    // Set direction based on player's direction
    direction = d;
    // Set speed based on direction
    if (direction == 0) {
      speed = new PVector(0,-1);
    }
    else if (direction == 1) {
      speed = new PVector(-1,0);
    }
    else if (direction == 2) {
      speed = new PVector(0,1);
    }
    else if (direction == 3) {
      speed = new PVector(1,0);
    }
    acceleration = new PVector(0,0);
    lifespan = 30; // How many frames the grenade will fly for until it explodes
  }

  // Set acceleration based on the player's direction
  void fly() {
    if (direction == 0) {
      acceleration = new PVector(0,-0.1);
    }
    else if (direction == 1) {
      acceleration = new PVector(-0.1,0);
    }
    else if (direction == 2) {
      acceleration = new PVector(0,0.1);
    }
    else if (direction == 3) {
      acceleration = new PVector(0.1,0);
    }
    // Increase speed by acceleration, making the bullet go faster over time
    speed.add(acceleration);
    location.add(speed);
    lifespan --; 
  }

  // Display the grenade as a dark green cube
  void display() {
    noStroke();
    rectMode(CENTER);
    fill(0,80,0);
    rect(location.x,location.y,8,8);
  }
  
  // Explode the grenade creating a puff of smoke
  void explode() {
    noStroke();
    rectMode(CENTER);
    fill(160,160,160,100);
    rect(location.x, location.y, 60, 60);
  }
  
  // Return the grenade's location as a PVector
  PVector returnLocation() {
    return location; 
  }
  
  // Return the lifespan of the grenade as an integer
  int returnLifespan() {
    return lifespan;
  }

}
