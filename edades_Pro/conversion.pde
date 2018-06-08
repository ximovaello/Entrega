import netP5.*;   //librería de conexión a PD
import oscP5.*;   //librería de conexión a PD
import gab.opencv.*;    //librería de detección de caras
import processing.serial.*;    // importar librería serial para la conexions desde Arduino
import processing.video.*;    // importar librería video
import java.awt.*;     //libreria de dibujo con java para el rectángulo de la cara

Capture video;     //captura el video de la cámara
OpenCV opencv;     //localiza el rostro
Movie pel;      // abre el video propio
Serial myPort;    // para recibir de Arduino
String val;     // almacenaremos el valor que Arduino
OscP5 oscP5;      //definición del objeto OSC
NetAddress myRemoteLocation;     //dirección remota
int valInt = 0;      // valor de "cm" en Arduino convertido en entero
float myVol;  //float para el mensaje a PD
float myFaceX; //float para el mensaje a PD

void setup() {
  size(displayWidth, displayHeight); // tamaño de la pantalla
  oscP5 = new OscP5(this, 12000);    // abre puerto de conexión a PD
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);     //conecta con PD
  video = new Capture(this, 640/2, 480/2);      //captura video para deteccion de cara
  opencv = new OpenCV(this, 640/2, 480/2);     // para detectar cara en el video
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);     //detecta cara en el video
  String portName = Serial.list()[3];      //lista los puertos para comunicar con Arduino
  myPort = new Serial(this, portName, 9600);   //abre el puerto para conectar con Arduino

  video.start();     //video para proyectar

  pel = new Movie(this, "cara_a1.mp4");     //carga el video para proyectar
  pel.loop();            //pone en bucle el video para proyectar
}

void draw() {
  background(0);    // fondo negro
  translate(displayWidth, 0);    //voltear la pantalla horizontalmente para la proyeccion
  scale(-2.0, 2.0);   //la escala

  opencv.loadImage(video);    // abre la cámara de video
  Rectangle[] faces = opencv.detect();   // detecta la cara


  if (faces.length > 0) {  //construye el rectángulo 
    //println(faces.length);
    rect(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    image(pel, faces[0].x, faces[0].y, faces[0].width, faces[0].height+20);
   
   myFaceX = map((faces[0].x+faces[0].width/2), 320, 0, 85, 35);    // constrye para PD el valor del rectángulo X

  }
  myVol = map(valInt, 0, 300, 0.300, 0.0); // Construie para PD el valor del "cm" en Arduino
  //println(myVol);
  //println(myFaceX);
  OscMessage valorOSC = new OscMessage("mimensaje");   // Envia a PD los valores calculados
  valorOSC.add(myFaceX);    //valor para el oscilador
  valorOSC.add(myVol);     //valor para el volumen
  
  oscP5.send(valorOSC, myRemoteLocation); //envia valores
}
void captureEvent(Capture c) {  //captura el video con la cámara
  c.read();
}

void movieEvent(Movie m) {
  m.read();
}
void serialEvent(Serial myPort) {  //lee el puerto serial para capturar los valores Arduino
  val=myPort.readStringUntil('\n');

  if (val !=null) {
    try {
      valInt=Integer.parseInt(val.trim()); // conversión a entero del valor de Arduino
     //println(valInt);
    } 
    catch (NumberFormatException npe) {
      //Not an integer soforget it
    }
  }
}
