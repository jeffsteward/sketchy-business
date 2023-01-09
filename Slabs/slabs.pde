ArrayList<Slab> slabs = new ArrayList<Slab>();

boolean animate = true;

void setup() {
    size(1700, 1000);
    rectMode(CENTER);
}

void mousePressed() {
    slabs.add(new Slab(mouseX, mouseY));
}

void keyPressed() {
    switch (key) {
    case 'a': 
      animate = !animate;
      break;
    case 'c': 
      slabs.clear();
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
}

class Slab {
    int xpos, ypos;
    PShape slab;

    Slab(int x, int y) {
        xpos = x;
        ypos = y;       
        
        create();
    }

    void create() {
        PVector ul, ur, ll, lr;
        PVector bl, br;

        ul = new PVector(0, 0);
        ur = PVector.add(ul, new PVector(random(ul.x+20, 420), random(ul.y+10, ul.y+80)));
        
        float slabWidth = ul.dist(ur);
        PVector tilt = PVector.sub(ur, ul);
        lr = PVector.add(ul, new PVector(ur.x - random(slabWidth*0.15, slabWidth*0.4), ur.y + random(tilt.y*1.25, tilt.y*2.25)));
  
        ll = PVector.sub(lr, ur);
        ll.add(ul);

        bl = new PVector(ul.x, ul.y);
        bl.add(0, abs(ll.y*2));
        br = new PVector(ur.x, ur.y);
        br.add(0, abs(ll.y*2));

        slab = createShape();
        slab.beginShape(QUAD);
        slab.fill(random(200,255));
        slab.stroke(0);
        slab.vertex(br.x, br.y);
        slab.vertex(bl.x, bl.y);
        slab.vertex(ll.x, ll.y);
        slab.vertex(lr.x, lr.y);
        
        slab.vertex(ll.x, ll.y);
        slab.vertex(lr.x, lr.y);        
        slab.vertex(ur.x, ur.y);
        slab.vertex(ul.x, ul.y);
        slab.translate(xpos, ypos);
        slab.endShape(CLOSE);
    }

    void display() {
        shape(slab);
    }
}
