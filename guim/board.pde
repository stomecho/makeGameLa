class GuimPlat implements IGuim{
  PVector p;
  PVector s;
  ArrayList<GuimPlat> items = new ArrayList<GuimPlat>();
  color foreColor = color(255);
  color backColor = color(0);
  color specColor = color(255,0,0);
  void command(GuimEvent e){
    e.run(this, null);
  }
  void allCommand(GuimEvent e){
    command(e);
    for(GuimPlat item : items) item.allCommand(e);
  }
  GuimPlat(float x, float y, float w, float h){
    p = new PVector(x,y);
    s = new PVector(w,h);
  }
  void DrawEvent(PGraphics g){
    g.pushMatrix();
    g.pushStyle();
    g.translate(p.x, p.y);
    draw(g);
    g.popStyle();
    for(GuimPlat item : items) item.DrawEvent(g);
    g.popMatrix();
  }
  void draw(PGraphics g){
  }
  boolean mousePressed;
  boolean focused;
  boolean holding = false;
  GuimMouseEventHandle mouseEvent = new GuimMouseEventHandle(){
    void handle(IGuim sender, GuimArg e){
      GuimMouseArg me = (GuimMouseArg)e;
      
      if(!me.mousePressed) holding = false;
      if(me.floating) focused = false;
      else {
        if(!me.preMousePressed&&me.mousePressed) {focused = true; holding = true;}
        if(holding) focused = true;
        if(!me.mousePressed && focused) clickEvent.process(sender, e);
      }
      
      for(GuimPlat item : items) item.mouseEvent.process(item, me.offset(p));
    }
  };
  GuimEventHandle clickEvent =  new GuimEventHandle(){
    void handle(IGuim sender, GuimArg e){
      focused = false;
    }
  };
}