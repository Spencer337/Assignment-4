class Player {
  PVector location, shotOrigin;
  int direction, health;
  boolean isLeon;

  Player(boolean l) {
    // Set player location to the center of the screen
    location = new PVector(width/2, height/2);
    // Set shot origin to the bottom of the player
    shotOrigin = new PVector(location.x, location.y + 5);
    // Set player to be facing down
    direction = 2;
    // Set player health to max
    health = 3;
    // Set player to either Leon or Claire
    isLeon = l;
  }

  // If the character is not facing up, make them face up
  // Otherwise, move them up
  // Player cannot move too far up
  void moveUp() {
    if (location.y > 80) {
      if (direction != 0) {
        direction = 0;
      } else {
        location.y -= 5;
      }
      // Change origin location
      shotOrigin.set(location.x, location.y - 16);
    }
  }

  // If the character is not facing left, make them face left
  // Otherwise, move them left
  // Player cannot move too far left
  void moveLeft() {
    if (location.x > 10) {
      if (direction != 1) {
        direction = 1;
      } else {
        location.x -= 5;
      }
      // Change origin location
      shotOrigin.set(location.x - 16, location.y);
    }
  }

  // If the character is not facing down, make them face down
  // Otherwise, move them down
  // Player cannot move too far down
  void moveDown() {
    if (location.y < 335) {
      if (direction != 2) {
        direction = 2;
      } else {
        location.y += 5;
      }
      // Change origin location
      shotOrigin.set(location.x, location.y + 16);
    }
  }

  // If the character is not facing right, make them face right
  // Otherwise, move them right
  // Player cannot move too far right
  void moveRight() {
    if (location.x < 390) {
      if (direction != 3) {
        direction = 3;
      } else {
        location.x += 5;
      }
      // Change origin location
      shotOrigin.set(location.x + 16, location.y);
    }
  }

  void display() {
    noStroke();
    rectMode(CENTER);
    // Display the player differently depending on direction and the location PVector
    if (direction == 0) {
      if (isLeon == true)
      {
        copy(sprites, 128, 96, 32, 32, int(location.x - 16), int(location.y - 16), 32, 32);
      } else {
        copy(sprites, 320, 96, 32, 32, int(location.x - 16), int(location.y - 16), 32, 32);
      }
    } else if (direction == 1) {
      if (isLeon == true) {
        copy(sprites, 128, 32, 32, 32, int(location.x - 16), int(location.y - 16), 32, 32);
      } else {
        copy(sprites, 320, 32, 32, 32, int(location.x - 16), int(location.y - 16), 32, 32);
      }
    } else if (direction == 2) {
      if (isLeon == true) {
        copy(sprites, 128, 0, 32, 32, int(location.x - 16), int(location.y - 16), 32, 32);
      } else {
        copy(sprites, 320, 0, 32, 32, int(location.x - 16), int(location.y - 16), 32, 32);
      }
    } else if (direction == 3) {
      if (isLeon == true) {
        copy(sprites, 128, 64, 32, 32, int(location.x - 16), int(location.y - 16), 32, 32);
      } else {
        copy(sprites, 320, 64, 32, 32, int(location.x - 16), int(location.y - 16), 32, 32);
      }
    }
  }

  // Display the player's health in the form of a sinusoidal function
  // Health changes colour based on the health variable
  void displayHealth(float theta) {
    if (health == 3) {
      stroke(0, 255, 0);
    } else if (health == 2) {
      stroke(221, 222, 54);
    } else if (health == 1) {
      stroke(255, 0, 0);
    }
    noFill();
    for (int i = 0; i < 150; i++) {
      float y = map(sin(theta), -1, 1, 0, 40);
      theta += 0.05;
      line(i - 1, 40, i, y);
    }
    line(150, 0, 150, 40);
    line(0, 40, 150, 40);
  }

  // Return the origin location where bullets will be fired
  PVector returnOrigin() {
    return shotOrigin;
  }

  // Return the location of the player
  PVector getLocation() {
    return location;
  }

  // Return the direction the player is facing
  int returnDirection() {
    return direction;
  }

  // Lower the player's health
  void lowerHealth() {
    health--;
  }

  // Returns the value of the player's health
  int returnHealth() {
    return health;
  }

  // raise the player's health if it is below 3
  void raiseHealth() {
    if (health == 3) {
    } else {
      health++;
    }
  }
}
