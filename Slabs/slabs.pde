ArrayList<Slab> slabs = new ArrayList<Slab>();

Slab preview;

boolean animate = true;
boolean showPreview = true;
PVector click;

boolean showBoundingBoxes = false;

void setup() {
    size(1700, 1000);
    rectMode(CENTER);
}

void mousePressed() {
    click = new PVector(mouseX, mouseY);
}

void mouseReleased() {
    if (preview != null) {
      slabs.add(preview);
      preview = null;
    }
}

void mouseDragged() {
    preview = new Slab(int(click.x), int(click.y), mouseX, mouseY);
    preview.showBoundingBox(showBoundingBoxes);
}

void keyPressed() {
    switch (key) {
    case 'a': 
      animate = !animate;
      break;
    case 'b':
      showBoundingBoxes = !showBoundingBoxes;
      for (Slab s : slabs) {
        s.showBoundingBox(showBoundingBoxes);
      }
      break;      
    case 'c': 
      slabs.clear();
      break;
    case 'p':
      showPreview = !showPreview;
      break;
    case 's':
      save("output/frame" + frameCount + ".png");
    default:
      break;
  }
}

void draw() {
    background(100);
    
    noStroke();
    
    for (Slab s : slabs) {
      s.display(); //<>//
    };
    
    if (mousePressed) {
      if (showPreview && preview != null) {
        preview.display();
      } else {
        stroke(0);
        line(click.x, click.y, mouseX, mouseY);
      }
    }   
}

class Slab {
    PVector pos, pos2;
    PShape slab;
    
    int maxY = 0, maxX = 0, minY = 0, minX = 0;
    int xOffset = 0, yOffset = 0;

    boolean showBB = false;

    Slab(int x, int y, int x2, int y2) {
        pos = new PVector(x, y);
        pos2 = new PVector(x2, y2);
      
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

        float fill = random(200, 255);
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
   
    void showBoundingBox(boolean b) {
      showBB = b;
    }
   
    void update() {
    }
   
    void display() {
        slab.resetMatrix();
        slab.translate(pos.x, pos.y);
        shape(slab);
        
       if (showBB) {
         pushMatrix();
         translate(pos.x + xOffset, pos.y + yOffset);
         stroke(0);
         fill(0,0,0,0);
         rect(minX, minY, maxX, maxY);
         popMatrix();
       }        
    }
}
