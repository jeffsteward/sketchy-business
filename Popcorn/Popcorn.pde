ArrayList<Cloud> clouds = new ArrayList<Cloud>();

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
}

void mousePressed() {
  clouds.add(new Cloud(mouseX, mouseY, int(random(100, 200)), int(random(20, 30)))); 
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
  PShape[] segments;
  int fill = int(random(0,255));
  int xpos, ypos;
  int density = 25;
  int size = 100;
  int spread = size/5;
  
   Cloud(int x, int y, int d, int s) {
      xpos = x;
      ypos = y;
      density = d;
      size = s;
      spread = size/5;
      
      createCloud();
   }
   
   void createCloud() {
      segments = new PShape[density];

      segments[0] = createShape(ELLIPSE, 0, 0, size*3, size*3); 
      segments[0].translate(xpos, ypos);
      segments[0].setFill(color(fill + random(-5,5)));
      
      int angle;
      int x, y;
      int s = size;
      for (int i=1;i<density;i++) {
         angle = int(random(0, 360));
         s = abs(s - i*2);
         x = xpos + int(cos(angle)*(s+int(random(-5,25))));
         y = ypos + int(sin(angle)*(s+int(random(-5,5))));
         
         segments[i] = createShape(ELLIPSE, 0, 0, s, s); 
         segments[i].translate(x, y);
         segments[i].setFill(color(fill + random(-3,3)));
      }     
   }
   
   void display() {
     noStroke();
     
     for (int i=0; i<density; i++) {
        shape(segments[i]); 
     }
   }
}
