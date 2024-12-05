class Licker {

  PVector location, velocity, acceleration;
  int r = int(random(0,2));
  int health = 2;

  Licker() {
    // Set licker spawn location to either the top or the bottom of the playable area
    if (r == 0) {
      location = new PVector(random(0,400),340);
    }
    else {
      location = new PVector(random(0,400),80);
    }
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
  }

  // Move towards the player slowly
  void move(PVector player) {
    PVector direction = PVector.sub(player,location);
    direction.normalize();
    direction.mult(3);
    acceleration = direction;
    velocity = acceleration;
    location.add(velocity);
    // If moving out of bounds, move them back in bounds
    if (location.y < 80) {
      location.y = 80; 
    }
    else if (location.y > 350) {
      location.y = 350; 
    }
    if (location.x < 0) {
      location.x = 0;
    }
    else if (location.x > 390) {
      location.x = 390;
    }
  }

  // Display the licker
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(155,35,11);
    rect(location.x,location.y,25,25);
  }

  // If the licker collides with an objecr return true
  boolean collides(PVector v) {
    if (v.dist(location) <= 25){
      return true;
    }
    else {
      return false;
    }
  }
  
  // Return the licker location as a PVector
  PVector lickerLocation() {
    return location;
  }
  
  // Lowers the licker's health by one
  void lowerHealth() {
    health--;
  }
  
  // Returns the health value of the licker as a variable
  int returnHealth() {
    return health; 
  }
  
}
