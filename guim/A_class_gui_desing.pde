class GuimBtn extends GuimPlat{
  String name;
  GuimBtn(String name, float x, float y, float w, float h){
    super(x,y,w,h);
    this.name = name;
     mouseEvent.OnEventDo(new GuimEvent() {
      public void run(IGuim sender, GuimArg e) {
        GuimPlat p = (GuimPlat)sender;
        GuimMouseArg me = (GuimMouseArg)e;
        if(p.focused) p.backColor = color(64);
        else p.backColor = color(0);
      }
    }
    );
  }
  void draw(PGraphics g){
    g.fill(backColor);
    g.rect(0, 0, s.x, s.y);
    g.textAlign(CENTER,CENTER);
    g.fill(foreColor);
    g.text(name, s.x*0.5, s.y*0.5);
  }
}