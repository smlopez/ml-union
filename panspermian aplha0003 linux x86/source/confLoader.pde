

class confLoader {
  int scr_sz=0; //-CONFIG- Tamaño de la pantalla en las coordenadas X e Y
  int scr_frameRate=0;  //-CONFIG- Frame por segundo
  boolean scr_fullscr = true; //-CONFIG- Pantalla completa
  boolean intro_state=true; //-CONFIG- Mostrar Intro
  boolean aud_music_state=true; //-CONFIG- Activar música
  float aud_music_volume=0; //-CONFIG- Valor del volumen
  int resCount=0;
  int [][] res;
  XML xml;
  void confLoader() {
  }

  void cargarConf() {
    xml = loadXML("config.conf");
    XML[] configs = xml.getChildren("param");
    scr_sz=configs[0].getInt("value");
 //   scr_sz_y=configs[1].getInt("value");
    scr_fullscr=boolean(configs[2].getString("value"));
    scr_frameRate=configs[3].getInt("value");
    intro_state=boolean(configs[4].getString("value"));
    aud_music_state=boolean(configs[5].getString("value"));
    aud_music_volume=configs[6].getFloat("value");
    //  println(configs[0].getInt("value"));
    //  println(configs[1].getInt("value"));
    //  println(boolean(configs[2].getContent("value")));
    //  println(configs[3].getInt("value"));
  }

  void guardarConf(int conf, String valor) {
    xml = loadXML("config.conf");
    XML[] configs = xml.getChildren("param");
    configs[conf].setString("value", valor);
    saveXML(xml, "data/config.conf");
  }
  void cargarRes() {
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

