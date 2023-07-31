ArrayList<Slab> slabs = new ArrayList<Slab>();

Slab preview;

boolean animate = true;
boolean showPreview = true;

PVector click;

void setup() {
    size(1700, 1000);
    rectMode(CENTER);
}

void mousePressed() {
    click = new PVector(mouseX, mouseY);
}

void mouseReleased() {
    slabs.add(preview);
}

void mouseDragged() {
    preview = new Slab(int(click.x), int(click.y), mouseX, mouseY);
}

void keyPressed() {
    switch (key) {
    case 'a': 
      animate = !animate;
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

    Slab(int x, int y, int x2, int y2) {
        pos = new PVector(x, y);
        pos2 = new PVector(x2, y2);
      
        create();
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

    void display() {
        slab.resetMatrix();
        slab.translate(pos.x, pos.y);
        shape(slab);
    }
}
