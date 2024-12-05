Player survivor;
PImage leonStill;
PImage claireStill;
ArrayList <Zombie> zombies;
ArrayList <Bullet> bullets;
ArrayList <Herb> herbs;
ArrayList <Ammo> ammos;
float theta; // For sinusoidal health bar
int invincibility; // Player will have an invincibility window after taking damage
int p; // The number of bullets the player currently has
int state;

void setup() {
  // Set canvas size
  size(400, 400);
  // Initialize objects, arrays, and variables
  leonStill = loadImage("leon-image.png");
  claireStill = loadImage("claire-image.png");
  invincibility = 600;
  state = 0;
}

void draw() {
  if (state == 0) {
    background(0);
    textSize(50);
    textAlign(CENTER);
    fill(157, 6, 6);
    text("Resident Evil 2", width/2, 100);
    stroke(255);
    if (mouseX > 35 && mouseX < 195 && mouseY > 165 && mouseY < 380) {
      fill(20, 54, 108);
    } else {
      noFill();
    }
    rect(35, 165, 130, 215);
    if (mouseX > 240 && mouseX < 370 && mouseY > 165 && mouseY < 380) {
      fill(167, 24, 53);
    } else {
      noFill();
    }
    rect(240, 165, 130, 215);
    leonStill.resize(190, 220);
    image(leonStill, 10, 160);
    claireStill.resize(150, 200);
    image(claireStill, 230, 170);
  } else if (state == 1)
  {
    // Draw level
    background(0);
    rectMode(CORNERS);
    fill(50);
    rect(0, 70, 400, 355);
    fill(247, 236, 150);
    for (int i = 1; i < 400; i += 40) {
      for (int j = 73; j < 350; j += 40) {
        rect(i, j, i+38, j+38);
      }
    }
    fill(170, 170, 160);
    rect(0, 40, 400, 70);

    for (int i = 10; i < 400; i += 60) {
      fill(108, 78, 39);
      rect(i, 45, i+20, 65);
      for (int j = 45; j < 60; j += 10) {
        fill(11, 20, 33);
        rect(i + 1, j + 1, i + 9, j + 9);
        rect(i + 11, j + 1, i + 19, j + 9);
      }
    }

    // Draw the player objects
    survivor.display();
    // Draw player health as a sinusoidal line
    survivor.displayHealth(theta);
    // Increase theta
    theta += 0.02;
    noStroke();

    // Draw bullets when they are shot, and have them move straight forward
    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).display();
      bullets.get(i).fly();
    }

    // Draw an array of zombies
    if (frameCount % 60 == 0) {
      for (int i = 0; i < zombies.size(); i++) {
        zombies.get(i).move(survivor.getLocation());
      }
    }

    // Every 3 seconds, create a new zombie
    if (frameCount % 180 == 0) {
      zombies.add(new Zombie());
    }

    // Draw all zombies in the array
    for (int i = 0; i < zombies.size(); i++) {
      zombies.get(i).display();
    }

    // Draw an array of ammo
    for (int i = 0; i < ammos.size(); i++) {
      ammos.get(i).display();
    }

    // Check if player is touching ammo, then remove
    for (int i = ammos.size() - 1; i >= 0; i--) {
      if (ammos.get(i).collect(survivor.getLocation()) == true) {
        ammos.remove(i);
        p += 3;
      }
    }

    // Draw an array of herbs
    for (int i = 0; i < herbs.size(); i++) {
      herbs.get(i).display();
    }

    // Check if player is touching a herb, and then remove
    for (int i = herbs.size() - 1; i >= 0; i--) {
      if (herbs.get(i).collect(survivor.getLocation()) == true) {
        herbs.remove(i);
        survivor.raiseHealth();
      }
    }

    // If a bullet in the bullets array, collides with a zombie from the zombie array, delete both the bullet and zombie
    // After a zombie is removed, spawn a herb, ammo, or nothing
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      for (int j = zombies.size() - 1; j >= 0; j--) {
        Zombie z = zombies.get(j);
        if (z.collides(b.returnLocation()) == true) {
          bullets.remove(i);
          int r = int(random(0, 3));
          if (r == 0) {
            ammos.add(new Ammo(zombies.get(j).zombieLocation()));
          } else if (r == 1) {
            herbs.add(new Herb(zombies.get(j).zombieLocation()));
          }
          zombies.remove(j);
        }
      }
    }

    // If a bullet collides with the border walls, remove it
    for (int i = bullets.size() - 1; i >= 0; i--) {
      PVector l = bullets.get(i).returnLocation();
      if (l.x < 0 || l.x > width || l.y < 70 || l.y > 360) {
        bullets.remove(i);
      }
    }

    // If a zombie and player touch, damage the player
    // After the player gets damaged, they cannot be injured again for 10 seconds
    if (invincibility >= 600) {
      for (int i = 0; i < zombies.size(); i++) {
        if (zombies.get(i).collides(survivor.getLocation()) == true) {
          survivor.lowerHealth();
          invincibility = 0;
        }
      }
    }
    invincibility++;
    drawAmmoHUD();
    if (survivor.returnHealth() <= 0) {
      state = 2;
    }
  } else {
    background(60, 0, 0);
  }
}

// Draw the number of bullets in the bottom right corner
void drawAmmoHUD() {
  fill(191, 158, 48);
  int j = 380;
  rectMode(CORNERS);
  for (int i = 0; i < p; i++) {
    rect(j, 370, j + 5, 390);
    j -= 10;
  }
}

void mousePressed() {
  if (state == 0) {
    if (mouseX > 35 && mouseX < 195 && mouseY > 165 && mouseY < 380) {
      // Set the survivor to be Leon
      survivor = new Player();
      bullets = new ArrayList <Bullet>();
      zombies = new ArrayList <Zombie>();
      herbs = new ArrayList <Herb>();
      ammos = new ArrayList <Ammo>();
      theta = 0.0;
      p = 8;
      state = 1;
    } else if (mouseX > 240 && mouseX < 370 && mouseY > 165 && mouseY < 380) {
      // Set the survivor to be Claire
      survivor = new Player();
      bullets = new ArrayList <Bullet>();
      zombies = new ArrayList <Zombie>();
      herbs = new ArrayList <Herb>();
      ammos = new ArrayList <Ammo>();
      theta = 0.0;
      p = 8;
      state = 1;
    }
  }
}

void keyPressed() {
  if (state == 1) {
    // If w key is pressed, face up, and then move up
    if (key == 'w') {
      survivor.moveUp();
    }
    // If a key is pressed, face left, and then move left
    else if (key == 'a') {
      survivor.moveLeft();
    }
    // If s key is pressed, face down, and then move down
    else if (key == 's') {
      survivor.moveDown();
    }
    // If d key is pressed, face right, and then move right
    else if (key == 'd') {
      survivor.moveRight();
    }
    // If space key is pressed, and the player has at least one bullet, shoot bullet
    else if (key == ' ') {
      if (p > 0) {
        // Shoot the bullet based on the survivors location and direction
        bullets.add(new Bullet(survivor.returnOrigin(), survivor.returnDirection()));
        // Lower the number of bullets by one
        p--;
      }
    }
  }
  else if (state == 2) {
    state = 0;
  }
}
