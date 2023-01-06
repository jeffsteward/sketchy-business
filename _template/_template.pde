boolean animate = true;

void setup() {
    size(1700, 1000);
    rectMode(CENTER);
}

void mousePressed() {
    
}

void keyPressed() {
    switch (key) {
    case 'a': 
      animate = !animate;
      break;
    case 'c': 
      // do something here
      break;
    case 's':
      save("output/frame" + frameCount + ".png");
    default:
      break;
  }
}

void draw() {
    background(100);
}