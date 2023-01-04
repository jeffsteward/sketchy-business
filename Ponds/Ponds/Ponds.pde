ArrayList<Cluster> clusters = new ArrayList<Cluster>();

boolean animate = true;
int maxSize = 250;
int offset = maxSize/2;

void setup() {
  size(1700, 1000, P2D);
  noCursor();
  rectMode(CENTER);
  
  buildPonds();
}

void buildPonds() {
  int columns = width/maxSize;
  int rows = height/maxSize;
  
  for (int i=0; i<rows; i++) {
    for (int j=0; j<columns; j++) {
      clusters.add(new Cluster((j*maxSize + offset), (i*maxSize + offset), maxSize));
    }
  }  
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
  switch (key) {
    case 'a': 
      animate = !animate;
      break;
    case 'c': 
      clusters.clear();
      buildPonds();
      break;
    default:
      break;
  }
}

void mousePressed() {
}

class Cluster {
  ArrayList<Marker> markers = new ArrayList<Marker>();
  int segments = round(random(1,20));
  int extents = 0;
  
  Cluster(int x, int y, int maxSize) {
    extents = maxSize;
    
    for (int i=0; i<segments; i++) {
      markers.add(new Marker(x, y, extents));
      extents = extents-int(i+3);
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
     size = int(random(-2,2)) + size;
  }
  
  void display() {
    fill(fill);
    stroke(255);
    pushMatrix();
    translate(xpos, ypos);
    rotate(radians(angle));
    ellipse(0,0,size, size*0.9);
    popMatrix();
  }
}
