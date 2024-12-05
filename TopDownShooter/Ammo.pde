class Ammo {
  PVector location;
  
  Ammo (PVector p) {
    // Set the ammo location to the enemy's location
    location = new PVector(p.x,p.y);
  }
  
  // Display the ammo as a red cube
  void display() {
    noStroke();
    fill(121,28,20);
    rectMode(CENTER);
    rect(location.x,location.y,10,10);
  }
  
  // If the player touches the ammo, collect it and return true
    boolean collect(PVector player) {
    if (player.dist(location) <= 25){
      return true;
    }
    else {
      return false;
    }
  }
  
}
