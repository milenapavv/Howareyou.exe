// HOWAREYOU.EX — by Milena
// Spam keys to create random expressive art with movement and fading

ArrayList<Shape> shapes;  
color bg;  

void setup() {
  size(1500, 800);          // canvas size
  bg = color(20, 20, 30);   // background colour
  background(bg);
  shapes = new ArrayList<Shape>();
  noStroke();
  frameRate(60);
}

void draw() {
  // Optional subtle fade layer (comment out for permanent stains)
  // fill(20, 20, 30, 10);
  // rect(0, 0, width, height);

  // Update and draw all shapes
  for (int i = shapes.size() - 1; i >= 0; i--) {
    Shape s = shapes.get(i);
    s.update();
    s.display();

    // Remove when invisible
    if (s.alpha <= 0) {
      shapes.remove(i);
    }
  }
}

void keyPressed() {
  if (key == 'a') {  // Circle burst
    for (int i = 0; i < 8; i++) {
      shapes.add(new Shape("circle"));
    }
  } 
  else if (key == 's') {  // Rectangle scatter
    for (int i = 0; i < 8; i++) {
      shapes.add(new Shape("rect"));
    }
  } 
  else if (key == 'd') {  // Line explosion
    for (int i = 0; i < 20; i++) {
      shapes.add(new Shape("line"));
    }
  } 
  else if (key == 'f') {  // Triangle cluster
    for (int i = 0; i < 6; i++) {
      shapes.add(new Shape("triangle"));
    }
  } 
  else if (key == 'g') {  // Abstract blob
    shapes.add(new Shape("blob"));
  } 
  else if (key == 'h') {  // Gradient orb
    for (int i = 0; i < 4; i++) {
      shapes.add(new Shape("orb"));
    }
  } 
  else if (key == ' ') {  // Space clears screen
    background(bg);
    shapes.clear();
  } 
  else {  // Random surprise
    String[] types = {"circle", "rect", "triangle", "line", "blob", "orb"};
    int index = int(random(types.length));
    String t = types[index];
    for (int i = 0; i < 5; i++) {
      shapes.add(new Shape(t));
    }
  }
}

// Shape class
class Shape {
  String type;
  float x, y, size, speedX, speedY, alpha;
  color c;

  Shape(String t) {
    type = t;
    x = random(width);
    y = random(height);
    size = random(40, 140);
    speedX = random(-1.8, 1.8);
    speedY = random(-1.8, 1.8);
    c = color(random(100, 255), random(100, 255), random(255));
    alpha = 255;
  }

  void update() {
    x += speedX;
    y += speedY;

    // Bounce at edges
    if (x < 0 || x > width) {
      speedX *= -1;
    }
    if (y < 0 || y > height) {
      speedY *= -1;
    }

    // Fade out
    alpha -= 1.1;
  }

  void display() {
    noStroke();
    fill(c, alpha);

    if (type.equals("circle")) {
      ellipse(x, y, size, size);
    } 
    else if (type.equals("rect")) {
      pushMatrix();
      translate(x, y);
      rotate(radians(random(360)));
      rectMode(CENTER);
      rect(0, 0, size * 0.8, size * 0.8); 
      popMatrix();
    } 
    else if (type.equals("line")) {
      stroke(c, alpha);
      strokeWeight(random(1, 5));
      line(x, y, x + random(-80, 80), y + random(-80, 80));
      noStroke();
    } 
    else if (type.equals("triangle")) {
      triangle(
        x + random(-size, size), y + random(-size, size),
        x + random(-size, size), y + random(-size, size),
        x + random(-size, size), y + random(-size, size)
      );
    } 
    else if (type.equals("blob")) {
      beginShape();
      for (int i = 0; i < 12; i++) {
        float angle = radians(i * 30);
        float r = random(size / 2, size);
        float vx = x + cos(angle) * r;
        float vy = y + sin(angle) * r;
        vertex(vx, vy);
      }
      endShape(CLOSE);
    } 
    else if (type.equals("orb")) {
      noStroke();
      for (int i = 0; i < 12; i++) {
        fill(random(150, 255), random(100, 255), random(255), alpha / (i + 2));
        ellipse(x, y, size * (1.2 - i * 0.08), size * (1.2 - i * 0.08));
      }
    }
  }
}
