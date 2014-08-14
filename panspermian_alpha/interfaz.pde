class interfaz {
  PImage vida, contenedor;
  PImage box, avatar;
  PImage var1, contenedor_var1;
  int vida_value=50, var1_value=50;
  String quest_title="EMPIEZA A JUGAR", quest="1) PULSA CUALQUIER TECLA\n PARA MODIFICAR\n LOS VALORES DE\n LA VIDA Y VAR1";

  void draw() {
    vida= loadImage("barraVida.png");
    contenedor= loadImage("barraVidaOut.png");
    var1= loadImage("barraVar1.png");
    contenedor_var1= loadImage("barraVar1Out.png");
    box = loadImage("box.png");
    avatar= loadImage("avatar.gif");
    textSize(18);
    fill(#000000);
    image(avatar, 0, 0); // Avatar - Imagen
    image(box, 0, 0); // Avatar - Cuadro
    image(vida, 205, 15, vida_value*3, 20); // Barra de vida - Barra
    image(contenedor, 205, 15, 300, 20); // Barra de vida - Contenedor
    text(vida_value+"%", 362.2-(textWidth(vida_value+"%")/2), 31); // Barra de vida - Porcentaje
    image(var1, 205, 45, var1_value*3, 20); // Barra de var1 - Barra
    image(contenedor_var1, 205, 45, 300, 20); // Barra de var1 - Contenedor
    text(var1_value+"%", 362.2-(textWidth(var1_value+"%")/2), 61); // Barra de var1 - Porcentaje
    image(box, width-200, 0);
    text("MAPA", (width-200)+textWidth("MAPA")/2+(200-textWidth("MAPA"))/2, 100);
    textSize(24);
    textLeading(20);
    text(quest_title, (width-220)+textWidth(quest_title)/2, 230, 0);
    textSize(13);
    text(quest, (width-200)+textWidth(quest)/2, 260);
  }
}

