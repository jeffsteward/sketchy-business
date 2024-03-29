class Ink {
  
  color fill;
  PGraphics inkSpace;
  boolean isDrawing = false;
  boolean isErasing = false;
  
  float transparency = 0.0;
  float weight = 0.0;

  int penMode = 0;
  
  Ink() {
    inkSpace = createGraphics(width, height);
    fill = color(0);
  }
  
  void clear() {
    inkSpace.beginDraw();
    inkSpace.clear();
    inkSpace.endDraw();
  }
  
  void startDrawing() {
    isDrawing = true;
  }
  
  void stopDrawing() {
    isDrawing = false;
  }
  
  void startErasing() {
    isErasing = true;
  }
  
  void stopErasing() {
    isErasing = false;
  }
  
  boolean isDrawing() {
    return isDrawing;
  }
  
  boolean isErasing() {
    return isErasing;
  }

  void liftPen() {
    stopDrawing();
    stopErasing();
  }
  
  void setTransparency(float t) {
    transparency = t;
  }

  void setWeight(float w) {
    weight = w;
  }

  void setColor(color c) {
    fill = c;
  }
  
  void update() {
    if (mousePressed && (isDrawing || isErasing)) {
      inkSpace.beginDraw();
      PVector was = new PVector(pmouseX, pmouseY);
      float d = abs(was.dist(new PVector(mouseX, mouseY)));
      
      if (isDrawing) {
        inkSpace.blendMode(BLEND);
        inkSpace.stroke(fill, d*transparency); // 0.8
      }
      else if (isErasing) {
        inkSpace.blendMode(REPLACE);
        inkSpace.stroke(0,0,0, d*transparency); // 0.2
      }
      
      inkSpace.strokeCap(SQUARE);
      inkSpace.strokeWeight(d*weight); // 0.2
      inkSpace.line(mouseX, mouseY, pmouseX, pmouseY);    
      inkSpace.endDraw();
    }      
  }
  
  void display() {
    image(inkSpace, 0, 0);
  }
}
