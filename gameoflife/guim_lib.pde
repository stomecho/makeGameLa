class GuimBtn extends GuimPlat {
  String name;
  GuimBtn(String name, float x, float y, float w, float h) {
    super(x, y, w, h);
    this.name = name;
    mouseEvent.OnEventDo(new GuimEvent() {
      public void run(IGuim sender, GuimArg e) {
        GuimPlat p = (GuimPlat)sender;
        GuimMouseArg me = (GuimMouseArg)e;
        if (p.focused) p.backColor = color(64);
        else p.backColor = color(0);
      }
    }
    );
  }
  void draw(PGraphics g) {
    g.stroke(foreColor);
    g.fill(backColor);
    g.rect(0, 0, s.x, s.y);
    g.textAlign(CENTER, CENTER);
    g.fill(foreColor);
    g.text(name, s.x*0.5, s.y*0.5);
  }
}
class GuimArg {
  GuimArg() {
  }
  void set() {
  }
  GuimArg no() {
    return null;
  }
  void end() {
  }
}

class GuimEventHandle {
  ArrayList<GuimEvent> events = new ArrayList<GuimEvent>();
  GuimEventHandle() {
  }
  boolean process(IGuim sender, GuimArg e) {
    if (checkIf(sender, e)) {
      handle(sender, e);
      for (GuimEvent event : events) event.run(sender, e);
      return true;
    } else {
      handle(sender, e.no());
      for (GuimEvent event : events) event.run(sender, e.no());
    }
    return false;
  }
  boolean checkIf(IGuim sender, GuimArg e) {
    return false;
  }
  void handle(IGuim sender, GuimArg e) {
  }
  void OnEventDo(GuimEvent e) {
    events.add(e);
  }
}

class GuimEvent {
  GuimEvent() {
  }
  void run(IGuim sender, GuimArg e) {
  }
}
class GuimPlat implements IGuim {
  PVector p;
  PVector s;
  ArrayList<GuimPlat> items = new ArrayList<GuimPlat>();
  color foreColor = color(255);
  color backColor = color(0);
  color specColor = color(255, 0, 0);
  void command(GuimEvent e) {
    e.run(this, null);
  }
  void allCommand(GuimEvent e) {
    command(e);
    for (GuimPlat item : items) item.allCommand(e);
  }
  GuimPlat(float x, float y, float w, float h) {
    p = new PVector(x, y);
    s = new PVector(w, h);
  }
  void DrawEvent(PGraphics g) {
    g.pushMatrix();
    g.pushStyle();
    g.translate(p.x, p.y);
    draw(g);
    g.popStyle();
    for (GuimPlat item : items) item.DrawEvent(g);
    g.popMatrix();
  }
  void draw(PGraphics g) {
  }
  boolean mousePressed;
  boolean focused;
  boolean holding = false;
  GuimMouseEventHandle mouseEvent = new GuimMouseEventHandle() {
    void handle(IGuim sender, GuimArg e) {
      GuimMouseArg me = (GuimMouseArg)e;

      if (!me.mousePressed) holding = false;
      if (me.floating) focused = false;
      else {
        if (!me.preMousePressed&&me.mousePressed) {
          focused = true; 
          holding = true;
        }
        if (holding) focused = true;
        if (!me.mousePressed && focused) clickEvent.process(sender, e);
      }

      for (GuimPlat item : items) item.mouseEvent.process(item, me.offset(p));
    }
  };
  GuimEventHandle clickEvent =  new GuimEventHandle() {
    void handle(IGuim sender, GuimArg e) {
      focused = false;
    }
  };
}
void requireFocus(GuimPlat item, GuimPlat form) {
  form.allCommand(new GuimEvent() {
    public void run(IGuim sender, GuimArg e) {
      GuimPlat p = (GuimPlat)sender;
      p.focused = false;
    }
  }
  );
  item.focused = true;
}
class functionB {
  functionB() {
  }
  boolean run(Object ... input) {
    return false;
  }
}
boolean isBetween(float a, float b, float c) {
  return a<=b && b<c;
}

boolean isBetween(PVector a, PVector b, PVector c) {
  return isBetween(a.x, b.x, c.x) & isBetween(a.y, b.y, c.y);
}
interface IGuim {
  void draw(PGraphics g);
}
class GuimMouseArg extends GuimArg {
  float mouseX;
  float mouseY;
  boolean mousePressed;
  boolean preMousePressed;
  boolean floating = false;
  void set(float mouseX, float mouseY, boolean mousePressed) {
    this.mouseX = mouseX;
    this.mouseY = mouseY;
    this.mousePressed = mousePressed;
  }
  GuimMouseArg(float mouseX, float mouseY, boolean mousePressed) {
    this.mouseX = mouseX;
    this.mouseY = mouseY;
    this.mousePressed = mousePressed;
  }
  GuimMouseArg offset(PVector p) {
    GuimMouseArg e =  new GuimMouseArg(mouseX - p.x, mouseY - p.y, mousePressed);
    e.preMousePressed = preMousePressed;
    e.floating = floating;
    return e;
  }
  GuimMouseArg no() {
    GuimMouseArg e = new GuimMouseArg(mouseX, mouseY, mousePressed);
    e.floating = true;
    return e;
  }
  String toString() {
    return "X= " + mouseX + " Y= " + mouseY + " Pressed= " + mousePressed;
  }
  void end() {
    this.preMousePressed = this.mousePressed;
  }
}

class GuimMouseEventHandle extends GuimEventHandle {
  GuimMouseEventHandle() {
  }
  boolean checkIf(IGuim sender, GuimArg e) {
    GuimPlat p = (GuimPlat)sender;
    GuimMouseArg me = (GuimMouseArg)e;
    return !me.mousePressed || isBetween(p.p, new PVector(me.mouseX, me.mouseY), PVector.add(p.p, p.s));
  }
}