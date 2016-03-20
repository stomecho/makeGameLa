float cx, cy;

float s = 2;
int t=0;

int mx, my, msx, msy, mex, mey;
boolean press;
int sleepTime = 4;
boolean showSelect = false;
PImage howTo;
int howToLife = 200;

slowProcessor lifeChanger = new slowProcessor();
void setup() {
  size(displayWidth, displayHeight, P3D);
  guimSetup();
  pictureSetup();
  howTo = loadImage("images/howto.png");
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
  cx = -width*0.5/s;
  cy = -height*0.5/s;
}
boolean set = true;
void draw() {
  
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
      cx-=(pmouseX-mouseX)/s;
      cy-=(pmouseY-mouseY)/s;
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
      noCursor();
      for (int i=0; i<1; i++)
      updateGameOfLife();
        //lifeChanger.update();
    } else cursor();
  }
  noStroke();
  keyBoard();
  render();


  howToLife--;

  if (howToLife>0) {
    if (howToLife>20)howToY += (height-768*width/1920-howToY)*0.1;
    else  howToY += (height-howToY)*0.1;
    image(howTo, 0, howToY, width, 768*width/1920);
  }
  t++;
}

int howToY = height;

void reset() {
  int w = map.length;
  int h = map[0].length;
  for (int i=0; i<w; i++) for (int j=0; j<h; j++) map[i][j] = random(1)<0;
  /*
  for (int i=0; i<10; i++)
   paint(glider2, (int)random(10, 500), (int)random(10, 500));*/
}

boolean xyOk(int x, int y) {
  return 0<=x&&x<map.length&&0<=y&&y<map[0].length;
}