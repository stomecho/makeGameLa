GuimPlat plat = new GuimPlat(10, 10, 400, 400); //<>//
GuimMouseArg mouseArgs;
void setup() {
  size(1000, 600);
  for (int i=10; i<350; i+=40) {
    GuimPlat p = new GuimBtn("say hi No."+i,10, i, 100, 30);

    p.clickEvent.OnEventDo(new GuimEvent() {
      public void run(IGuim sender, GuimArg e) {
        println("hi");
      }
    }
    );

    plat.items.add(p);
  }

  mouseArgs = new GuimMouseArg(mouseX, mouseY, mousePressed);
}

void draw() {

  mouseArgs.set(mouseX, mouseY, mousePressed);
  plat.DrawEvent(this.g);
  plat.mouseEvent.process(plat, mouseArgs);
  mouseArgs.end();
}