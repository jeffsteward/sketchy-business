import controlP5.*;

ArrayList<Cloud> clouds = new ArrayList<Cloud>();

ControlP5 cp5;

PVector click;
int colorMin = 0;
int colorMax = 255;

boolean showBoundingBoxes = false;

void setup() {
  size(1700, 1000);
  rectMode(CENTER);
  noStroke();
  
  PFont pfont = createFont("Arial", 20, true);
  ControlFont font = new ControlFont(pfont, 20);
  
  cp5 = new ControlP5(this);
  
  cp5.addRange("cloudColors")
             .setBroadcast(false) 
             .setFont(font)
             .setLabel("Color Range")
             .setPosition(50,50)
             .setSize(400,40)
             .setHandleSize(20)
             .setRange(0,255)
             .setRangeValues(50,100)
             .setBroadcast(true);  
}

void draw() {
  background(100);

  noStroke();

  for (Cloud c : clouds) {
    c.display();
  }
  
  if (mousePressed && !cp5.isMouseOver()) {
    stroke(0);
    line(click.x, click.y, mouseX, mouseY);
  }
}

void controlEvent(ControlEvent theControlEvent) {
  if(theControlEvent.isFrom("cloudColors")) {
    colorMin = int(theControlEvent.getController().getArrayValue(0));
    colorMax = int(theControlEvent.getController().getArrayValue(1));
  }
}

void mousePressed() {
  click = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  if (!cp5.isMouseOver()) {
    PVector release = new PVector(mouseX, mouseY);
    float d = abs(release.dist(click));
    
    Cloud c = new Cloud(int(click.x), int(click.y), int(random(5, 50)), int(d));
    c.showBoundingBox(showBoundingBoxes);
    clouds.add(c);
  }
}

void keyPressed() {
    switch (key) {
    case 'a': 
      // do something here
      break;
    case 'b':
      showBoundingBoxes = !showBoundingBoxes;
      for (Cloud c : clouds) {
        c.showBoundingBox(showBoundingBoxes);
      }
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
  int fill = int(random(colorMin,colorMax));
  int xpos, ypos;
  int density = 25;
  int size = 100;
  int spread = size/5;
  
  int maxY, maxX, minY, minX;
  int xOffset, yOffset;
  
  boolean showBB = false;
  
  PGraphics pg;
  
   Cloud(int x, int y, int d, int s) {
      xpos = x;
      ypos = y;
      density = d;
      size = s*2;
      spread = size/5;
      
      segements = new PShape[density];
      for (int i=0;i<density;i++) {
         segements[i] = createShape(ELLIPSE, 0, 0, size*random(0.4,0.7), size*random(0.4,0.7)); 
         segements[i].translate(random(-spread,spread), random(-spread,spread));
         segements[i].rotate(radians(random(-20,50)));
         segements[i].setStroke(fill);
         segements[i].setFill(color(fill + random(-5,5), 255));
      }
      
      _calculateBoundingBox();
   }
   
   void _calculateBoundingBox() {     
     int buffer = round(size*0.15);
     
     pg = createGraphics(size+buffer, size+buffer);
     pg.beginDraw();
     pg.background(255, 0, 0);
     pg.pushMatrix();
     pg.translate(pg.width/2, pg.height/2);
     for (int i=0; i<density; i++) {
       pg.shape(segements[i]); 
     }     
     pg.popMatrix();
     pg.endDraw();
     pg.loadPixels();

     maxY = _findBBBottom();
     maxX = _findBBRight();
     minX = _findBBLeft();
     minY = _findBBTop();     

     // since clouds are asymetrical
     // find the offset from center for the box
     xOffset = ((maxX - pg.width/2) - (pg.width/2 - minX))/2;
     yOffset = ((maxY - pg.height/2) - (pg.height/2 - minY))/2;

     maxX = maxX - minX;
     maxY = maxY - minY;
     minX = 0;
     minY = 0;
   }

   int _findBBBottom() {
     for (int y=pg.height-1; y>=0; y--) {
       for (int x=0; x<pg.width; x++) {
         if (pg.get(x, y) != -65536) {
           return y;
         }
       }
     }
     return 0;
   }
   
   int _findBBRight() {
     for (int x=pg.width-1; x>=0; x--) {
       for (int y=0; y<maxY; y++) {
         if (pg.get(x, y) != -65536) {
           return x;
         }
       }
     }
     return 0;     
   }
   
   int _findBBTop() {
     for (int y=0; y<maxY; y++) {
       for (int x=0; x<maxX; x++) {
         if (pg.get(x, y) != -65536) {
           return y;
         }       
       }
     }
     return 0;
   }
   
   int _findBBLeft() {
     for (int x=0; x<maxX; x++) {
       for (int y=0; y<maxY; y++) {
         if (pg.get(x, y) != -65536) {
           return x;
         }              
       }
     }
     return 0;
   }
   
   void showBoundingBox(boolean b) {
     showBB = b;
   }
   
   void display() {
     pushMatrix();

     translate(xpos, ypos);
     for (int i=0; i<density; i++) {
       shape(segements[i]); 
     }
      
     if (showBB) {
       stroke(0);
       fill(0,0,0,0);
       rect(minX+xOffset, minY+yOffset, maxX, maxY);
     }
     
     popMatrix();
   }
}
