
#include <Ultrasonic.h>

const int PIRPin = 2; //  pin detector de movimiento
const int RELEPin = 8;      //   pin    Relé
Ultrasonic ultrasonic(11, 12);  // pins ultrasonido para el trigger y el echo respectivamente
int cm; // // crea   para la salida en cm de la lectura de ultrasonidos



void setup() {
  Serial.begin(9600);  // inicializa puerto serial
  pinMode(RELEPin, OUTPUT); // activa pin de salida
  pinMode(PIRPin, INPUT);  // activa puerto de entrada

}

void loop() {
  cm = ultrasonic.distanceRead(); // convierte la lectura en tiempo del sensor en centimetros
  int value = digitalRead(PIRPin); //  valor para la lectura del detector de movimiento

Serial.println(cm); //envia el valor de cm por el puerto serie a Prossecing



if ((cm >= 140) && (cm <= 190)) { // condicional para el sensor de ultrasonido
    digitalWrite(RELEPin, HIGH);  // apaga el relé
    delay(10);
    //Serial.println("persona detectada");
  }
  else if (value == HIGH) { // condicional para el valor del detector de movimiento + fuera de rango del ultrasonido
    digitalWrite(RELEPin, LOW); // enciende el relé
    //Serial.println("persona entrando");
    delay(10);
  }
  
  else {
 digitalWrite(RELEPin, HIGH); // apaga el relé
        //Serial.println("nadie");

  }
}



