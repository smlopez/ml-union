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

public class panspermian_alpha extends PApplet {

int scr_sz_x=1920, scr_sz_y=1080; //-CONFIG- Tama\u00f1o de la pantalla en las coordenadas X e Y
int scr_frameRate=30; //-CONFIG- Frame por segundo
boolean scr_fullscr; //-CONFIG- Pantalla completa
boolean aud_music_state=true, aud_gui_state=true; //-CONFIG- Activar m\u00fasica
float aud_music_volume=0; //-CONFIG- Valor del volumen
PImage bg; //-MAPA- Imag\u00e9n de fondo
int state=0; //-INTERNO- Posici\u00f3n del switch para cada estados
int redim=0;
int text_tam=0;
boolean resChg=false;
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
AudioOutput out;
boolean intro_state=true; //-CONFIG- Mostrar Intro
//-INTRO----------------------------------------------------------
//-MENU-----------------------------------------------------------
AudioSample menu_nav;
AudioSample menu_sel;
AudioSample menu_back;
PImage logo_menu;
int menu_index=0;
int menu_ini_index=0;
int menu_opc_index=0;
int menu_jugar_index=0;
HScrollbar hs1;
////-----OPCIONES-------------------------------------------------
String opc1="Resoluci\u00f3n";
String opc2="Pantalla Completa";
String opc3="Tasa de FPS";
String opc4="Mostrar introducci\u00f3n";
String opc5="M\u00fasica";
String opc6="Efectos de sonido";
String opc7="Volumen";
String opc8="Volver";
String opc1_value="";
String opc2_value="";
String opc3_value="";
String opc4_value="";
String opc5_value="";
String opc6_value="";
String opc7_value="";
String opc8_value="";
int [][] res;
int resCount=0;
int resPos=0;
////-----OPCIONES-------------------------------------------------
//-MENU-----------------------------------------------------------
confLoader cargarConfig;
public void setup() {
  size(scr_sz_x, scr_sz_y, P3D);
  frameRate(9);
  bg = loadImage("bg.png");
  //-INTRO--------------------------------------------------------
  if (intro_state) { 
    img = loadImage("2.png");
    columns = img.width / cellsize;  // Calculate # of columns
    rows = img.height / cellsize;  // Calculate # of rows
    x_w=(width-500)/2;
    y_w=(height-485)/2;
    frame=width;
    numFrames=width;
    //play the song
    timer=new Timer(10000);
    timer.start();
  }
  minim = new Minim(this); //Initiallice Minim
  player = minim.loadFile("mainTheme.mp3"); //Load the file and set at the player


  player.setGain(aud_music_volume);
  player.play();
  if (!aud_music_state) player.mute();   
  //-INTRO---------------------------------------------------------
  //-MENU----------------------------------------------------------
  menu_nav = minim.loadSample("menu_nav.wav", 512);
  menu_sel = minim.loadSample("menu_sel.wav", 512);
  menu_back = minim.loadSample("menu_nav.wav", 512);
  logo_menu = loadImage("logo_menu.png");
  redim=1920/width;
  text_tam=3*(redim+10);
  hs1 = new HScrollbar(width/3+300, height*2/5+((height/5)*7/4)-15, 300, 20, 1, ((sqrt(aud_music_volume*aud_music_volume))/100*280));
  //-MENU----------------------------------------------------------
}
public boolean sketchFullScreen() {
  cargarConfig=new confLoader();
  cargarConf();
  return scr_fullscr;
}
public void draw() {
  background(0);
  switch (state) {
  case 0:
    if (intro_state) intro();
    else {
      state++;
      stroke(0);
    }
    break;
  case 1:
    menu();
    break;
  case 2:
    image(bg, 0, 0);
    break;
  }
}
public void cargarConf() {
  cargarConfig.cargarRes();
  scr_sz_x=width;
  scr_sz_y=height;
  res=new int[resCount][2];
  res=cargarConfig.res;
  resCount=res.length;
  cargarConfig.cargarConf();
  resPos=cargarConfig.scr_sz; //Resoluci\u00f3n
  scr_sz_x=res[resPos][0];
  scr_sz_y=res[resPos][1];
  scr_fullscr=cargarConfig.scr_fullscr;
  scr_frameRate=cargarConfig.scr_frameRate;
  intro_state=cargarConfig.intro_state;
  aud_music_state=cargarConfig.aud_music_state;
  aud_music_volume=cargarConfig.aud_music_volume;
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
public void menu() {
  switch (menu_index) {
  case 0:
    menu_ini();
    break;
  case 1:
    menu_jugar();
    break;
  case 2:
    menu_opc();
    break;
  case 3:
    exit();
    break;
  }
  if (keyPressed&&key==8) {
    menu_sel.trigger();
    menu_index=0;
  }
}
//void keyPressed(){
//  if(key==27)
//    key=0;
//}
public void menu_ini() { 
  frameRate(9);
  image(logo_menu, (width-(800/redim))/2, height/5, logo_menu.width/redim, logo_menu.height/redim);
  fill(0xffffffff);
  textAlign(CENTER);
  switch (menu_ini_index) {
  case 0:
    textSize(text_tam+10);
    text("Jugar", width/2, height*2/5+((height/5)*1/3));
    textSize(text_tam);
    text("Opciones", width/2, height*2/5+((height/5)*2/3));
    text("Salir", width/2, height*2/5+((height/5)*3/3));
    break;
  case 1:
    text("Jugar", width/2, height*2/5+((height/5)*1/3));
    textSize(text_tam+10);
    text("Opciones", width/2, height*2/5+((height/5)*2/3));
    textSize(text_tam);
    text("Salir", width/2, height*2/5+((height/5)*3/3));
    break;
  case 2:
    text("Jugar", width/2, height*2/5+((height/5)*1/3));
    text("Opciones", width/2, height*2/5+((height/5)*2/3));
    textSize(text_tam+10);
    text("Salir", width/2, height*2/5+((height/5)*3/3));
    textSize(text_tam);
    break;
  }
  for (int i=0; i<3; i++) {
    if ((mouseX > (width/2-120) )&&( mouseX < (width/2+120) )&&( mouseY > (height*2/5+((height/5)*(i+1)/3))-40)&&( mouseY < (height*2/5+((height/5)*(i+1)/3)))) {
      if (menu_ini_index!=i)menu_nav.trigger();
      menu_ini_index=i;
      if (mousePressed) {     
        menu_sel.trigger();
        menu_index=menu_ini_index+1;
        menu_ini_index=0;
      }
    }
  }
  if (keyPressed&&key=='\n') {
    menu_sel.trigger();
    menu_index=menu_ini_index+1;
    menu_ini_index=0;
  }
  if (keyPressed&&keyCode==UP) {
    menu_nav.trigger();
    menu_ini_index--;
    if (menu_ini_index<0)menu_ini_index=2;
  }
  if (keyPressed&&keyCode==DOWN) {
    menu_nav.trigger();
    menu_ini_index=(menu_ini_index+1)%3;
  }
}
public void menu_jugar() {
  frameRate(9);
  image(logo_menu, (width-(800/redim))/2, height/5, logo_menu.width/redim, logo_menu.height/redim);  
  fill(0xffffffff);
  textAlign(CENTER);
  int items=3;
  switch (menu_jugar_index) {
  case 0:
    textSize(text_tam+10);
    text("Crear partida nueva", width/2, height*2/5+((height/5)*1/items));
    textSize(text_tam);
    text("Cargar partida", width/2, height*2/5+((height/5)*2/items));
    text("Volver", width/2, height*2/5+((height/5)*3/items));
    break;
  case 1:
    text("Crear partida nueva", width/2, height*2/5+((height/5)*1/items));
    textSize(text_tam+10);
    text("Cargar partida", width/2, height*2/5+((height/5)*2/items));
    textSize(text_tam);
    text("Volver", width/2, height*2/5+((height/5)*3/items));
    break;
  case 2:
    text("Crear partida nueva", width/2, height*2/5+((height/5)*1/items));
    text("Cargar partida", width/2, height*2/5+((height/5)*2/items));
    textSize(text_tam+10);
    text("Volver", width/2, height*2/5+((height/5)*3/items));
    textSize(text_tam);
    break;
  }
  for (int i=0; i<3; i++) {
    if ((mouseX > (width/2-120) )&&( mouseX < (width/2+120) )&&( mouseY > (height*2/5+((height/5)*(i+1)/items))-40)&&( mouseY < (height*2/5+((height/5)*(i+1)/items)))) {
      if (menu_jugar_index!=i)menu_nav.trigger();
      menu_jugar_index=i;
      if (mousePressed) {     
        menu_sel.trigger();
        switch (menu_jugar_index) {
        case 0:
          state=2;
          frameRate(scr_frameRate);
          break;
        case 1:
          break;
        case 2:
          menu_index=0;
          menu_jugar_index=0;
          break;
        }
      }
    }
  }
  if (keyPressed&&key=='\n') {
    menu_sel.trigger();
    switch (menu_jugar_index) {
    case 0:
      state=2;
      frameRate(scr_frameRate);
      break;
    case 1:
      break;
    case 2:
      menu_index=0;
      menu_jugar_index=0;

      break;
    }
  }
  if (keyPressed&&keyCode==UP) {
    menu_nav.trigger();
    menu_jugar_index--;
    if (menu_jugar_index<0)menu_jugar_index=2;
  }
  if (keyPressed&&keyCode==DOWN) {
    menu_nav.trigger();
    menu_jugar_index=(menu_jugar_index+1)%3;
  }
}
public void menu_opc() {
  fill(0xffffffff);
  textAlign(LEFT);
  textSize((text_tam*80/40)%80);
  text("OPCIONES", width/4, height/5);
  textSize(text_tam);
  int items=4;
  switch (menu_opc_index) {
  case 0:
    textSize(text_tam+10);
    text(opc1, width/3, height*2/5+((height/5)*1/items));
    textSize(text_tam);
    text(opc2, width/3, height*2/5+((height/5)*2/items));
    text(opc3, width/3, height*2/5+((height/5)*3/items));
    text(opc4, width/3, height*2/5+((height/5)*4/items));
    text(opc5, width/3, height*2/5+((height/5)*5/items));
    text(opc6, width/3, height*2/5+((height/5)*6/items));
    text(opc7, width/3, height*2/5+((height/5)*7/items));
    text(opc8, width/4, height*2/5+((height/5)*8/items));
    break;
  case 1:
    text(opc1, width/3, height*2/5+((height/5)*1/items));
    textSize(text_tam+10);
    text(opc2, width/3, height*2/5+((height/5)*2/items));
    textSize(text_tam);
    text(opc3, width/3, height*2/5+((height/5)*3/items));
    text(opc4, width/3, height*2/5+((height/5)*4/items));
    text(opc5, width/3, height*2/5+((height/5)*5/items));
    text(opc6, width/3, height*2/5+((height/5)*6/items));
    text(opc7, width/3, height*2/5+((height/5)*7/items));
    text(opc8, width/4, height*2/5+((height/5)*8/items));
    break;
  case 2:
    text(opc1, width/3, height*2/5+((height/5)*1/items));
    text(opc2, width/3, height*2/5+((height/5)*2/items));
    textSize(text_tam+10);
    text(opc3, width/3, height*2/5+((height/5)*3/items));
    textSize(text_tam);
    text(opc4, width/3, height*2/5+((height/5)*4/items));
    text(opc5, width/3, height*2/5+((height/5)*5/items));
    text(opc6, width/3, height*2/5+((height/5)*6/items));
    text(opc7, width/3, height*2/5+((height/5)*7/items));
    text(opc8, width/4, height*2/5+((height/5)*8/items));
    break;
  case 3:
    text(opc1, width/3, height*2/5+((height/5)*1/items));
    text(opc2, width/3, height*2/5+((height/5)*2/items));
    text(opc3, width/3, height*2/5+((height/5)*3/items));
    textSize(text_tam+10);
    text(opc4, width/3, height*2/5+((height/5)*4/items));
    textSize(text_tam);
    text(opc5, width/3, height*2/5+((height/5)*5/items));
    text(opc6, width/3, height*2/5+((height/5)*6/items));
    text(opc7, width/3, height*2/5+((height/5)*7/items));
    text("Volver", width/4, height*2/5+((height/5)*8/items));
    break;
  case 4:
    text(opc1, width/3, height*2/5+((height/5)*1/items));
    text(opc2, width/3, height*2/5+((height/5)*2/items));
    text(opc3, width/3, height*2/5+((height/5)*3/items));
    text(opc4, width/3, height*2/5+((height/5)*4/items));
    textSize(text_tam+10);
    text(opc5, width/3, height*2/5+((height/5)*5/items));
    textSize(text_tam);
    text(opc6, width/3, height*2/5+((height/5)*6/items));
    text(opc7, width/3, height*2/5+((height/5)*7/items));
    text(opc8, width/4, height*2/5+((height/5)*8/items));
    break;
  case 5:
    text(opc1, width/3, height*2/5+((height/5)*1/items));
    text(opc2, width/3, height*2/5+((height/5)*2/items));
    text(opc3, width/3, height*2/5+((height/5)*3/items));
    text(opc4, width/3, height*2/5+((height/5)*4/items));
    text(opc5, width/3, height*2/5+((height/5)*5/items));
    textSize(text_tam+10);
    text(opc6, width/3, height*2/5+((height/5)*6/items));
    textSize(text_tam);
    text(opc7, width/3, height*2/5+((height/5)*7/items));
    text(opc8, width/4, height*2/5+((height/5)*8/items));
    break;
  case 6:
    text(opc1, width/3, height*2/5+((height/5)*1/items));
    text(opc2, width/3, height*2/5+((height/5)*2/items));
    text(opc3, width/3, height*2/5+((height/5)*3/items));
    text(opc4, width/3, height*2/5+((height/5)*4/items));
    text(opc5, width/3, height*2/5+((height/5)*5/items));
    text(opc6, width/3, height*2/5+((height/5)*6/items));
    text(opc7, width/3, height*2/5+((height/5)*7/items));
    text(opc8, width/4, height*2/5+((height/5)*8/items));
    break;
  case 7:
    text(opc1, width/3, height*2/5+((height/5)*1/items));
    text(opc2, width/3, height*2/5+((height/5)*2/items));
    text(opc3, width/3, height*2/5+((height/5)*3/items));
    text(opc4, width/3, height*2/5+((height/5)*4/items));
    text(opc5, width/3, height*2/5+((height/5)*5/items));
    text(opc6, width/3, height*2/5+((height/5)*6/items));
    text(opc7, width/3, height*2/5+((height/5)*7/items));
    textSize(text_tam+10);
    text(opc8, width/4, height*2/5+((height/5)*8/items));
    textSize(text_tam);
    break;
  }
  hs1.update();
  hs1.display();

  if (hs1.getPos()%97>=80) {
    cargarConfig.guardarConf(6, str((hs1.getPos()-80)*14/17));
    player.setGain(((hs1.getPos()-80)*14/17));
  } else {
    cargarConfig.guardarConf(6, str(-(60-hs1.getPos()*60/80)));
    player.setGain(-(60-(hs1.getPos()/80)*60));
  }
  opc1_value=""+res[resPos][0]+"x"+res[resPos][1];
  if (scr_fullscr) {
    opc2_value="Si";
  } else {
    opc2_value="No";
  }
  opc3_value=""+scr_frameRate;
  if (intro_state) {
    opc4_value="Si";
  } else {
    opc4_value="No";
  }
  if (aud_music_state) {
    opc5_value="Si";
  } else {
    opc5_value="No";
  }
  if (aud_gui_state) {
    opc6_value="Si";
  } else {
    opc6_value="No";
  }

  opc7_value=str(PApplet.parseInt(hs1.getPos()));
  opc8_value="";
  opc1="Resoluci\u00f3n   "+opc1_value;
  opc2="Pantalla Completa   "+opc2_value;
  opc3="Tasa de FPS   "+opc3_value;
  opc4="Mostrar introducci\u00f3n   "+opc4_value;
  opc5="M\u00fasica   "+opc5_value;
  opc6="Efectos de sonido   "+opc6_value;
  opc7="Volumen  "+opc7_value;

  if (keyPressed&&key=='\n') {
    menu_sel.trigger();
    switch (menu_opc_index) {
    case 0:
      scr_sz_x=res[resPos][0];
      scr_sz_y=res[resPos][1];
      cargarConfig.guardarConf(0, str(resPos));
      resChg=true;
      break;
    case 1:
      if (scr_fullscr) {
        scr_fullscr=false;
        opc2_value="No";
      } else {
        scr_fullscr=true;
        opc2_value="Si";
      }
      cargarConfig.guardarConf(2, str(scr_fullscr));
      break;
    case 2:
      cargarConfig.guardarConf(3, str(scr_frameRate));
      break;
    case 3:
      if (intro_state) {
        intro_state=false;
        opc4_value="No";
      } else {
        intro_state=true;
        opc4_value="Si";
      }
      cargarConfig.guardarConf(4, str(intro_state));
      break;
    case 4:
      if (aud_music_state) {
        aud_music_state=false; 
        opc5_value="No";
        player.mute();
      } else {
        aud_music_state=true;
        opc5_value="Si";
        player.unmute();
      }
      cargarConfig.guardarConf(5, str(aud_music_state));
      break;
    case 5:
      break;
    case 6:
      break;
    case 7:
      menu_index=0;
      menu_opc_index=0;
      if (resChg) {
        open("panspermian_alpha.exe");
        exit();
      }
      break;
    }
  }
  for (int i=1; i<8; i++) {
    if ((mouseX > (width/3) )&&( mouseX < (width/3+400*redim) )&&( mouseY > ((height*2/5+((height/5)*i/items))-40))&&( mouseY < ((height*2/5+((height/5)*i/items))))) {
      if (menu_opc_index!=i-1)menu_nav.trigger();
      menu_opc_index=(i-1)%7;
      if (mousePressed) {
        menu_sel.trigger();
        switch (menu_opc_index) {
        case 0:
          resPos=(resPos+1)%resCount;
          scr_sz_x=res[resPos][0];
          scr_sz_y=res[resPos][1];
          cargarConfig.guardarConf(0, str(resPos));
          resChg=true;
          break;
        case 1:
          if (scr_fullscr) {
            scr_fullscr=false;
            opc2_value="No";
          } else {
            scr_fullscr=true;
            opc2_value="Si";
          }
          cargarConfig.guardarConf(2, str(scr_fullscr));
          break;
        case 2:
          cargarConfig.guardarConf(3, str(scr_frameRate));
          break;
        case 3:
          if (intro_state) {
            intro_state=false;
            opc4_value="No";
          } else {
            intro_state=true;
            opc4_value="Si";
          }
          cargarConfig.guardarConf(4, str(intro_state));
          break;
        case 4:
          if (aud_music_state) {
            aud_music_state=false; 
            opc5_value="No";
            player.mute();
          } else {
            aud_music_state=true;
            opc5_value="Si";
            player.unmute();
          }
          cargarConfig.guardarConf(5, str(aud_music_state));
          break;
        case 5:
          break;
        case 6:
          break;
        case 7:
          menu_index=0;
          menu_opc_index=0;
          if (resChg) {
            open("panspermian_alpha.exe");
            exit();
          }
          break;
        }
      }
    }
  }
  if ((mouseX > (width/4) )&&( mouseX < (width/4+120) )&&( mouseY > ((height*2/5+((height/5)*8/items))-40))&&( mouseY < ((height*2/5+((height/5)*8/items))))) {
    if (menu_opc_index!=7)menu_nav.trigger();
    menu_opc_index=7;
    if (mousePressed) {     
      menu_sel.trigger();
      menu_index=0;
      menu_opc_index=0;
    }
  }  

  if (keyPressed&&keyCode==UP) {
    menu_nav.trigger();
    menu_opc_index--;
    if (menu_opc_index<0)menu_opc_index=7;
  }
  if (keyPressed&&keyCode==DOWN) {
    menu_nav.trigger();
    menu_opc_index=(menu_opc_index+1)%8;
  }
  if (keyPressed&&keyCode==LEFT) {
    menu_nav.trigger();
    if (menu_opc_index==0) { 
      resPos=(resPos-1);
      if (resPos<0)resPos=resCount-1;
    }
  }
  if (keyPressed&&keyCode==RIGHT) {
    menu_nav.trigger();
    if (menu_opc_index==0)resPos=(resPos+1)%resCount;
  }
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l, float extPos) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    sposMin = xpos;
    spos = extPos+sposMin;
    newspos = spos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  public void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  public float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  public boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  public void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  public float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    //return spos * ratio;
    //    println(spos+" "+sposMax+" "+(spos%sposMin));
    return PApplet.parseInt(spos%sposMin)*100/280;
  }
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
  int scr_sz=0; //-CONFIG- Tama\u00f1o de la pantalla en las coordenadas X e Y
  int scr_frameRate=0;  //-CONFIG- Frame por segundo
  boolean scr_fullscr = true; //-CONFIG- Pantalla completa
  boolean intro_state=true; //-CONFIG- Mostrar Intro
  boolean aud_music_state=true; //-CONFIG- Activar m\u00fasica
  float aud_music_volume=0; //-CONFIG- Valor del volumen
  int resCount=0;
  int [][] res;
  XML xml;
  public void confLoader() {
  }

