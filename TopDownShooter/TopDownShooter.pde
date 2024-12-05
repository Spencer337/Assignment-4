Player survivor;
PImage leonStill;
PImage claireStill;
PImage sprites;
ArrayList <Zombie> zombies;
ArrayList <Bullet> bullets;
ArrayList <Shotgun> pellets;
ArrayList <Grenade> grenades;
ArrayList <Herb> herbs;
ArrayList <Ammo> ammos;
ArrayList <Licker> lickers;
float theta; // For sinusoidal health bar
int invincibility; // Player will have an invincibility window after taking damage
int p; // The number of bullets the player currently has
int q; // The number of special ammo the player currently has
int state;
boolean isLeon;
int timer;
boolean pistolEquipped;

void setup() {
  // Set canvas size
  size(400, 400);
  // Initialize objects, arrays, and variables
  leonStill = loadImage("leon-image.png");
  claireStill = loadImage("claire-image.png");
  sprites = loadImage("RE2Sprites.png");
  invincibility = 600;
  isLeon = true;
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
    textSize(30);
    textAlign(CENTER);
    fill(255);
    text(timer, 350, 30);
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

    // Draw the player object
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

    // Draw pellets when they are shot, and have them move straight forward
    for (int i = 0; i < pellets.size(); i++) {
      pellets.get(i).display();
      pellets.get(i).fly();
    }

    // Draw grenades when they are shot, and have them move straight forward until they explode
    for (int i = 0; i < grenades.size(); i++) {
      grenades.get(i).display();
      grenades.get(i).fly();
    }

    // Each time a grenade reaches the end of it's lifespan it explodes, killing anything in the blast radius
    for (int i = grenades.size() - 1; i >= 0; i--) {
      if (grenades.get(i).returnLifespan() <= 0) {
        grenades.get(i).explode();
        Grenade g = grenades.get(i);
        for (int j = zombies.size() - 1; j >= 0; j--) {
          Zombie z = zombies.get(j);
          if (z.collides(g.returnLocation(), 60) == true) {
            int r = int(random(0, 3));
            if (r == 0) {
              ammos.add(new Ammo(zombies.get(j).zombieLocation()));
            } else if (r == 1) {
              herbs.add(new Herb(zombies.get(j).zombieLocation()));
            }
            zombies.remove(j);
          }
        }
        for (int k = lickers.size() - 1; k >= 0; k--) {
          Licker l = lickers.get(k);
          if (l.collides(g.returnLocation(), 60) == true) {
            int r = int(random(0, 3));
            if (r == 0) {
              ammos.add(new Ammo(lickers.get(k).lickerLocation()));
            } else if (r == 1) {
              herbs.add(new Herb(lickers.get(k).lickerLocation()));
            }
            lickers.remove(k);
          }
        }
        grenades.remove(i);
      }
    }

    // Draw all zombies in the array
    for (int i = 0; i < zombies.size(); i++) {
      zombies.get(i).display();
    }

    // Draw all lickers in the array
    for (int i = 0; i < lickers.size(); i++) {
      lickers.get(i).display();
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
        if (z.collides(b.returnLocation(), 15) == true) {
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

    // If a bullet in the pistol bullets array, collides with a licker from the licker array, delete both the bullet
    // Delete the licker only if it reaches zero health
    // After a licker is removed, spawn a herb, ammo, or nothing
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      for (int j = lickers.size() - 1; j >= 0; j--) {
        Licker l = lickers.get(j);
        if (l.collides(b.returnLocation(), 20) == true) {
          bullets.remove(i);
          lickers.get(j).lowerHealth();
          if (lickers.get(j).returnHealth() == 0) {
            int r = int(random(0, 3));
            if (r == 0) {
              ammos.add(new Ammo(lickers.get(j).lickerLocation()));
            } else if (r == 1) {
              herbs.add(new Herb(lickers.get(j).lickerLocation()));
            }
            lickers.remove(j);
          }
        }
      }
    }

    // If a pellet in the pellets array, collides with an enemy, remove both the shotgun pellet and the enemy
    // After an enemy is removed, spawn a herb, ammo, or nothing
    for (int i = pellets.size() - 1; i >= 0; i--) {
      Shotgun b = pellets.get(i);
      
      // Check shotgun pellets against lickers
      for (int j = lickers.size() - 1; j >= 0; j--) {
        Licker l = lickers.get(j);
        if (l.collides(b.returnLocation(), 20) == true) {
          pellets.remove(i);
          int r = int(random(0, 3));
          if (r == 0) {
            ammos.add(new Ammo(lickers.get(j).lickerLocation()));
          } else if (r == 1) {
            herbs.add(new Herb(lickers.get(j).lickerLocation()));
          }
          lickers.remove(j);
        }
      }

      // Check shotgun pellets against zombies
      for (int j = zombies.size() - 1; j >= 0; j--) {
        Zombie z = zombies.get(j);
        if (z.collides(b.returnLocation(), 15) == true) {
          pellets.remove(i);
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
    
    // If a pellet collides with the border walls, remove it
    for (int i = pellets.size() - 1; i >= 0; i--) {
      PVector l = pellets.get(i).returnLocation();
      if (l.x < 0 || l.x > width || l.y < 70 || l.y > 360) {
        pellets.remove(i);
      }
    }

    // If a zombie and player touch, damage the player
    // After the player gets damaged, they cannot be injured again for 10 seconds
    if (invincibility >= 600) {
      for (int i = 0; i < zombies.size(); i++) {
        if (zombies.get(i).collides(survivor.getLocation(), 15) == true) {
          survivor.lowerHealth();
          invincibility = 0;
        }
      }
    }

    // If a licker and player touch, damage the player
    // After the player gets damaged, they cannot be injured again for 10 seconds
    if (invincibility >= 600) {
      for (int i = 0; i < lickers.size(); i++) {
        if (lickers.get(i).collides(survivor.getLocation(), 20) == true) {
          survivor.lowerHealth();
          invincibility = 0;
        }
      }
    }

    invincibility++;
    drawAmmoHUD();
    if (frameCount % 60 == 0) {
      timer --;
      // If timer has reached 0, go to win screen
      if (timer <= 0) {
        state = 3;
      }

      // Once every second, there is a 10% chance a licker will spawn, and a 20% chance a zombie will spawn
      int r = int(random(0, 100)) + 1;
      if (r <= 20) {
        lickers.add(new Licker());
      } else if ( r <= 50) {
        zombies.add(new Zombie());
      }
      // Once every second, the zombies move towards the player
      for (int i = 0; i < zombies.size(); i++) {
        zombies.get(i).move(survivor.getLocation());
      }
    }

    // If the player dies, go to the death screen
    if (survivor.returnHealth() <= 0) {
      state = 2;
    }
  }
  // If the player has died, display a death screen
  else if (state == 2) {
    background(60, 0, 0);
  }
  // If the timer has ran out, display a win screen
  else if (state == 3) {
    background(0, 60, 0);
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
      isLeon = true;
      pistolEquipped = true;
      survivor = new Player(isLeon);
      bullets = new ArrayList <Bullet>();
      grenades = new ArrayList <Grenade>();
      pellets = new ArrayList <Shotgun>();
      zombies = new ArrayList <Zombie>();
      lickers = new ArrayList <Licker>();
      herbs = new ArrayList <Herb>();
      ammos = new ArrayList <Ammo>();
      theta = 0.0;
      p = 8;
      q = 8;
      timer = 100;
      state = 1;
    } else if (mouseX > 240 && mouseX < 370 && mouseY > 165 && mouseY < 380) {
      // Set the survivor to be Claire
      isLeon = false;
      pistolEquipped = true;
      survivor = new Player(isLeon);
      bullets = new ArrayList <Bullet>();
      grenades = new ArrayList <Grenade>();
      pellets = new ArrayList <Shotgun>();
      zombies = new ArrayList <Zombie>();
      lickers = new ArrayList <Licker>();
      herbs = new ArrayList <Herb>();
      ammos = new ArrayList <Ammo>();
      theta = 0.0;
      p = 8;
      q = 8;
      timer = 100;
      state = 1;
    }
  }
}

void keyPressed() {
  if (state == 1) {
    // If w key is pressed, face up, and then move up
    if (key == 'w') {
      survivor.moveUp();
      // Each time the player moves, all the lickers move as well
      for (int i = 0; i < lickers.size(); i++) {
        lickers.get(i).move(survivor.getLocation());
      }
    }
    // If a key is pressed, face left, and then move left
    else if (key == 'a') {
      survivor.moveLeft();
      // Each time the player moves, all the lickers move as well
      for (int i = 0; i < lickers.size(); i++) {
        lickers.get(i).move(survivor.getLocation());
      }
    }
    // If s key is pressed, face down, and then move down
    else if (key == 's') {
      survivor.moveDown();
      // Each time the player moves, all the lickers move as well
      for (int i = 0; i < lickers.size(); i++) {
        lickers.get(i).move(survivor.getLocation());
      }
    }
    // If d key is pressed, face right, and then move right
    else if (key == 'd') {
      survivor.moveRight();
      // Each time the player moves, all the lickers move as well
      for (int i = 0; i < lickers.size(); i++) {
        lickers.get(i).move(survivor.getLocation());
      }
    }
    // If space key is pressed, and the player has at least one bullet, shoot bullet
    else if (key == ' ') {
      if (pistolEquipped == true) {
        if (p > 0) {
          // Shoot the bullet based on the survivors location and direction
          bullets.add(new Bullet(survivor.returnOrigin(), survivor.returnDirection()));
          // Lower the number of bullets by one
          p--;
        }
      } else if (pistolEquipped == false && isLeon == false) {
        if (q > 0) {
          // Shoot the grenade based on the survivors location and direction
          grenades.add(new Grenade(survivor.returnOrigin(), survivor.returnDirection()));
          // Lower the number of grenades by one
          q--;
        }
      } else if (pistolEquipped == false && isLeon == true) {
        // Shoot the shotgun pellets based on the survivors location and direction
        if (survivor.returnDirection() == 0) { // facing up
          pellets.add(new Shotgun(survivor.returnOrigin(), 0));
          pellets.add(new Shotgun(survivor.returnOrigin(), 4));
          pellets.add(new Shotgun(survivor.returnOrigin(), 5));
        } else if (survivor.returnDirection() == 1) { // facing left
          pellets.add(new Shotgun(survivor.returnOrigin(), 1));
          pellets.add(new Shotgun(survivor.returnOrigin(), 4));
          pellets.add(new Shotgun(survivor.returnOrigin(), 6));
        } else if (survivor.returnDirection() == 2) { // facing down
          pellets.add(new Shotgun(survivor.returnOrigin(), 2));
          pellets.add(new Shotgun(survivor.returnOrigin(), 6));
          pellets.add(new Shotgun(survivor.returnOrigin(), 7));
        } else if (survivor.returnDirection() == 3) { // facing right
          pellets.add(new Shotgun(survivor.returnOrigin(), 3));
          pellets.add(new Shotgun(survivor.returnOrigin(), 5));
          pellets.add(new Shotgun(survivor.returnOrigin(), 7));
        }
        // Lower the number of grenades by one
        q--;
      }
    }
    // If e key is pressed, change weapon
    else if (key == 'e') {
      pistolEquipped = !pistolEquipped;
    }
  } else if (state == 2 || state == 3) {
    state = 0;
  }
}
