class Ink {
  
  color fill;
  PGraphics inkSpace;
  boolean isDrawing = false;
  
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
    //inkSpace.beginDraw();
  }
  
  void stopDrawing() {
    isDrawing = false;
    //inkSpace.endDraw();
  }
  
  boolean isDrawing() {
    return isDrawing;
  }
  
  void setColor(color c) {
    fill = c;
  }
  
  void update() {
    if (mousePressed && isDrawing) {
    inkSpace.beginDraw();
      PVector was = new PVector(pmouseX, pmouseY);
      float d = abs(was.dist(new PVector(mouseX, mouseY)));
      inkSpace.stroke(fill, d/4);
      inkSpace.strokeCap(SQUARE);
      inkSpace.strokeWeight(d);
      inkSpace.line(mouseX, mouseY, pmouseX, pmouseY);    
      inkSpace.endDraw();
    }      
  }
  
  void display() {
    image(inkSpace, 0, 0);
  }
}
