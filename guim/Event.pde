class GuimArg{
  GuimArg(){
  }
  void set(){
  }
  GuimArg no(){
    return null;
  }
  void end(){
  }
}

class GuimEventHandle{
  ArrayList<GuimEvent> events = new ArrayList<GuimEvent>();
  GuimEventHandle(){
  }
  boolean process(IGuim sender, GuimArg e){
    if(checkIf(sender, e)){
      handle(sender, e);
      for(GuimEvent event : events) event.run(sender, e);
      return true;
    }else{
      handle(sender, e.no());
      for(GuimEvent event : events) event.run(sender, e.no());
     
    }
    return false;
  }
  boolean checkIf(IGuim sender, GuimArg e){
    return false;
  }
  void handle(IGuim sender, GuimArg e){
  }
  void OnEventDo(GuimEvent e){
    events.add(e);
  }
}

class GuimEvent{
  GuimEvent(){
  }
  void run(IGuim sender, GuimArg e){
  }
}