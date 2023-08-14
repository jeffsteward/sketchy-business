class Cloud implements Stamp {
  PShape[] segments;
  
  color fill;
  int colorVariation;
  
  int xpos, ypos;
  int density = 25;
  int size = 100;
  int spreadX = size/5;
  int spreadY = size/5;
  
  int maxY, maxX, minY, minX;
  int xOffset, yOffset;
  
  boolean showBB = false;
  boolean isHit = false;
  boolean isDragging = false;
  boolean isAnimating = false;
  
  PGraphics pg;
  PGraphics pgBuffer;
  
   Cloud(int x, int y, int d, int r, int h, color c, int cv) {
      xpos = x;
      ypos = y;
      density = d;
      size = r*2;
      spreadX = size/5;
      spreadY = h/5;
      colorVariation = cv;
      
      fill = c;
      
      create();
      _calculateBoundingBox();
      //_fillBuffer();
   }
   
   void create() {
      segments = new PShape[density];
      for (int i=0;i<density;i++) {
         segments[i] = createShape(ELLIPSE, 0, 0, size*random(0.4,0.7), size*random(0.4,0.7)); 
         segments[i].translate(random(-spreadX,spreadX), random(-spreadY,spreadY));
         segments[i].rotate(radians(random(-20,50)));
         segments[i].setStroke(fill);
         int v = int(random(-colorVariation,colorVariation));
         segments[i].setFill(color(red(fill) + v, green(fill) + v, blue(fill) + v, 255));
      }
   }
   
   void _fillBuffer() {
     pgBuffer = createGraphics(maxX, maxY);
     pgBuffer.beginDraw();
     pgBuffer.background(255, 255, 255, 0);
     pgBuffer.pushMatrix();
     pgBuffer.translate(maxX/2-xOffset, maxY/2-yOffset);
     for (int i=0; i<density; i++) {
       pgBuffer.shape(segments[i]); 
     }     
     pgBuffer.popMatrix();
     pgBuffer.endDraw();
     
     // load the cloud as a raster
     pgBuffer.loadPixels();          
   }
   
   void _calculateBoundingBox() {     
     int buffer = round(size*0.15);

     // render the cloud to a graphics buffer
     pg = createGraphics(size+buffer, size+buffer);
     pg.beginDraw();
     pg.background(255, 0, 0);
     pg.pushMatrix();
     pg.translate(pg.width/2, pg.height/2);
     for (int i=0; i<density; i++) {
       pg.shape(segments[i]); 
     }     
     pg.popMatrix();
     pg.endDraw();
     
     // load the cloud as a raster
     pg.loadPixels();

     // use a scanline/sweepline technique 
     // to find the extents of the cloud
     maxY = _findBBBottom();
     maxX = _findBBRight();
     minX = _findBBLeft();
     minY = _findBBTop();     

     // since clouds are asymetrical
     // find the offset from center for the bounding box
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

   void setPosition(PVector p) {
     xpos = int(p.x);
     ypos = int(p.y);
   }
   
   void showBoundingBox(boolean b) {
     showBB = b;
   }
   
   boolean isMouseOver() {
     return isHit;
   }
   
   boolean isDragging() {
     return isDragging;
   }
   
   void updateHitStatus() {
     if (mouseX > xpos - (maxX/2) + xOffset && 
         mouseX < xpos + (maxX/2) + xOffset &&
         mouseY > ypos - (maxY/2) + yOffset &&
         mouseY < ypos + (maxY/2) + yOffset) {
       isHit = true;
     } else {
       isHit = false;
     } 
   }   
   
   void startDragging() {
     isDragging = true;
   }
   
   void stopDragging() {
     isDragging = false;
   }   

   boolean isAnimating() {
     return isAnimating;
   }
   
   void startAnimating() {
     isAnimating = true;
   }
   
   void stopAnimating() {
     isAnimating = false;
   }
   
   void update() {
     updateHitStatus();
     
     if (isAnimating) {
       xpos +=size/50;
     }
   }
   
   void display() {
     pushMatrix();
    
     //translate(xpos, ypos);
     //image(pgBuffer, -pgBuffer.width/2, -pgBuffer.height/2);
     
     translate(xpos, ypos);
     for (int i=0; i<density; i++) {
       shape(segments[i]); 
     }
      
     if (showBB || isHit) {
       if (showBB && isHit) {
         stroke(255);
       } else {
         stroke(0);
       }
       fill(0,0,0,0);
       rect(minX+xOffset, minY+yOffset, maxX, maxY);
     }
     
     popMatrix();
   }
}
