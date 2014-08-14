class interfaz {
  PImage vida, contenedor;
  PImage box, avatar;
  PImage var1, contenedor_var1, var2, contenedor_var2;
  int vida_value=50, var1_value=50, var2_value=50;
  String quest_title="EMPIEZA A JUGAR", quest="1) PULSA CUALQUIER TECLA\n PARA MODIFICAR\n LOS VALORES DE\n LA VIDA Y VAR1";
  PFont inter;
  void draw() {
    inter= loadFont("font.vlw");
    vida= loadImage("barraVida.png");
    contenedor= loadImage("barraVidaOut.png");
    var1= loadImage("barraVar1.png");
    contenedor_var1= loadImage("barraVar1Out.png");
    var2= loadImage("barraVar2.png");
    contenedor_var2= loadImage("barraVar2Out.png");
    box = loadImage("box.png");
    avatar= loadImage("avatar.gif");
    stroke(#000000);
    fill(#000000);
    textMode(SCREEN);
    textFont(inter);
    textSize(19);
    image(avatar, 0, 0); // Avatar - Imagen
    image(box, 0, 0); // Avatar - Cuadro
    image(vida, 205, 15, vida_value*3, 20); // Barra de vida - Barra
    image(contenedor, 205, 15, 300, 20); // Barra de vida - Contenedor
    text("VIDA "+vida_value, 205+textWidth("VIDA "+vida_value)/2+(300-textWidth("VIDA "+vida_value))/2, 31); // Barra de vida - Porcentaje
    //  println((textWidth("VIDA "+vida_value))/2);
    image(var1, 205, 45, var1_value*3, 20); // Barra de var1 - Barra
    image(contenedor_var1, 205, 45, 300, 20); // Barra de var1 - Contenedor
    text("\"MAGIA\" "+var1_value, 205+textWidth("\"MAGIA\" "+var1_value)/2+(300-textWidth("\"MAGIA\" "+var1_value))/2, 61); // Barra de var1 - Porcentaje
    image(var2, 205, 75, var2_value*3, 20); // Barra de var2 - Barra
    image(contenedor_var2, 205, 75, 300, 20); // Barra de var2 - Contenedor
    text("EXP. "+var2_value+"% para lvl 2", 205+textWidth("EXP. "+var2_value+"% para lvl 2")/2+(300-textWidth("EXP. "+var2_value+"% para lvl 2"))/2, 92); // Barra de var2 - Porcentaje
    image(box, width-200, 0);
    textSize(60);
    text("MAPA", (width-200)+textWidth("MAPA")/2+(200-textWidth("MAPA"))/2, 115);
    textSize(25);
    textLeading(20);
    text(quest_title, (width-220)+textWidth(quest_title)/2, 230, 0);
    textSize(18);
    text(quest, (width-200)+textWidth(quest)/2, 260);
  }
}

