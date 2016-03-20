picture mainPattern;
picture[] patterns;
void pictureSetup(){
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
    new picture("video",true,new int[][]{{0}}),
  };
}

int[][] copy;
int select = 0;

int matx(int x, int y, int[] mat) {
  return x*mat[0]+ y*mat[1];
}
int maty(int x, int y, int[] mat) {
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
  JSONObject toJson(){
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
  
  picture byJson(JSONObject js){
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