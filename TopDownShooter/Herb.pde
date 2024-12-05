class Herb {
  PVector location;
  
  Herb(PVector p) {
    // Set the herb location to the zombie's location
    location = new PVector(p.x,p.y);
  }
  
  // Display the herb as a green cube
  void display() {
    noStroke();
    fill(88,142,50);
    rectMode(CENTER);
    rect(location.x,location.y,10,10);
  }
  
  // If the player touches the herb, collect it and return true
  boolean collect(PVector player) {
    if (player.dist(location) <= 25){
      return true;
    }
    else {
      return false;
    }
  }
  
}
