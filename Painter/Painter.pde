import controlP5.*;

ArrayList<Stamp> stamps = new ArrayList<Stamp>();
Ink drawing;

ControlP5 cp5;

Stamp preview;

final float STAMP_CLOUD = 0.0;
final float STAMP_SLAB = 1.0;
float currentStamp = STAMP_CLOUD;

final float MODE_CREATE = 0.0;
final float MODE_ARRANGE = 1.0;
final float MODE_DRAW = 2.0;
final float MODE_ERASE = 3.0;
float currentMode = MODE_CREATE;

float backgroundColor = 100.0;
float colorVariation = 25.0;

float colorMin = 50.0;
float colorMax = 100.0;

color wheelColor;

boolean animate = false;
boolean isHudVisible = true;
boolean showPreview = true;
PVector click;
boolean showBoundingBoxes = false;

void setup() {
  //size(1700, 1000);
  fullScreen(2);
  rectMode(CENTER);
  noStroke();
  
  drawing = new Ink();
  
  PFont pfont = createFont("Arial", 20, true);
  ControlFont font = new ControlFont(pfont, 20);
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("backgroundColor")
             .setBroadcast(false) 
             .setFont(font)
             .setLabel("Background")
             .setPosition(220,10)
             .setSize(400,30)
             .setHandleSize(20)
             .setRange(0,255)
             .setDefaultValue(backgroundColor)
             .setBroadcast(true);  

  cp5.addSlider("colorVariation")
             .setBroadcast(false) 
             .setFont(font)
             .setLabel("Variation")
             .setPosition(220,50)
             .setSize(400,30)
             .setHandleSize(20)
             .setRange(0,100)
             .setDefaultValue(colorVariation)
             .setBroadcast(true);               
             
  cp5.addRange("stampColors")
             .setBroadcast(false) 
             .setFont(font)
             .setLabel("Color Range")
             .setPosition(220,90)
             .setSize(400,30)
             .setHandleSize(20)
             .setRange(0,255)
             .setRangeValues(colorMin,colorMax)
             .setBroadcast(true);  
 
   cp5.addButtonBar("currentStamp")
             .setBroadcast(false) 
             .setFont(font)
             .setPosition(220, 130)
             .setSize(400,30)
             .addItems(split("Cloud Slab", " "))
             .setDefaultValue(STAMP_CLOUD)
             .setBroadcast(true);               

   cp5.addButtonBar("currentMode")
             .setBroadcast(false) 
             .setFont(font)
             .setPosition(220, 170)
             .setSize(400,30)
             .addItems(split("Create Arrange Draw Erase", " "))
             .setDefaultValue(MODE_CREATE)
             .setBroadcast(true);  

  cp5.addColorWheel("colorWheel")
            .setPosition(10, 10)
            .setSize(200, 200)
            .setRGB(color(255, 255, 255))
            .setLabelVisible(false);             
   
}

void draw() {
  background(backgroundColor);

  noStroke();

  for (Stamp s : stamps) {
    if (mousePressed && s.isDragging()) {
      s.setPosition(new PVector(mouseX, mouseY));
    } else {
      s.stopDragging();
    }

    s.update();
    s.display();
  }
  
  
  if (currentMode == MODE_CREATE) {
    if (mousePressed && !cp5.isMouseOver()) {
      if (showPreview && preview != null) {
        preview.display();
      } 
      
      stroke(0);
      line(click.x, click.y, mouseX, mouseY);
    }
  }
  
  drawing.update();
  drawing.display();
}

void controlEvent(ControlEvent theControlEvent) {
  if(theControlEvent.isFrom("currentMode")) {
     if (currentMode == MODE_DRAW) { 
         drawing.stopErasing();  
         drawing.startDrawing();
     } else if (currentMode == MODE_ERASE) {
         drawing.stopDrawing();  
         drawing.startErasing();
     } else {
         drawing.liftPen();
     }    
  }
  
  //if(theControlEvent.isFrom("stampColors")) {
  //  colorMin = int(theControlEvent.getController().getArrayValue(0));
  //  colorMax = int(theControlEvent.getController().getArrayValue(1));
  //}

  if(theControlEvent.isFrom("colorWheel")) {
    wheelColor = cp5.get(ColorWheel.class,"colorWheel").getRGB();  
    drawing.setColor(color(wheelColor));
  }
}

void mouseMoved() {}

void mousePressed() {
  click = new PVector(mouseX, mouseY);
  
  if (currentMode == MODE_ARRANGE) {
    for (Stamp s : stamps) {
      if (s.isMouseOver()) {
        s.startDragging();
      }
    }
  } else if (currentMode == MODE_ERASE) {
    for (int i = stamps.size() - 1; i >= 0; i--) {
      Stamp s = stamps.get(i);
      if (s.isMouseOver()) {
        stamps.remove(i);
      }
    }      
  }
}

void mouseReleased() {
  if (!cp5.isMouseOver()) {
    if (currentMode == MODE_CREATE) {
      if (preview != null) {
        if (animate) {
          preview.startAnimating();
        }
        stamps.add(preview);
        preview = null;
      }
    } 
  }
}

void mouseDragged() {
  if (!cp5.isMouseOver()) {
    PVector release = new PVector(mouseX, mouseY);
    
    if (currentMode == MODE_CREATE) {
      float d = abs(release.dist(click));
      
      if (d > 0) {
        if (currentStamp == STAMP_CLOUD) {
            PVector diff = release.sub(click);
            preview = new Cloud(int(click.x), int(click.y), int(random(5, 50)), int(d), abs(int(diff.y)), color(wheelColor), int(colorVariation));
        } else {
            preview = new Slab(int(click.x), int(click.y), mouseX, mouseY, color(wheelColor), int(colorVariation));
        }
        preview.showBoundingBox(showBoundingBoxes);
      }
    } else if (currentMode == MODE_DRAW) {
        
    }      
  }
}

void keyPressed() {
    switch (key) {
    case 'a': 
      animate = !animate;
      for (Stamp s : stamps) {
        if (animate) {
          s.startAnimating();
        } else {
          s.stopAnimating();
        }
      }
      break;
    case 'b':
      showBoundingBoxes = !showBoundingBoxes;
      for (Stamp s : stamps) {
        s.showBoundingBox(showBoundingBoxes);
      }
      break;
    case 'c': 
      stamps.clear();
      drawing.clear();
      break;
    case 'd':
      drawing.startDrawing();
      break;
    case 'e':
      drawing.startErasing();
      break;
    case 'h':
      isHudVisible = !isHudVisible;
      cp5.setVisible(isHudVisible);
      break;
    case 'p':
      showPreview = !showPreview;
      break;
    case 'r':
      for (Stamp s : stamps) {
        s.setPosition(new PVector(random(0, width), random(0, height)));
      }
      break;
    case 's':
      save("output/frame" + frameCount + ".png");
    default:
      break;
  }
}
