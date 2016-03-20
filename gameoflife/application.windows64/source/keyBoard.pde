boolean run = false;

IntList keyPress = new IntList();
boolean typeMode = false;
boolean videoMode = false;
void keyBoard() {
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

void keyPressed() {
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
  
  if (keyCode==130) depthViewY+=0.02;
  if (keyCode==132) depthViewY-=0.02;
  if(depthViewY>0.4) depthViewY=0.4;
  if(depthViewY<0) depthViewY = 0;
  println(keyCode);
}

void keyReleased() {
  keyPress.removeValue(keyCode);
}

void mouseWheel(MouseEvent event) {
  ts /= pow(1.1, event.getCount());
  if (ts<0.1) ts=0.1;
  if (ts>60) ts = 60;
}