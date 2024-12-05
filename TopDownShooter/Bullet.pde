class Bullet {
  PVector location, speed, acceleration;
  int direction;

  Bullet(PVector origin, int d){
    // Set the bullet spawn location based on the given PVector
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
  }

  // Display the bullet as a dark grey cube
  void display() {
    noStroke();
    rectMode(CENTER);
    fill(100);
    rect(location.x,location.y,8,8);
  }
  
  // Return the bullet's location as a PVector
  PVector returnLocation() {
    return location; 
  }

}
