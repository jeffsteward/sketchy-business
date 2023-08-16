interface Stamp {
  void create();
  void setPosition(PVector p);
  void showBoundingBox(boolean b);
  boolean isMouseOver();
  boolean isDragging();
  boolean isAnimating();
  String type();
  void startAnimating();
  void stopAnimating();
  void startDragging();
  void stopDragging();
  void update();
  void display();
}
