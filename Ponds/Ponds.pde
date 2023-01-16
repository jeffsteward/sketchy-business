import controlP5.*;

ArrayList<Cluster> clusters = new ArrayList<Cluster>();

ControlP5 cp5;

boolean animate = true;
float size = 250.0;
int offset = int(size/2);
int panelHeight = 100;

void setup() {
  size(1700, 1000, P2D);
  noCursor();
  rectMode(CENTER);

  PFont pfont = createFont("Arial", 20, true);
  ControlFont font = new ControlFont(pfont, 20);
  
  cp5 = new ControlP5(this);

  cp5.addSlider("size")
      .setBroadcast(false)
      .setPosition(25, 25)
      .setFont(font)
      .setHeight(35)
      .setWidth(200)
      .setRange(10, width/2)
      .setValue(250.0)
      .setBroadcast(true);

  cp5.addToggle("animate")
      .setBroadcast(false)
      .setPosition(350, 25)
      .setFont(font)
      .setLabelVisible(false)
      .setHeight(35)
      .setWidth(100)
      .setMode(ControlP5.SWITCH)
      .setBroadcast(true);  
  
  buildPonds();
}

void buildPonds() {
  int columns = int(width/size);
  int rows = int((height-panelHeight)/size);
  
  for (int i=0; i<rows; i++) {
    for (int j=0; j<columns; j++) {
      clusters.add(new Cluster(int(j*size + offset), int(i*size + offset), int(size)));
    }
  }  
}

void size(float s) {
  size = s;
  offset = int(size)/2;
  
  clusters.clear();
  buildPonds();
}

void draw() {
  background(100);
  
  pushMatrix();  
  translate(0, panelHeight);
  
  for (Cluster c : clusters) {
    if (animate) {
      c.update();
    }
    c.display();
  }
  
  popMatrix();
  
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
