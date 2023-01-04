ArrayList<Cluster> clusters = new ArrayList<Cluster>();

boolean animate = true;

void setup() {
  size(1700, 1000, P2D);
  noCursor();
  rectMode(CENTER);
}

void draw() {
  background(100);
  
  for (Cluster c : clusters) {
    if (animate) {
      c.update();
    }
    c.display();
  }
  
  stroke(0);
  fill(255);
  circle(mouseX, mouseY, 20);
}

void keyPressed() {
  switch (key) { //<>//
    case 'a': 
      animate = !animate;
      break;
    case 'c': 
      clusters.clear();
      break;
    default:
      break;
  }
}

void mousePressed() {
  clusters.add(new Cluster(mouseX, mouseY));
}

class Cluster {
  ArrayList<Marker> markers = new ArrayList<Marker>();
  int segments = round(random(1,26));
  int s = 10;
  
  Cluster(int x, int y) {
    for (int i=0; i<segments; i++) {
      markers.add(new Marker(x, y, s));
      s = s-int(sq(i+3));
    }
  }
  
  void update() {
    for (Marker m : markers) {
      m.update();
    }
  }
  
  void display() {
    for (Marker m : markers) {
      m.display();
    }
  }
}

class Marker {
  int xpos, ypos;
  float angle = 13;
  int size = 20;
  int fill = int(random(0,255));
 
  Marker(int x, int y, int s) {
    size = s;
    xpos = x;
    ypos = y;
  }
  
  void update() {
     angle = random(-2,5) + angle;
     size = int(random(-5,15)) + size;
  }
  
  void display() {
    fill(fill);
    stroke(255);
    pushMatrix();
    translate(xpos, ypos);
    rotate(radians(angle));
    //rect(0, 0, size, size);
    ellipse(0,0,size, size/0.9);
    popMatrix();
  }
}
