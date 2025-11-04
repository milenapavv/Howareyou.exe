// HOWAREYOU.EXE by Milena Pavlovic
// This sketch is an interactive, generative art experiment that allows users to create expressive visuals through keyboard input.
// Each key press spawns colourful, animated shapes that moves and fades forming unique, dynamic abstract compositions.

// Controls:
//    A - Circle burst
//    S - Rectangle scatter
//    D - Line explosion
//    F - Triangle cluster
//    G - Abstract blob
//    H - Gradient orb
//    SPACE - Clear the screen
//    Any other key - Random surprise

ArrayList<Shape> shapes;   // Dynamic list to store all active shapes
color bg = color(20, 20, 30);   // Dark background for visual contrast

// SETUP: runs once at program start

void setup() {
  size(1500, 800);      // Define canvas dimensions
  background(bg);       // Fill with initial background colour
  shapes = new ArrayList<Shape>(); // Initialise shape storage
  noStroke();           // Disable outlines for cleaner visuals
  frameRate(60);        // Smooth animation speed
}

// DRAW: continuously loops, updates and renders all shapes

void draw() {
  // Optional semi-transparent overlay to create trailing fade effect.
  // Leaving this commented out gives a more permanent paint feeling.
  // fill(20, 20, 30, 20); 
  // rect(-1, -1, width + 2, height + 2);

  for (int i = shapes.size() - 1; i >= 0; i--) {
    Shape s = shapes.get(i);
    s.update();   // Move + fade
    s.display();  // Draw shape

    // Remove shapes once they are fully faded
    if (s.alpha <= 0) {
      shapes.remove(i);
    }
  }
}

// KEYPRESSED: listens for user input to generate new shapes

void keyPressed() {
  // Each key triggers a different generative behaviour
  if (key == 'a') {             // Circle burst
    for (int i = 0; i < 8; i++) shapes.add(new Shape("circle"));
  } 
  else if (key == 's') {        // Rectangle scatter
    for (int i = 0; i < 8; i++) shapes.add(new Shape("rect"));
  } 
  else if (key == 'd') {        // Line explosion
    for (int i = 0; i < 20; i++) shapes.add(new Shape("line"));
  } 
  else if (key == 'f') {        // Triangle cluster
    for (int i = 0; i < 6; i++) shapes.add(new Shape("triangle"));
  } 
  else if (key == 'g') {        // Abstract blob (organic shapes)
    shapes.add(new Shape("blob"));
  } 
  else if (key == 'h') {        // Gradient orb (layered fade)
    for (int i = 0; i < 4; i++) shapes.add(new Shape("orb"));
  } 
  else if (key == ' ') {        // SPACEBAR clears and resets
    background(bg);
    shapes.clear();
  } 
  else {                        // Random surprise generator
    String[] types = {"circle", "rect", "triangle", "line", "blob", "orb"};
    String t = types[int(random(types.length))]; // Choose random type
    for (int i = 0; i < 5; i++) shapes.add(new Shape(t));
  }
}

// SHAPE CLASS: blueprint for all visual elements

class Shape {
  String type;            // Shape type identifier
  float x, y;             // Position coordinates
  float size;             // Shape size (randomised)
  float speedX, speedY;   // Motion vector for animation
  float alpha;            // Transparency (used for fading)
  color c;                // Shape colour

  // Constructor: assigns randomised attributes for variation

  Shape(String t) {
    this.type = t;                     // Assign shape type
    this.x = random(width);            // Random X position
    this.y = random(height);           // Random Y position
    this.size = random(40, 140);       // Variable size for diversity
    this.speedX = random(-1.8, 1.8);   // Horizontal motion
    this.speedY = random(-1.8, 1.8);   // Vertical motion
    this.c = color(random(100, 255), random(100, 255), random(255), 255);
    this.alpha = 255;                  // Start fully opaque
  }

  // UPDATE: handles motion, edge bouncing, and fading

  void update() {
    x += speedX;
    y += speedY;

    // Bounce back at edges - keeps motion within frame
    if (x < 0 || x > width) speedX *= -1;
    if (y < 0 || y > height) speedY *= -1;

    // Gradual fade-out over time - adds a sense of life/death cycle
    alpha -= 1.1;
  }

  // ----------------------------------------------------------
  // DISPLAY: renders the shape based on its type
  // ----------------------------------------------------------
  void display() {
    noStroke();
    fill(c, alpha);  // Fill with current colour and transparency

    // Each shape type has its own aesthetic behaviour:
    if (type.equals("circle")) {
      ellipse(x, y, size, size);   // Simple circular shape
    } 
    else if (type.equals("rect")) {
      // Rotated rectangles for added variation
      pushMatrix();
      translate(x, y);
      rotate(radians(random(360)));
      rectMode(CENTER);
      rect(0, 0, size * 0.8, size * 0.8); 
      popMatrix();
    } 
    else if (type.equals("line")) {
      // Dynamic line segments with random orientation
      stroke(c, alpha);
      strokeWeight(random(1, 5));
      line(x, y, x + random(-80, 80), y + random(-80, 80));
      noStroke();
    } 
    else if (type.equals("triangle")) {
      // Freeform triangles for spiky, expressive energy
      triangle(
        x + random(-size, size), y + random(-size, size),
        x + random(-size, size), y + random(-size, size),
        x + random(-size, size), y + random(-size, size)
      );
    } 
    else if (type.equals("blob")) {
      // Irregular organic form - generated using vertices in a circle
      beginShape();
      for (int i = 0; i < 12; i++) {
        vertex(
          x + cos(radians(i * 30)) * random(size / 2, size),
          y + sin(radians(i * 30)) * random(size / 2, size)
        );
      }
      endShape(CLOSE);
    } 
    else if (type.equals("orb")) {
      // Multi-layered translucent circles  creates a glowing gradient effect
      noStroke();
      for (int i = 0; i < 12; i++) {
        fill(random(150, 255), random(100, 255), random(255), alpha / (i + 2));
        ellipse(x, y, size * (1.2 - i * 0.08), size * (1.2 - i * 0.08));
      }
    }
  }
}
