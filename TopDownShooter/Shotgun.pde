class Shotgun {
  PVector location, speed, acceleration;
  int direction;

  Shotgun(PVector origin, int d){
    // Set the shotgun pellet spawn location based on the given PVector
    location = new PVector(origin.x, origin.y);
    // Set direction based on player's direction
    direction = d;
    // Set speed based on direction
    if (direction == 0) { // up
      speed = new PVector(0,-1);
    }
    else if (direction == 1) { // left
      speed = new PVector(-1,0);
    }
    else if (direction == 2) { // down
      speed = new PVector(0,1);
    }
    else if (direction == 3) { // right
      speed = new PVector(1,0);
    }
    else if (direction == 4) { // up and left
      speed = new PVector (-0.5, -0.5);
    }
    else if (direction == 5) { // up and right
      speed = new PVector (0.5, -0.5);
    }
    else if (direction == 6) { // down and left
      speed = new PVector (-0.5, 0.5);
    }
    else if (direction == 7) { // down and right
      speed = new PVector (0.5, 0.5);
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
    else if (direction == 4) { // up and left
      acceleration = new PVector(-0.1,-0.1);
    }
    else if (direction == 5) { // up and right
      acceleration = new PVector(0.1,-0.1);
    }
    else if (direction == 6) { // down and left
      acceleration = new PVector(-0.1,0.1);
    }
    else if (direction == 7) { // down and right
      acceleration = new PVector(0.1,0.1);
    }
    // Increase speed by acceleration, making the bullet go faster over time
    speed.add(acceleration);
    location.add(speed);
  }

  // Display the shotgun pellets as 3 golden pellets
  void display() {
    noStroke();
    rectMode(CENTER);
    fill(180,160,40);
    rect(location.x,location.y,10,10);
  }
  
  
  // Return the pellets location as a PVector
  PVector returnLocation() {
    return location; 
  }

}
