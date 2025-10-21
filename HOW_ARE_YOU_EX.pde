// HOWAREYOU.EX — by Milena
// Spam keys to create random expressive art with movement and fading

ArrayList<Shape> shapes;  
color bg = color(20, 20, 30);  

void setup() {
  size(1000, 700);      // canvas size
  background(bg);
  shapes = new ArrayList<Shape>();
  noStroke();
  frameRate(60);
}

void draw() {
  // Slight transparent overlay for trail/fade effect
  //fill(20, 20, 30, 20); 
  //noStroke();
  //rect(-1, -1, width + 2, height + 2);

  // Update and draw shapes
  for (int i = shapes.size() - 1; i >= 0; i--) {
    Shape s = shapes.get(i);
    s.update();
    s.display();

    // remove when invisible
    if (s.alpha <= 0) {
      shapes.remove(i);
    }
  }
}

void keyPressed() {
  if (key == 'a') {  // Circle burst
    for (int i = 0; i < 8; i++) shapes.add(new Shape("circle"));
  } 
  else if (key == 's') {  // Rectangle scatter
    for (int i = 0; i < 8; i++) shapes.add(new Shape("rect"));
  } 
  else if (key == 'd') {  // Line explosion
    for (int i = 0; i < 20; i++) shapes.add(new Shape("line"));
  } 
  else if (key == 'f') {  // Triangle cluster
    for (int i = 0; i < 6; i++) shapes.add(new Shape("triangle"));
  } 
  else if (key == 'g') {  // Abstract blob
    shapes.add(new Shape("blob"));
  } 
  else if (key == 'h') {  // Gradient orb
    for (int i = 0; i < 4; i++) shapes.add(new Shape("orb"));
  } 
  else if (key == ' ') {  // Space clears screen
    background(bg);
    shapes.clear();
  } 
  else {  // Random surprise
    String[] types = {"circle", "rect", "triangle", "line", "blob", "orb"};
    String t = types[int(random(types.length))];
    for (int i = 0; i < 5; i++) shapes.add(new Shape(t));
  }
}

// 🌀 Shape class for all visuals
class Shape {
  String type;
  float x, y, size, speedX, speedY, alpha;
  color c;

  Shape(String t) {
    this.type = t;
    this.x = random(width);
    this.y = random(height);
    this.size = random(40, 140);
    this.speedX = random(-1.8, 1.8);
    this.speedY = random(-1.8, 1.8);
    this.c = color(random(100, 255), random(100, 255), random(255, 255));
    alpha = 255;
  }

  void update() {
    // Move and bounce
    x += speedX;
    y += speedY;
    if (x < 0 || x > width) speedX *= -1;
    if (y < 0 || y > height) speedY *= -1;

    // Fade out slowly
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
        vertex(x + cos(radians(i * 30)) * random(size / 2, size),
               y + sin(radians(i * 30)) * random(size / 2, size));
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
