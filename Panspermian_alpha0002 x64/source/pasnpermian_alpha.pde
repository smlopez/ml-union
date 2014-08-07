int scr_sz_x=1920, scr_sz_y=1080; //-CONFIG- Tamaño de la pantalla en las coordenadas X e Y
int scr_frameRate=30;  //-CONFIG- Frame por segundo
boolean scr_fullscr; //-CONFIG- Pantalla completa
PImage bg; //-MAPA- Imagén de fondo
//-INTRO----------------------------------------------------------
import ddf.minim.*;
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
void setup() {
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
boolean sketchFullScreen() {
  cargarConfig=new confLoader();
  cargarConf();
  return scr_fullscr;
}
void draw() {
  background(0);
  if (intro_state) intro();
  else image(bg, 0, 0);
}
void cargarConf() {

  cargarConfig.cargarConf();
  scr_sz_x=cargarConfig.scr_sz_x;
  scr_sz_y=cargarConfig.scr_sz_y;
  scr_fullscr=cargarConfig.scr_fullscr;
  scr_frameRate=cargarConfig.scr_frameRate;
  intro_state=cargarConfig.intro_state;
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
    if (frame<0) {      
      fill(#ffffff);
      textAlign(CENTER);
      textSize(24);
      text("PRESENTA", width/2, (height/2)+255);
    }
  } else intro_state=false;
}

