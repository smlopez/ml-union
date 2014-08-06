/**
 * Explode 
 * by Daniel Shiffman. 
 * 
 * Mouse horizontal location controls breaking apart of image and 
 * Maps pixels from a 2D image into 3D space. Pixel brightness controls 
 * translation along z axis. 
 */

// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="eames.jpg"; */
import ddf.minim.*;
Animation animation1, animation2;
PImage bg, stop;
float xpos;
float ypos;
float drag = 30.0;
Minim minim;
AudioPlayer player;
PImage img, end;       // The source image
int cellsize = 2; // Dimensions of each cell in the grid
int columns, rows;   // Number of columns and rows in our system
long frame=0; // Current frame to show
int numFrames = 0;
int x_w=0, y_w=0;
int count=0;
boolean game=false;
Timer timer;
void setup() {
  //size(1280, 720, P3D); 
  size(displayWidth, displayHeight, P3D);
  img = loadImage("2.png");  // Load the image
  end = loadImage("end.png");
  bg= loadImage("bg.png");
  stop= loadImage("stop.png");
  columns = img.width / cellsize;  // Calculate # of columns
  rows = img.height / cellsize;  // Calculate # of rows
  frameRate(24);
  x_w=(displayWidth-500)/2;
  y_w=(displayHeight-485)/2;
  frame=displayWidth;
  numFrames=displayWidth;
  animation1 = new Animation(9);
  ypos = height-105;
  minim = new Minim(this); //Initiallice Minim
  player = minim.loadFile("mainTheme.mp3"); //Load the file and set at the player
  player.play(); //play the song
  timer=new Timer(10000);
  timer.start();
}
boolean sketchFullScreen() {
  return true;
}

void draw() {
  background(0); 
  count=millis(); 
  if (!game) {
    intro();
  } else {
    image(bg, 0, 0, displayWidth, displayHeight);
    image(stop, xpos, ypos);
    if (keyPressed&&keyCode==39) {
      background(0); 
      image(bg, 0, 0, displayWidth, displayHeight);
      animation1.display((xpos+=10), ypos);
    } else {
      image(stop, xpos, ypos);
    } 
    if (keyPressed&&keyCode==37) {
      background(0); 
      image(bg, 0, 0, displayWidth, displayHeight);
      animation1.display((xpos-=10), ypos);
    }
  }
}
void intro() {
  if (frame>10)            frame = (frame-12) % numFrames;
  if (frame<=10&&frame>0)  frame = (frame-1) % numFrames;
  if (frame<=0)            frame = (frame-1);

  if (!timer.isFinished()) { // Begin loop for columns

    for ( int i = 0; i < columns; i++) {
      // Begin loop for rows
      for ( int j = 0; j < rows; j++) {
        int x = i*cellsize + cellsize/2;  // x position
        int y = j*cellsize + cellsize/2;  // y position
        int loc = x + y*img.width;  // Pixel array location
        color c = img.pixels[loc];  // Grab the color
        // Calculate a z position as a function of mouseX and pixel brightness
        float z = (frame / float(width)*2) * brightness(img.pixels[loc]) - 20.0;
        if (frame<=0) { 
          z = (0 / float(width)*2) * brightness(img.pixels[loc]) - 20.0;
        }
        // Translate to the location, set fill and stroke, and draw the rect
        pushMatrix();
        translate(x + x_w, y + y_w, z);
        fill(c, 204);
        noStroke();
        rectMode(CENTER);
        rect(0, 0, cellsize, cellsize);
        popMatrix();
      }
    }
  }else game=true;
}

