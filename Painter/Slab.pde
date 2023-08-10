class Slab implements Stamp {
    PVector pos, pos2;
    PShape slab;
    
    int fill;
    
    int maxY = 0, maxX = 0, minY = 0, minX = 0;
    int xOffset = 0, yOffset = 0;

    boolean showBB = false;
    boolean isHit = false;
    boolean isDragging = false;
    boolean isAnimating = false;

    Slab(int x, int y, int x2, int y2, int c) {
        pos = new PVector(x, y);
        pos2 = new PVector(x2, y2);
        
        fill = c;
      
        create();
        _calculateBoundingBox();
    }

    void create() {
        PVector ul, ur, ll, lr;
        PVector bl, br;
        PShape upper, lower;

        ul = new PVector(0, 0);
        ur = PVector.sub(pos2, pos);
        
        float slabWidth = ul.dist(ur);
        PVector tilt = PVector.sub(ur, ul);
        lr = PVector.add(ul, new PVector(ur.x - random(slabWidth*0.15, slabWidth*0.4), ur.y + random(tilt.y*1.25, tilt.y*2.25)));
  
        ll = PVector.sub(lr, ur);
        ll.add(ul);

        bl = new PVector(ul.x, ul.y);
        bl.add(0, abs(ll.y*2));
        br = new PVector(ur.x, ur.y);
        br.add(0, abs(ll.y*2));

        upper = createShape();
        upper.beginShape(QUAD);
        upper.fill(fill);
        upper.stroke(0);
        upper.vertex(ll.x, ll.y);
        upper.vertex(lr.x, lr.y);        
        upper.vertex(ur.x, ur.y);
        upper.vertex(ul.x, ul.y);
        upper.endShape(CLOSE);

        lower = createShape();
        lower.beginShape(QUAD);
        lower.fill(random(fill-65,fill-55));
        lower.stroke(0);
        lower.vertex(br.x, br.y);
        lower.vertex(bl.x, bl.y);
        lower.vertex(ll.x, ll.y);
        lower.vertex(lr.x, lr.y);
        lower.endShape(CLOSE);
        
        slab = createShape(GROUP);
        slab.addChild(upper);
        slab.addChild(lower);
    }

    void _calculateBoundingBox() {
      for (int i = 0; i < slab.getChildCount(); i++) {
        for (int j = 0; j < slab.getChild(i).getVertexCount(); j++) {
          PVector v = slab.getChild(i).getVertex(j);
          if (v.x < minX) {
            minX = int(v.x);
          }
          if (v.y < minY) {
            minY = int(v.y);
          }
          if (v.x > maxX) {
            maxX = int(v.x);
          }
          if (v.y > maxY) {
            maxY = int(v.y);
          }
        }
      }
      
      int w = abs(minX) + abs(maxX);
      int h = abs(minY) + abs(maxY);

      xOffset = w/2 + minX;
      yOffset = h/2 + minY;

      maxX = w;
      minX = 0;
      maxY = h;
      minY = 0;
    }
   
    void setPosition(PVector p) {
     pos.x = int(p.x);
     pos.y = int(p.y);
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
     if (mouseX > pos.x - (maxX/2) + xOffset && 
         mouseX < pos.x + (maxX/2) + xOffset &&
         mouseY > pos.y - (maxY/2) + yOffset &&
         mouseY < pos.y + (maxY/2) + yOffset) {
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
        // do something
      }
    }
   
    void display() {
        slab.resetMatrix();
        slab.translate(pos.x, pos.y);
        shape(slab);
        
       if (showBB || isHit) {
         if (showBB && isHit) {
           stroke(255);
         } else {
           stroke(0);
         }         
         pushMatrix();
         translate(pos.x + xOffset, pos.y + yOffset);
         fill(0,0,0,0);
         rect(minX, minY, maxX, maxY);
         popMatrix();
       }        
    }
}
