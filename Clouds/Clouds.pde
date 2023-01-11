ArrayList<Cloud> clouds = new ArrayList<Cloud>();

PVector click;

void setup() {
  size(1700, 1000);
  rectMode(CENTER);
  
  noStroke();
}

void draw() {
  background(100);

  for (Cloud c : clouds) {
    c.display();
  }
  
  if (mousePressed) {
    stroke(0);
    line(click.x, click.y, mouseX, mouseY);
  }
}

void mousePressed() {
  click = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  PVector release = new PVector(mouseX, mouseY);
  float d = abs(release.dist(click));
  
  clouds.add(new Cloud(int(click.x), int(click.y), int(random(5, 50)), int(d))); 
}

void keyPressed() {
    switch (key) {
    case 'a': 
      // do something here
      break;
    case 'c': 
      clouds.clear();
      break;
    case 's':
      save("output/frame" + frameCount + ".png");
    default:
      break;
  }
}


class Cloud {
  PShape[] segements;
  int fill = int(random(0,255));
  int xpos, ypos;
  int density = 25;
  int size = 100;
  int spread = size/5;
  
   Cloud(int x, int y, int d, int s) {
      xpos = x;
      ypos = y;
      density = d;
      size = s*2;
      spread = size/5;
      
      segements = new PShape[density];
      for (int i=0;i<density;i++) {
         segements[i] = createShape(ELLIPSE, 0, 0, size*random(0.4,0.7), size*random(0.4,0.7)); 
         segements[i].translate(xpos+random(-spread,spread), ypos+random(-spread,spread));
         segements[i].rotate(radians(random(-20,50)));
         segements[i].setStroke(fill);
         segements[i].setFill(color(fill + random(-5,5)));
      }
   }
   
   void display() {
     noStroke();
     
     for (int i=0; i<density; i++) {
        shape(segements[i]); 
     }
   }
}
