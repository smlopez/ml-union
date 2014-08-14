int scr_sz_x=1920, scr_sz_y=1080; //-CONFIG- Tamaño de la pantalla en las coordenadas X e Y
int scr_frameRate=30; //-CONFIG- Frame por segundo
boolean scr_fullscr; //-CONFIG- Pantalla completa
boolean aud_music_state=true, aud_gui_state=true; //-CONFIG- Activar música
float aud_music_volume=0, aud_gui_volume=0; //-CONFIG- Valor del volumen
PImage bg; //-MAPA- Imagén de fondo
int state=0; //-INTERNO- Posición del switch para cada estados
int redim=0;
int text_tam=0;
boolean resChg=false;
confLoader cargarConfig;
//-INTRO----------------------------------------------------------
import ddf.minim.*;
PImage img;       // The source image
int cellsize = 2; // Dimensions of each cell in the grid
int columns, rows;   // Number of columns and rows in our system
long frame=0; // Current frame to show
int numFrames = 0;
int x_w=0, y_w=0;
Timer timer;
Minim minim, minim_smpls;
AudioPlayer player;
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
String opc1="Resolución";
String opc2="Pantalla Completa";
String opc3="Tasa de FPS";
String opc4="Mostrar introducción";
String opc5="Música";
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
//-JUEGO----------------------------------------------------------
interfaz interfaz;
//-JUEGO----------------------------------------------------------
void setup() {
  size(scr_sz_x, scr_sz_y, P3D);
  frameRate(scr_frameRate);
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
  minim = new Minim(this); //Initiallice Minim music
  minim_smpls = new Minim(this); //Initiallice Minim samples
  player = minim.loadFile("mainTheme.mp3"); //Load the file and set at the player


  player.setGain(aud_music_volume);
  player.play();
  if (!aud_music_state) player.mute();   
  //-INTRO---------------------------------------------------------
  //-MENU----------------------------------------------------------
  menu_nav = minim_smpls.loadSample("menu_nav.wav", 512);
  menu_sel = minim_smpls.loadSample("menu_sel.wav", 512);
  menu_back = minim_smpls.loadSample("menu_back.wav", 512);
  menu_nav.setGain(aud_gui_volume);
  menu_sel.setGain(aud_gui_volume);
  menu_back.setGain(aud_gui_volume);
  if (!aud_gui_state) {
    menu_nav.mute();
    menu_sel.mute();
    menu_back.mute();
  }
  logo_menu = loadImage("logo_menu.png");
  redim=1920/width;
  text_tam=3*(redim+10);
  hs1 = new HScrollbar(width/3+300, height*2/5+((height/5)*7/4)-15, 300, 20, 1, aud_music_volume);
  //-MENU----------------------------------------------------------
  //-JUEGO---------------------------------------------------------
      interfaz=new interfaz();
  //-JUEGO---------------------------------------------------------
}
boolean sketchFullScreen() {
  cargarConfig=new confLoader();
  cargarConf();
  return scr_fullscr;
}
void draw() {
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
    frameRate(9);
    translate(0, 0, 0);
    rectMode(CORNER); 
    stroke(RGB);
    hint(ENABLE_STROKE_PURE);
    smooth();
    menu();
    break;
  case 2:
    image(bg, 0, 0);
  interfaz.draw();
    break;
  }
}
void cargarConf() {
  cargarConfig.cargarRes();
  scr_sz_x=width;
  scr_sz_y=height;
  res=new int[resCount][2];
  res=cargarConfig.res;
  resCount=res.length;
  cargarConfig.cargarConf();
  resPos=cargarConfig.scr_sz; //Resolución
  scr_sz_x=res[resPos][0];
  scr_sz_y=res[resPos][1];
  scr_fullscr=cargarConfig.scr_fullscr;
  scr_frameRate=cargarConfig.scr_frameRate;
  intro_state=cargarConfig.intro_state;
  aud_music_state=cargarConfig.aud_music_state;
  aud_music_volume=cargarConfig.aud_music_volume;
  aud_gui_state=cargarConfig.aud_gui_state;
  aud_gui_volume=cargarConfig.aud_gui_volume;
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
void menu() {
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
    menu_back.trigger();
    menu_index=0;
  }
}
//void keyPressed(){
//  if(key==27)
//    key=0;
//}
void menu_ini() { 
  frameRate(9);
  image(logo_menu, (width-(800/redim))/2, height/5, logo_menu.width/redim, logo_menu.height/redim);
  fill(#ffffff);
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
void menu_jugar() {
  frameRate(9);
  image(logo_menu, (width-(800/redim))/2, height/5, logo_menu.width/redim, logo_menu.height/redim);  
  fill(#ffffff);
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
        if (menu_jugar_index!=2)menu_sel.trigger();
        switch (menu_jugar_index) {
        case 0:
          state=2;
          frameRate(scr_frameRate);
          break;
        case 1:
          break;
        case 2:
          menu_back.trigger();
          menu_index=0;
          menu_jugar_index=0;
          break;
        }
      }
    }
  }
  if (keyPressed&&key=='\n') {
    if (menu_jugar_index!=2)menu_sel.trigger();
    switch (menu_jugar_index) {
    case 0:
      state=2;
      frameRate(scr_frameRate);
      break;
    case 1:
      break;
    case 2:
      menu_back.trigger();
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
void menu_opc() {
  fill(#ffffff);
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
  opc7_value=str(int(hs1.getPos()));
  opc8_value="";
  opc1="Resolución   "+opc1_value;
  opc2="Pantalla Completa   "+opc2_value;
  opc3="Tasa de FPS   "+opc3_value;
  opc4="Mostrar introducción   "+opc4_value;
  opc5="Música   "+opc5_value;
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
      if (!aud_gui_state) {
        opc6_value="Si";
        aud_gui_state=true;
        menu_nav.unmute();
        menu_sel.unmute();
        menu_back.unmute();
      } else {
        opc6_value="No";
        aud_gui_state=false;
        menu_nav.mute();
        menu_sel.mute();
        menu_back.mute();
      }
      cargarConfig.guardarConf(7, str(aud_gui_state));
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
  for (int i=1; i<7; i++) {
    if ((mouseX > (width/3) )&&( mouseX < (width/3+400*redim) )&&( mouseY > ((height*2/5+((height/5)*i/items))-40))&&( mouseY < ((height*2/5+((height/5)*i/items))))) {
      if (menu_opc_index!=i-1)menu_nav.trigger();
      menu_opc_index=(i-1)%6;
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
          if (!aud_gui_state) {
            aud_gui_state=true;
            opc6_value="Si";
            menu_nav.unmute();
            menu_sel.unmute();
            menu_back.unmute();
          } else {
            aud_gui_state=false;
            opc6_value="No";
            menu_nav.mute();
            menu_sel.mute();
            menu_back.mute();
          }
          cargarConfig.guardarConf(7, str(aud_gui_state));
          break;
        case 6:

          break;
        case 7:

          break;
        }
      }
    }
  }
  if ((mouseX > (width/4) )&&( mouseX < (width/4+120) )&&( mouseY > ((height*2/5+((height/5)*8/items))-40))&&( mouseY < ((height*2/5+((height/5)*8/items))))) {
    if (menu_opc_index!=7)menu_nav.trigger();
    menu_opc_index=7;
    if (mousePressed) {     
      menu_back.trigger();
      menu_index=0;
      menu_opc_index=0;
      if (resChg) {
        open("panspermian_alpha.exe");
        exit();
      }
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
