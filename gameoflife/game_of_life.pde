boolean[][] map = new boolean[300][300];
boolean[][] prelook = new boolean[300][300];

int[][] sleep;
int[][] done;
int[][] ex, ey;
int[][] sx, sy;
int[][] n;
int b = 60;

ArrayList<singleLifeBlock> blocks = new ArrayList<singleLifeBlock>();
void initGameOfLife(){
  int w = map.length;
  int h = map[0].length;
  sleep = new int[w][h];
  n = new int[w][h];
  for (int i=0; i<w; i+=b) for (int j=0; j<h; j+=b){
    blocks.add(new singleLifeBlock(i, j, min(b+i, w)-i, min(b+j, h)-j));
  }
}
void updateGameOfLife() {
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
}