  public void cargarConf() {
    xml = loadXML("config.conf");
    XML[] configs = xml.getChildren("param");
    scr_sz=configs[0].getInt("value");
 //   scr_sz_y=configs[1].getInt("value");
    scr_fullscr=PApplet.parseBoolean(configs[2].getString("value"));
    scr_frameRate=configs[3].getInt("value");
    intro_state=PApplet.parseBoolean(configs[4].getString("value"));
    aud_music_state=PApplet.parseBoolean(configs[5].getString("value"));
    aud_music_volume=configs[6].getFloat("value");
    //  println(configs[0].getInt("value"));
    //  println(configs[1].getInt("value"));
    //  println(boolean(configs[2].getContent("value")));
    //  println(configs[3].getInt("value"));
  }

  public void guardarConf(int conf, String valor) {
    xml = loadXML("config.conf");
    XML[] configs = xml.getChildren("param");
    configs[conf].setString("value", valor);
    saveXML(xml, "data/config.conf");
  }
  public void cargarRes() {
    xml = loadXML("config.conf");
    XML[] configs = xml.getChildren("res");
    resCount=configs.length;
    res=new int[resCount][2];
    for (int i=0; i<resCount; i++) {
      res[i][0]= configs[i].getInt("x");       
      res[i][1]= configs[i].getInt("y");
    }
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "panspermian_alpha" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
