GuimPlat plat;
GuimMouseArg mouseArgs;
String SaveSelect = "";
boolean ShowSaves = false;

picture[] SavePics;

void loadSaves(){
  try{
  SavePics = new picture[]{
    new picture(null, null).byJson(loadJSONObject("/data/save1.json")),
    new picture(null, null).byJson(loadJSONObject("/data/save2.json")),
    new picture(null, null).byJson(loadJSONObject("/data/save3.json")),
    new picture(null, null).byJson(loadJSONObject("/data/save4.json")),
    new picture(null, null).byJson(loadJSONObject("/data/save5.json")),
    new picture(null, null).byJson(loadJSONObject("/data/save6.json")),
    new picture(null, null).byJson(loadJSONObject("/data/save7.json")),
    new picture(null, null).byJson(loadJSONObject("/data/save8.json")),
    new picture(null, null).byJson(loadJSONObject("/data/save9.json")),
    new picture(null, null).byJson(loadJSONObject("/data/save10.json")),
  };
  }catch(Exception e){
  }
}

void guimSetup() {
  plat = new GuimPlat(width, 20, 300, height-40);
  loadSaves();
  for(int i=1;i<=10;i++){
    GuimBtn btn = new GuimBtn("SAVE_"+i,10,i*40,200,30);
    btn.clickEvent.OnEventDo(new GuimEvent() {
      public void run(IGuim sender, GuimArg e) {
        SaveSelect = ((GuimBtn)sender).name;
        int n=0;
        for(char c : SaveSelect.toCharArray()){
          if('0'<=c&&c<='9'){
            n*=10;
            n+=c-'0';
          }
        }
        loadSaves();
        if(SavePics!=null&&SavePics.length>n-1)
        mainPattern = SavePics[n-1];
      }
    }
    );
    plat.items.add(btn);
    
    GuimBtn btnsave= new GuimBtn("save"+i,220,i*40,70,30);
    btnsave.clickEvent.OnEventDo(new GuimEvent() {
      public void run(IGuim sender, GuimArg e) {
        picture selection = new picture("test",selection());
        saveJSONObject(selection.toJson(),"/data/"+((GuimBtn)sender).name+".json");
        int n=0;
        for(char c : ((GuimBtn)sender).name.toCharArray()){
          if('0'<=c&&c<='9'){
            n*=10;
            n+=c-'0';
          }
        }
        SavePics[n-1] = selection;
      }
    }
    );
    plat.items.add(btnsave);
  }
  mouseArgs = new GuimMouseArg(mouseX, mouseY, mousePressed);
}

void guimDraw(){
  
  if(ShowSaves) plat.p.x += (width-300-plat.p.x)*0.1;
  else plat.p.x += (width-plat.p.x)*0.1;
  
  mouseArgs.set(mouseX, mouseY, mousePressed);
  plat.DrawEvent(this.g);
  plat.mouseEvent.process(plat, mouseArgs);
  mouseArgs.end();
}