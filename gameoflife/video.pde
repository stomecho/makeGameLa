import gab.opencv.*;
import processing.video.*;
import java.awt.*;
Capture video;
void videoSetup(){
  video = new Capture(this, 640, 480);
  video.start();
}

void videoDraw(){
  if(videoMode) paint(new picture("video", imageCell((PImage)video,64,48)),0,0);
}