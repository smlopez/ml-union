

class confLoader {
  int scr_sz_x=0, scr_sz_y=0; //-CONFIG- Tamaño de la pantalla en las coordenadas X e Y
  int scr_frameRate=0;  //-CONFIG- Frame por segundo
  boolean scr_fullscr = true; //-CONFIG- Pantalla completa
  boolean intro_state=true; //-CONFIG- Mostrar Intro
  XML xml;
void confLoader(){}

  void cargarConf() {
    xml = loadXML("config.conf");
    XML[] configs = xml.getChildren("param");
    scr_sz_x=configs[0].getInt("value");
    scr_sz_y=configs[1].getInt("value");
    scr_fullscr=boolean(configs[2].getString("value"));
    scr_frameRate=configs[3].getInt("value");
    intro_state=boolean(configs[4].getString("value"));
    //  println(configs[0].getInt("value"));
    //  println(configs[1].getInt("value"));
    //  println(boolean(configs[2].getContent("value")));
    //  println(configs[3].getInt("value"));
     
  }

  void guardarConf(int conf, String valor) {
    xml = loadXML("config.conf");
    XML[] configs = xml.getChildren("param");
    configs[conf].setString("value", valor);
    saveXML(xml,"data/config.conf");
  }
}

