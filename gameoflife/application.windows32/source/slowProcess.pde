class work{
  work(){
  }
  void run(){
  }
}
class slowProcessor{
  int state = -1;
  ArrayList<work> works = new ArrayList();
  slowProcessor(){
  }
  void update(){
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
void doNow(){
  nowWork.run();
  sdone = true;
}