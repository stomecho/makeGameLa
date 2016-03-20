import gab.opencv.*;
import processing.video.*;
import java.awt.*;
Capture video;
void videoSetup(){
  video = new Capture(this, 640, 480);
  video.start();
}

void videoDraw(){
  if(videoMode) {
    if (video.available() == true) {
      video.read();
      int w = 64*4;
      int h = 48*4;
      //patterns[7] = new picture("video", true, imageCell(video.get(),64*4,48*4));
      paint(new picture("video", true, imageCell(video.get(),w,h)),int(map.length-w)/2,int(map[i].length-h)/2 );
    }
  }
}