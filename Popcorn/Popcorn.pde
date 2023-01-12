import java.util.Random;

ArrayList<Cloud> clouds = new ArrayList<Cloud>();

PVector click;

boolean animate = true;

void setup() {
  size(1700, 1000);
  rectMode(CENTER);
  noStroke();
}

void draw() {
  background(100); 
  
  for (Cloud c : clouds) {
    if (animate) {
      c.update();
    }
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
  
  clouds.add(new Cloud(int(click.x), int(click.y), int(random(100, 200)), int(d))); 
}

void keyPressed() {
    switch (key) {
    case 'a': 
      animate = !animate;
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
  
   Cloud(int x, int y, int d, int s) {
      xpos = x;
      ypos = y;
      density = d;
      size = s*2;
      createCloud();
   }
   
   void createCloud() {
      segments = new PShape[density];

      segments[0] = createShape(ELLIPSE, 0, 0, size, size); 
      segments[0].translate(xpos, ypos);
      segments[0].setStroke(fill);
      segments[0].setFill(color(fill + random(-5,5)));
      
      int angle;
      int x, y;
      int s = size/2;
      for (int i=1;i<density;i++) {
         angle = int(random(0, 360));
         s = abs(s - i*2);
         x = xpos + int(cos(angle)*(s+int(random(-5,25))));
         y = ypos + int(sin(angle)*(s+int(random(-5,5))));
         
         segments[i] = createShape(ELLIPSE, 0, 0, s, s); 
         segments[i].translate(x, y);
         segments[i].setStroke(fill);
         segments[i].setFill(color(fill + random(-3,3)));
      }     
      
      ShuffleSegments();      
   }
   
   void update() {
     float s;
     
     for (int i = 0; i < segments.length; i++) {
       s = random(0.99, 1.01);
       segments[i].scale(s);
     }
   }
   
   void display() {
     noStroke();
     
     for (int i=0; i<density; i++) {
        shape(segments[i]); 
     }
   }

   void ShuffleSegments() {
      Random rand = new Random();
        
      for (int i = 0; i < segments.length; i++) {
          int randomIndexToSwap = rand.nextInt(segments.length);
          PShape temp = segments[randomIndexToSwap];
          segments[randomIndexToSwap] = segments[i];
          segments[i] = temp;
        }
    }
}
