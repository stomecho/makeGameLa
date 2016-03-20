import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class gameoflife extends PApplet {

float cx, cy;
float ts = 2;
float s = 2;
int t=0;

int mx, my, msx, msy, mex, mey;
boolean press;
int sleepTime = 4;
boolean showSelect = false;
PImage howTo;
int howToLife = 200;

slowProcessor lifeChanger = new slowProcessor();
public void setup() {
  
  guimSetup();
  pictureSetup();
  //videoSetup();
  howTo = loadImage("/data/images/howto.png");
  noStroke();
  s = width / map.length ;
  reset();
  initGameOfLife();
  prelook = new boolean[map.length][map[0].length];
  lifeChanger.works.add(new work() {
    public void run() {
      updateGameOfLife();
    }
  }
  );

  updateGameOfLife();
  cx = 0;
  cy = 0;
}
boolean set = true;
public void draw() {
  s+=(ts-s)*0.2f;
  boolean stop =false;
  int x = recalcX(mouseX);
  int y = recalcY(mouseY);

  prelook = new boolean[map.length][map[0].length];
  if (ShowSaves) {
  } else if (typeMode) {
    char c = (mainChar+"").toLowerCase().charAt(0);
    if ('a'<=c&&c<='z') mainPattern = new picture("typeMode: "+mainChar, type[c-'a']);
  } else if (select==-1) mainPattern = new picture("copy", copy);
  else mainPattern = patterns[select];

  prepaint(mainPattern, x, y);

  if (mousePressed) {
    fillMode = mouseButton==LEFT;
    if (keyPress.hasValue(17)) {
      if (!press) {
        msx = x;
        msy = y;
      } else {
        mx = min(msx, x);
        my = min(msy, y);
        mex = max(msx, x);
        mey = max(msy, y);
      }
      showSelect = true;
    } else if (press && keyPress.hasValue(32)) {
      cx+=(pmouseX-mouseX)/s;
      cy+=(pmouseY-mouseY)/s;
    } else if (! keyPress.hasValue(32)) {
      showSelect = false;
      if (xyOk(x, y))
        if ((select==0&&!typeMode)||!press) {
          paint(mainPattern, x, y);
        }
    }
  }
  press = mousePressed;

  if (!stop) {
    //tracker();
    if (run) {
      for (int i=0; i<1; i++)
      updateGameOfLife();
        //lifeChanger.update();
    }
  }
  noStroke();
  keyBoard();
  render();


  howToLife--;

  if (howToLife>0) {
    if (howToLife>20)howToY += (height-768*width/1920-howToY)*0.2f;
    else  howToY += (height-howToY)*0.2f;
    image(howTo, 0, howToY, width, 768*width/1920);
  }
  t++;
  //videoDraw();
}

int howToY = height;

public void reset() {
  int w = map.length;
  int h = map[0].length;
  for (int i=0; i<w; i++) for (int j=0; j<h; j++) map[i][j] = random(1)<0.0f;
  /*
  for (int i=0; i<10; i++)
   paint(glider2, (int)random(10, 500), (int)random(10, 500));*/
}

public boolean xyOk(int x, int y) {
  return 0<=x && x<map.length && 0<=y && y<map[0].length;
}
GuimPlat plat;
GuimMouseArg mouseArgs;
String SaveSelect = "";
boolean ShowSaves = false;

picture[] SavePics;

public void loadSaves(){
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

public void guimSetup() {
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

public void guimDraw(){
  
  if(ShowSaves) plat.p.x += (width-300-plat.p.x)*0.1f;
  else plat.p.x += (width-plat.p.x)*0.1f;
  
  mouseArgs.set(mouseX, mouseY, mousePressed);
  plat.DrawEvent(this.g);
  plat.mouseEvent.process(plat, mouseArgs);
  mouseArgs.end();
}


class singleLifeBlock {
  int ex, ey;
  int sx, sy;
  int x, y, w, h;
  singleLifeBlock(int x, int y, int w, int h) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
  }

  public void sum() {
    ex=x;
    ey=y;
    sx=w+x;
    sy=h+y;
    for (int i=x; i<x+w; i++) for (int j=y; j<y+h; j++) {
      if(sx<i&&i<ex&&sy<j&&j<ey){
        i=ex;
        j=ey;
      }
      if (!map[i][j]) continue;
      if (i>ex)ex=i;
      if (i<sx)sx=i;
      if (j>ey)ey=j;
      if (j<sy)sy=j;
    }
    if (sx>0)sx--;
    if (sy>0)sy--;
    if (ex<map.length-1)ex++;
    if (ey<map[0].length-1)ey++;
    
    for (int i=sx; i<=ex; i++) for (int j=sy; j<=ey; j++) {
      if(done[i][j]==1) continue;
      done[i][j] = 1;
      
      if (!xyOk(i,j)) continue;
      if (!map[i][j]) continue;
      for (int xx=i-1; xx<=i+1; xx++)for (int yy=j-1; yy<=j+1; yy++) {
        if (xx==i&&yy==j) continue;
        if (xyOk(xx,yy)) {
          if (sleep[xx][yy]>=sleepTime) continue;
          n[xx][yy]++;
        }
      }
    }
  }

  public void update() {
    
    for (int i=sx; i<=ex; i++) for (int j=sy; j<=ey; j++) {
      boolean changed = false;
      
      if (sleep[i][j]>=sleepTime) continue;
      if (done[i][j]==2) continue;

      done[i][j] = 2;

      //game rule

      switch(n[i][j]) {
      case 2: 
        break;
      case 3: 
        if (!map[i][j]) changed=true; 
        map[i][j] = true; 
        break;
      default: 
        if (map[i][j])changed=true; 
        map[i][j] = false; 
        break;
      }

      /*
      if(map[i][j]){
       if(!( 2<=n[i][j] && n[i][j]<=3 )){
       map[i][j] = false;
       changed = true;
       }
       }else if(n[i][j]==3) {
       map[i][j] = true;
       changed = true;
       }*/


      if (changed)sleep[i][j] = 0;
      else if (sleep[i][j]<=sleepTime)sleep[i][j] ++;

      if (changed)
        for (int xx=i-1; xx<=i+1; xx++)for (int yy=j-1; yy<=j+1; yy++) {
          if (0<=xx&&xx<n.length&&0<=yy&&yy<n[0].length) {
            sleep[xx][yy] = 0;
          }
        }
    }
    
  }
  
  public void showGrid(){
    pushStyle();
     noFill();
     
     stroke(0,255,0); //green line
     //rect(x*s,y*s,(w)*s,(h)*s);
     
     //stroke(255,0,0); //red line
     if(sx<=ex&&sy<=ey)
     rect(sx*s,sy*s,(ex-sx+1)*s,(ey-sy+1)*s);
     
     popStyle();
  }
}
int[][] mats = new int[][]{
  {0, 1, 1, 0}, 
  {1, 0, 0, -1}, 
  {0, -1, -1, 0}, 
  {-1, 0, 0, 1}, 
};
int dir = 0;
boolean fillMode = true;
public void paint(picture p, int x, int y) {
  map = paint(map, p, x, y, true, p.solid);
}
public void prepaint(picture p, int x, int y) {
  prelook = paint(prelook, p, x, y, false, false);
}

public boolean[][] paint(boolean[][] map, picture p, int x, int y, boolean setSleep, boolean mode) {
  if (p==null) return map;
  int[][] image = p.data;
  if (image==null) return map;
  for (int i=0; i<image.length; i++) {
    for (int j=0; j<image[0].length; j++) {
      int nx = matx(i, j, mats[dir])+x;
      int ny = maty(i, j, mats[dir])+y;
      if (0<=nx&&nx<map.length&&0<=ny&&ny<map[0].length) {
        if (image[i][j]==0) continue;
        map[nx][ny] = fillMode || !setSleep;
        if(mode) n[nx][ny]=2;
        if(setSleep)
        for (int xx=nx-1; xx<=nx+1; xx++)for (int yy=ny-1; yy<=ny+1; yy++) {
          if (xyOk(xx, yy)) {
            if (sleep!=null)sleep[xx][yy] = mode?sleepTime:0;
          }
        }
      }
    }
  }
  return map;
}


/*
void prepaint(picture p, int x, int y) {
  if (p==null) return;
  int[][] image = p.data;
  if (image==null) return;
  for (int i=0; i<image.length; i++) {
    for (int j=0; j<image[0].length; j++) {
      int nx = matx(i, j, mats[dir])+x;
      int ny = maty(i, j, mats[dir])+y;
      if (xyOk(nx, ny))
        prelook[nx][ny] = image[i][j]==1;
    }
  }
}*/
boolean[][] map = new boolean[500][300];
boolean[][] prelook = new boolean[500][300];

int[][] sleep;
int[][] done;
int[][] ex, ey;
int[][] sx, sy;
int[][] n;
int b = 50;

ArrayList<singleLifeBlock> blocks = new ArrayList<singleLifeBlock>();
public void initGameOfLife(){
  int w = map.length;
  int h = map[0].length;
  sleep = new int[w][h];
  n = new int[w][h];
  for (int i=0; i<w; i+=b) for (int j=0; j<h; j+=b){
    blocks.add(new singleLifeBlock(i, j, min(b+i, w)-i, min(b+j, h)-j));
  }
}
public void updateGameOfLife() {
  int w = map.length;
  int h = map[0].length;
  
  for (int i=0; i<w; i++) for (int j=0; j<h; j++){
    if(sleep[i][j]<sleepTime) n[i][j] = 0;
  }
  done = new int[w][h];
  
  boolean[][] next = new boolean[w][h];
  
 
  
  for(singleLifeBlock sb : blocks) sb.sum();
  /*
  fill(0);
  for (int i=0; i<w; i++) for (int j=0; j<h; j++) text(n[i][j], i*s+s*0.5,j*s+s*0.5);*/
  for(singleLifeBlock sb : blocks) sb.update();
  
  if(t%100==0)System.gc();
}
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
  public void draw(PGraphics g) {
    g.stroke(foreColor);
    g.fill(backColor);
    g.rect(0, 0, s.x, s.y);
    g.textAlign(CENTER, CENTER);
    g.fill(foreColor);
    g.text(name, s.x*0.5f, s.y*0.5f);
  }
}
class GuimArg {
  GuimArg() {
  }
  public void set() {
  }
  public GuimArg no() {
    return null;
  }
  public void end() {
  }
}

class GuimEventHandle {
  ArrayList<GuimEvent> events = new ArrayList<GuimEvent>();
  GuimEventHandle() {
  }
  public boolean process(IGuim sender, GuimArg e) {
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
  public boolean checkIf(IGuim sender, GuimArg e) {
    return false;
  }
  public void handle(IGuim sender, GuimArg e) {
  }
  public void OnEventDo(GuimEvent e) {
    events.add(e);
  }
}

class GuimEvent {
  GuimEvent() {
  }
  public void run(IGuim sender, GuimArg e) {
  }
}
class GuimPlat implements IGuim {
  PVector p;
  PVector s;
  ArrayList<GuimPlat> items = new ArrayList<GuimPlat>();
  int foreColor = color(255);
  int backColor = color(0);
  int specColor = color(255, 0, 0);
  public void command(GuimEvent e) {
    e.run(this, null);
  }
  public void allCommand(GuimEvent e) {
    command(e);
    for (GuimPlat item : items) item.allCommand(e);
  }
  GuimPlat(float x, float y, float w, float h) {
    p = new PVector(x, y);
    s = new PVector(w, h);
  }
  public void DrawEvent(PGraphics g) {
    g.pushMatrix();
    g.pushStyle();
    g.translate(p.x, p.y);
    draw(g);
    g.popStyle();
    for (GuimPlat item : items) item.DrawEvent(g);
    g.popMatrix();
  }
  public void draw(PGraphics g) {
  }
  boolean mousePressed;
  boolean focused;
  boolean holding = false;
  GuimMouseEventHandle mouseEvent = new GuimMouseEventHandle() {
    public void handle(IGuim sender, GuimArg e) {
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
    public void handle(IGuim sender, GuimArg e) {
      focused = false;
    }
  };
}
public void requireFocus(GuimPlat item, GuimPlat form) {
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
  public boolean run(Object ... input) {
    return false;
  }
}
public boolean isBetween(float a, float b, float c) {
  return a<=b && b<c;
}

public boolean isBetween(PVector a, PVector b, PVector c) {
  return isBetween(a.x, b.x, c.x) & isBetween(a.y, b.y, c.y);
}
interface IGuim {
  public void draw(PGraphics g);
}
class GuimMouseArg extends GuimArg {
  float mouseX;
  float mouseY;
  boolean mousePressed;
  boolean preMousePressed;
  boolean floating = false;
  public void set(float mouseX, float mouseY, boolean mousePressed) {
    this.mouseX = mouseX;
    this.mouseY = mouseY;
    this.mousePressed = mousePressed;
  }
  GuimMouseArg(float mouseX, float mouseY, boolean mousePressed) {
    this.mouseX = mouseX;
    this.mouseY = mouseY;
    this.mousePressed = mousePressed;
  }
  public GuimMouseArg offset(PVector p) {
    GuimMouseArg e =  new GuimMouseArg(mouseX - p.x, mouseY - p.y, mousePressed);
    e.preMousePressed = preMousePressed;
    e.floating = floating;
    return e;
  }
  public GuimMouseArg no() {
    GuimMouseArg e = new GuimMouseArg(mouseX, mouseY, mousePressed);
    e.floating = true;
    return e;
  }
  public String toString() {
    return "X= " + mouseX + " Y= " + mouseY + " Pressed= " + mousePressed;
  }
  public void end() {
    this.preMousePressed = this.mousePressed;
  }
}

class GuimMouseEventHandle extends GuimEventHandle {
  GuimMouseEventHandle() {
  }
  public boolean checkIf(IGuim sender, GuimArg e) {
    GuimPlat p = (GuimPlat)sender;
    GuimMouseArg me = (GuimMouseArg)e;
    return !me.mousePressed || isBetween(p.p, new PVector(me.mouseX, me.mouseY), PVector.add(p.p, p.s));
  }
}
boolean run = false;

IntList keyPress = new IntList();
boolean typeMode = false;
boolean videoMode = false;
public void keyBoard() {
  if (!typeMode) {
    if (keyPress.hasValue('w'-32)) cy-=2; 
    if (keyPress.hasValue('s'-32)) cy+=2; 
    if (keyPress.hasValue('a'-32)) cx-=2; 
    if (keyPress.hasValue('d'-32)) cx+=2;
    if (keyPress.hasValue('h'-32)) howToLife=40;
  }
  /*
  for (int i : keyPress)print(i+" ");
   println();*/
}

public void keyPressed() {
  if (!keyPress.hasValue(keyCode)) keyPress.append(keyCode);
  if (typeMode) {
    mainChar = key;
  }else if(keyPress.hasValue('q'-32)) tracker();
  if (keyCode==10)run = !run;
  if (showSelect && (keyCode==127 || keyCode==147)) deleteSelect();
  if (showSelect && keyCode=='c'-32) copySelect(); 
  if (showSelect && keyCode=='x'-32) {
    copySelect(); 
    deleteSelect();
  }
  if (keyPress.hasValue(17) && keyCode == 't'-32) {
    mainChar = 'a';
    typeMode = !typeMode;
  }

  if (keyCode==LEFT) if (select>-1) select--;
  if (keyCode==RIGHT) if (select+1<patterns.length) select++;
  if (keyCode==DOWN) dir = (dir+1)%4;
  if (keyCode==UP) ShowSaves=!ShowSaves;
  if (!typeMode && keyCode=='o'-32) debug = !debug;
  if (!typeMode && keyCode=='p'-32) enable3D =!enable3D;
  if (!typeMode && keyCode=='v'-32) videoMode =!videoMode;
  
  if (keyCode==130) depthViewY+=0.02f;
  if (keyCode==132) depthViewY-=0.02f;
  if(depthViewY>0.4f) depthViewY=0.4f;
  if(depthViewY<0) depthViewY = 0;
  println(keyCode);
}

public void keyReleased() {
  keyPress.removeValue(keyCode);
}

public void mouseWheel(MouseEvent event) {
  ts /= pow(1.1f, event.getCount());
  if (ts<0.1f) ts=0.1f;
  if (ts>60) ts = 60;
}
public int[][] imageCell(PImage p, int w, int h){
  PGraphics g = createGraphics(w, h);
  g.noSmooth();
  g.beginDraw();
  g.image(p,0,0,w,h);
  g.endDraw();
  g.loadPixels();
  int[][] pat = new int[h][w];
  for(int i=0;i<h;i++) {
    for(int j=0;j<w;j++){
      pat[i][j] = red(g.pixels[i*w+j])>128?1:0;
    }
  }
  return pat;
}
picture mainPattern;
picture[] patterns;
public void pictureSetup(){
  patterns = new picture[]{
    new picture("pen", new int[][]{{1}}), 
    new picture("glider", new int[][]{
      {1, 0, 0}, 
      {1, 0, 1}, 
      {1, 1, 0}
    }), 
    new picture("glider2", new int[][]{
      {1, 1, 1, 1, 0}, 
      {1, 0, 0, 0, 1}, 
      {1, 0, 0, 0, 0}, 
      {0, 1, 0, 0, 1}, 
    }),
    new picture("shooter",imageCell(loadImage("/data/images/shooter.png"),36,9)),
    new picture("hackathon",true,imageCell(loadImage("/data/images/hackathon.png"),80,80)),
    new picture("yawmin",true,imageCell(loadImage("/data/images/yawmin.png"),80,80)),
    new picture("andyChen",true,imageCell(loadImage("/data/images/andyChen.png"),80,80)),
  };
}

int[][] copy;
int select = 0;

public int matx(int x, int y, int[] mat) {
  return x*mat[0]+ y*mat[1];
}
public int maty(int x, int y, int[] mat) {
  return x*mat[2]+ y*mat[3];
}



class picture {
  boolean solid = false;
  String name = "";
  int[][]data;
  picture(String name, int[][] data) {
    this.data=data;
    this.name=name;
  }
  picture(String name, boolean solid, int[][] data) {
    this.data=data;
    this.name=name;
    this.solid = solid;
  }
  public JSONObject toJson(){
    if(data==null) return null;
    JSONObject json = new JSONObject();
    JSONArray array = new JSONArray();
    for(int i=0;i<data.length;i++){
      JSONArray a = new JSONArray();
      for(int j=0;j<data[0].length;j++){
        println(i,j);
        a.append(data[i][j]);
      }
      array.append(a);
    }
    json.setString("name",name);
    json.setJSONArray("data",array);
    return json;
  }
  
  public picture byJson(JSONObject js){
    name = js.getString("name");
    JSONArray a=js.getJSONArray("data");
    int w = a.size();
    int h = a.getJSONArray(0).size();
    data = new int[w][h];
    for(int i=0;i<w;i++){
      for(int j=0;j<h;j++){
        data[i][j] = a.getJSONArray(i).getInt(j);
      }
    }
    return this;
  }
}
public int calcX(int x){
  return (int)((x-cx)*s+width*0.5f);
}

public int calcY(int y){
  return (int)((y-cy)*s+height*0.5f);
}

public int recalcX(int x){
  return (int)((x-width*0.5f)/s+cx+(map.length)*0.5f);
}

public int recalcY(int y){
  return (int)((y-height*0.5f)/s+cy+(map[0].length)*0.5f);
}
boolean debug = false;

float depthView = 0;
boolean enable3D = false;

float depthViewY = 0.1f;
public void render() {
  pushMatrix();
  //fill(0,192);
  //rect(0,0,width,height);
  translate(width*0.5f-cx*s, height*0.5f-cy*s);
  if (enable3D) depthView+=(10-depthView)*0.2f;
  else depthView+= (0-depthView)*0.2f;

  if (depthView>=0.1f) {
    
    rotateX(depthView*depthViewY);
    rotateZ(depthView*0.02f+depthView*cos(t*0.01f)*0.1f);
  }
  translate(-s*map.length*0.5f, -s*map[0].length*0.5f);
  background(0);
  
  for (int i=0; i<map.length; i++) for (int j=0; j<map[0].length; j++) {
    noStroke();
    fill(255);

    if (map[i][j]) {
      pushMatrix();
      if (sleep[i][j]>=sleepTime) fill(0, 0, 255);
      else if (sleep[i][j]>sleepTime*0.6f) fill(0, 255, 0);
      else if (sleep[i][j]>sleepTime*0.3f)  fill(255, 0, 0);
      else if (map[i][j]) fill(255);

      if (showSelect && mx<=i&&i<=mex && my<=j && j<=mey) fill(255, 0, 0);
      
      if (depthView>=0.5f) {
        translate(0, 0, n[i][j]*depthView*s);
        stroke(255);
        if (i%4==0&&j%4==0)
          line(i*s+s*0.5f, j*s+s*0.5f, 0, i*s+s*0.5f, j*s+s*0.5f, -sleep[i][j]*depthView*s);
      }
      noStroke();
      rect(i*s, j*s, s, s);

      popMatrix();
    }

    if (prelook[i][j]) {
      fill(0, 64);
      stroke(255);
      rect(i*s, j*s, s, s);
    }
  }

  if (debug)for (singleLifeBlock b : blocks)b.showGrid();

  
  pushStyle();
  noFill();
  stroke(255, 0, 0);
  if (showSelect)rect(mx*s, my*s, mex*s-mx*s+s, mey*s-my*s+s, depthView);
  stroke(255);
  rect(0, 0, map.length*s, map[0].length*s);
  popStyle(); 
  popMatrix();
  guimDraw();
  
  fill(255);
  textSize(16);
  if (mainPattern!=null)
    text(mainPattern.name, mouseX-20, mouseY-20);
}

class work{
  work(){
  }
  public void run(){
  }
}
class slowProcessor{
  int state = -1;
  ArrayList<work> works = new ArrayList();
  slowProcessor(){
  }
  public void update(){
    if(sdone){
      state++;
      sdone=false;
      if(state>=works.size()) {
        state = 0;
      }
      nowWork = works.get(state);
      doNow();
      //thread("doNow");
    }
  }
}
work nowWork;
boolean sdone= true;
public void doNow(){
  nowWork.run();
  sdone = true;
}
public void deleteSelect(){
  for (int i=mx; i<=mex; i++) for (int j=my; j<=mey; j++) {
    if (0<=i&&i<n.length&&0<=j&&j<n[0].length){
      map[i][j] = false;
      sleep[i][j] = 0;
    }
  }
}

public void copySelect(){
  tracker();
  copy = new int[mey-my+1][mex-mx+1];
  for(int i=mx; i<=mex; i++) for (int j=my; j<=mey; j++) {
    if (xyOk(i,j)){
      copy[j-my][i-mx] = (map[i][j])?1:0;
    }
  }
}

public int[][] selection(){
  int[][] copy = new int[mey-my+1][mex-mx+1];
  for (int i=mx; i<=mex; i++) for (int j=my; j<=mey; j++) {
    if (0<=i&&i<n.length&&0<=j&&j<n[0].length){
      copy[j-my][i-mx] = (map[i][j])?1:0;
    }
  }
  return copy;
}

public void tracker(){
  int x = mx;
  int y = my;
  int w = mex-mx+1;
  int h = mey-my+1;
  int ex=x;
  int ey=y;
  int sx=w+x;
  int sy=h+y;
  for (int i=x; i<x+w; i++) for (int j=y; j<y+h; j++) {
    if (0<=i&&i<n.length&&0<=j&&j<n[0].length){
      if(sx<i&&i<ex&&sy<j&&j<ey){
        i=ex;
        j=ey;
      }
      if (!map[i][j]) continue;
      
      if (i>ex)ex=i;
      if (i<sx)sx=i;
      if (j>ey)ey=j;
      if (j<sy)sy=j;
    }
  }
  mx = min(sx,ex);
  my = min(sy,ey);
  mex = max(sx,ex);
  mey = max(sy,ey);
}
char mainChar = 'a';

int[][][] type = new int[][][]{
  {//A
    {1, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 1}, 
  }, 
  {//B
    {1, 1, 1, 1, 0}, 
    {1, 0, 0, 1, 0}, 
    {1, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 1}, 
  }, 
  {//C
    {1, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 0}, 
    {1, 0, 0, 0, 0}, 
    {1, 0, 0, 0, 0}, 
    {1, 1, 1, 1, 1}, 
  }, 
  {//D
    {1, 1, 1, 1, 0}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 0}, 
  }, 
  {//E
    {1, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 0}, 
    {1, 1, 1, 1, 0}, 
    {1, 0, 0, 0, 0}, 
    {1, 1, 1, 1, 1}, 
  }, 
  {//F
    {1, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 0}, 
    {1, 1, 1, 1, 0}, 
    {1, 0, 0, 0, 0}, 
    {1, 0, 0, 0, 0}, 
  }, 
  {//G
    {1, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 0}, 
    {1, 0, 0, 1, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 1}, 
  }, 
  {//H
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
  }, 
  {//I
    {1, 1, 1, 1, 1}, 
    {0, 0, 1, 0, 0}, 
    {0, 0, 1, 0, 0}, 
    {0, 0, 1, 0, 0}, 
    {1, 1, 1, 1, 1}, 
  }, 
  {//J
    {1, 1, 1, 1, 1}, 
    {0, 0, 0, 1, 0}, 
    {0, 0, 0, 1, 0}, 
    {1, 0, 0, 1, 0}, 
    {0, 1, 1, 0, 0}, 
  }, 
  {//K
    {1, 0, 0, 1, 0}, 
    {1, 0, 1, 0, 0}, 
    {1, 1, 1, 0, 0}, 
    {1, 0, 0, 1, 0}, 
    {1, 0, 0, 0, 1}, 
  }, 
  {//L
    {1, 0, 0, 0, 0}, 
    {1, 0, 0, 0, 0}, 
    {1, 0, 0, 0, 0}, 
    {1, 0, 0, 0, 0}, 
    {1, 1, 1, 1, 1}, 
  }, 
  {//M
    {1, 1, 1, 1, 1}, 
    {1, 0, 1, 0, 1}, 
    {1, 0, 1, 0, 1}, 
    {1, 0, 1, 0, 1}, 
    {1, 0, 0, 0, 1}, 
  }, 
  {//N
    {1, 0, 0, 0, 1}, 
    {1, 1, 0, 0, 1}, 
    {1, 0, 1, 0, 1}, 
    {1, 0, 0, 1, 1}, 
    {1, 0, 0, 0, 1}, 
  }, 
  {//O
    {0, 1, 1, 1, 0}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {0, 1, 1, 1, 0}, 
  }, 
  {//P
    {1, 1, 1, 1, 0}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 0}, 
    {1, 0, 0, 0, 0}, 
  }, 
  {//Q
    {0, 1, 1, 1, 0}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 1, 0, 1}, 
    {1, 0, 0, 1, 0}, 
    {0, 1, 1, 0, 1}, 
  }, 
  {//R
    {1, 1, 1, 1, 0}, 
    {1, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 0}, 
    {1, 0, 0, 1, 0}, 
    {1, 0, 0, 0, 1}, 
  }, 
  {//S
    {0, 1, 1, 1, 1}, 
    {1, 0, 0, 0, 0}, 
    {1, 1, 1, 1, 1}, 
    {0, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 0}, 
  }, 
  {//T
    {1, 1, 1, 1, 1}, 
    {0, 0, 1, 0, 0}, 
    {0, 0, 1, 0, 0}, 
    {0, 0, 1, 0, 0}, 
    {0, 0, 1, 0, 0}, 
  }, 
  {//U
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 1, 1, 1, 1}, 
  }, 
  {//V
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {0, 1, 0, 1, 0}, 
    {0, 0, 1, 0, 0}, 
  }, 
  {//W
    {1, 0, 0, 0, 1}, 
    {1, 0, 0, 0, 1}, 
    {1, 0, 1, 0, 1}, 
    {1, 0, 1, 0, 1}, 
    {0, 1, 0, 1, 0}, 
  }, 
  {//X
    {1, 0, 0, 0, 1}, 
    {0, 1, 0, 1, 0}, 
    {0, 0, 1, 0, 0}, 
    {0, 1, 0, 1, 0}, 
    {1, 0, 0, 0, 1}, 
  }, 
  {//Y
    {1, 0, 0, 0, 1}, 
    {0, 1, 0, 1, 0}, 
    {0, 0, 1, 0, 0}, 
    {0, 0, 1, 0, 0}, 
    {0, 0, 1, 0, 0}, 
  }, 
  {//Z
    {1, 1, 1, 1, 1}, 
    {0, 0, 0, 1, 0}, 
    {0, 0, 1, 0, 0}, 
    {0, 1, 0, 0, 0}, 
    {1, 1, 1, 1, 1}, 
  }
};
/*import gab.opencv.*;
import processing.video.*;
import java.awt.*;
Capture video;
OpenCV opencv;

PImage img;
Eye right,left;
float t=0,rx,ry;
float lx,ly,dist;
void videoSetup(){
  size(displayWidth,displayHeight,P3D);
  //orientation(LANDSCAPE);
  img = loadImage("face.png");
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}

int count=0;
void videoDraw(){
  opencv.loadImage(video);
  image(img,0,0,displayWidth,displayHeight);
}*/
  public void settings() {  size(displayWidth, displayHeight, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "gameoflife" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
