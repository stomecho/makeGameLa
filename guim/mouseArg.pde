class GuimMouseArg extends GuimArg{
  float mouseX;
  float mouseY;
  boolean mousePressed;
  boolean preMousePressed;
  boolean floating = false;
  void set(float mouseX, float mouseY, boolean mousePressed){
    this.mouseX = mouseX;
    this.mouseY = mouseY;
    this.mousePressed = mousePressed;
  }
  GuimMouseArg(float mouseX, float mouseY, boolean mousePressed){
    this.mouseX = mouseX;
    this.mouseY = mouseY;
    this.mousePressed = mousePressed;
  }
  GuimMouseArg offset(PVector p){
    GuimMouseArg e =  new GuimMouseArg(mouseX - p.x, mouseY - p.y, mousePressed);
    e.preMousePressed = preMousePressed;
    e.floating = floating;
    return e;
  }
  GuimMouseArg no(){
    GuimMouseArg e = new GuimMouseArg(mouseX, mouseY, mousePressed);
    e.floating = true;
    return e;
  }
  String toString(){
    return "X= " + mouseX + " Y= " + mouseY + " Pressed= " + mousePressed;
  }
  void end(){
    this.preMousePressed = this.mousePressed;
  }
}

class GuimMouseEventHandle extends GuimEventHandle{
  GuimMouseEventHandle(){
  }
  boolean checkIf(IGuim sender, GuimArg e){
    GuimPlat p = (GuimPlat)sender;
    GuimMouseArg me = (GuimMouseArg)e;
    return !me.mousePressed || isBetween(p.p, new PVector(me.mouseX, me.mouseY), PVector.add(p.p, p.s));
  }
}