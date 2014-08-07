import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class pasnpermian_alpha extends PApplet {

int scr_sz_x=1920, scr_sz_y=1080; //-CONFIG- Tama\u00f1o de la pantalla en las coordenadas X e Y
int scr_frameRate=30;  //-CONFIG- Frame por segundo
boolean scr_fullscr; //-CONFIG- Pantalla completa
PImage bg; //-MAPA- Imag\u00e9n de fondo
//-INTRO----------------------------------------------------------

PImage img;       // The source image
int cellsize = 2; // Dimensions of each cell in the grid
int columns, rows;   // Number of columns and rows in our system
long frame=0; // Current frame to show
int numFrames = 0;
int x_w=0, y_w=0;
Timer timer;
Minim minim;
AudioPlayer player;
boolean intro_state=true;
//-INTRO----------------------------------------------------------
confLoader cargarConfig;
public void setup() {
  size(scr_sz_x, scr_sz_y, P3D);
  frameRate(scr_frameRate);
  bg = loadImage("bg.png");
  //-INTRO--------------------------------------------------------
  if (intro_state) { 
    img = loadImage("2.png");
    columns = img.width / cellsize;  // Calculate # of columns
    rows = img.height / cellsize;  // Calculate # of rows
    x_w=(displayWidth-500)/2;
    y_w=(displayHeight-485)/2;
    frame=displayWidth;
    numFrames=displayWidth;
    minim = new Minim(this); //Initiallice Minim
    player = minim.loadFile("mainTheme.mp3"); //Load the file and set at the player
    player.play();
    //play the song
    timer=new Timer(10000);
    timer.start();
  }
  //-INTRO---------------------------------------------------------
}
public boolean sketchFullScreen() {
  cargarConfig=new confLoader();
  cargarConf();
  return scr_fullscr;
}
public void draw() {
  background(0);
  if (intro_state) intro();
  else image(bg, 0, 0);
}
public void cargarConf() {

  cargarConfig.cargarConf();
  scr_sz_x=cargarConfig.scr_sz_x;
  scr_sz_y=cargarConfig.scr_sz_y;
  scr_fullscr=cargarConfig.scr_fullscr;
  scr_frameRate=cargarConfig.scr_frameRate;
  intro_state=cargarConfig.intro_state;
}
public void intro() {
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
        int c = img.pixels[loc];  // Grab the color
        // Calculate a z position as a function of mouseX and pixel brightness
        float z = (frame / PApplet.parseFloat(width)*2) * brightness(img.pixels[loc]) - 20.0f;
        if (frame<=0) { 
          z = (0 / PApplet.parseFloat(width)*2) * brightness(img.pixels[loc]) - 20.0f;
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
    if (frame<0) {      
      fill(0xffffffff);
      textAlign(CENTER);
      textSize(24);
      text("PRESENTA", width/2, (height/2)+255);
    }
  } else intro_state=false;
}

class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  // Starting the timer
  public void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  public boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}


class confLoader {
  int scr_sz_x=0, scr_sz_y=0; //-CONFIG- Tama\u00f1o de la pantalla en las coordenadas X e Y
  int scr_frameRate=0;  //-CONFIG- Frame por segundo
  boolean scr_fullscr = true; //-CONFIG- Pantalla completa
  boolean intro_state=true; //-CONFIG- Mostrar Intro
  XML xml;
public void confLoader(){}

  public void cargarConf() {
    xml = loadXML("config.conf");
    XML[] configs = xml.getChildren("param");
    scr_sz_x=configs[0].getInt("value");
    scr_sz_y=configs[1].getInt("value");
    scr_fullscr=PApplet.parseBoolean(configs[2].getString("value"));
    scr_frameRate=configs[3].getInt("value");
    intro_state=PApplet.parseBoolean(configs[4].getString("value"));
    //  println(configs[0].getInt("value"));
    //  println(configs[1].getInt("value"));
    //  println(boolean(configs[2].getContent("value")));
    //  println(configs[3].getInt("value"));
     
  }

  public void guardarConf(int conf, String valor) {
    xml = loadXML("config.conf");
    XML[] configs = xml.getChildren("param");
    configs[conf].setString("value", valor);
    saveXML(xml,"data/config.conf");
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "pasnpermian_alpha" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
