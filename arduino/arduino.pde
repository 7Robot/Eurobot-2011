#include <Wire.h>
#include <LiquidCrystal.h>
#include <math.h>

#define Kd 1334.0 // pas par metres
#define Ka 1156.0 // pas par tour (2Pi)
#define pi 3.14
#define bleu_init 0
#define xinit 23
#define yinit -31
#define theta_init 0
#define pente_acc 5
#define pente_dec 5
#define vmin 5
#define vmax 15
#define ndecoup 50
#define vitrot 6    // vitesse de rotation avec la fonction "rotation"
#define FERM 300    // temps de fermeture/ouverture pince
#define eps 0.5     // epsilon pour la fonction 
#define PW 220      // valeur du pwm pour la pince
#define FIGURE 200  // niveau de détection du sharp pour une figure
#define VITCHOPE 7  // vitesse lors d'une chope
#define OBSTACLE 250// niveau de détection des sharp pour l'obstacle


//////////////////// La connectique ////////////////////

#define pion 9       // entree pour interupteur de pion sur la pince
#define pwm 10       // sortie pour le pwm des moteurs de la pince
#define sens1 11     // sortie n°1 pour le pont H des moteurs de la pince
#define sens2 12     // sortie n°2 pour le pont H des moteurs de la pince
#define sharpD A0    // entree du sharp de DROITE pour détection d'un obstacle
#define sharpG A1    // entree du sharp de GAUCHE pour détection d'un obstacle
#define sharpfig A2  // entree sharp pour détection de figures


//********************  var globales ********************
double x = xinit, y = yinit;
float theta = theta_init ; // pour fct trigo
const int idle = 13;
int i;
char bleu = bleu_init;
int nprofil = 0;
char pions[5] = {0};
char etape = 0;


LiquidCrystal lcd(7, 6, 5, 4, 3, 2);

//******************** Setup ********************
void setup()
{
   Serial.begin(9600);
   Wire.begin();            // join i2c bus (address optional for master)
   pinMode(idle, INPUT);
   for(i=vmin;i<=vmax;i++)
   {
     nprofil = nprofil + i*(pente_acc+pente_dec);
   }
   lcd.begin(16, 2);
   lcd.clear();
   pinMode (sens1, OUTPUT);
   pinMode (sens2, OUTPUT);
   pinMode(pion, INPUT);
   digitalWrite(pion, HIGH);
   updown('r');
   initPince();    // Ça dure 1,3 secondes
   analogWrite(pwm,PW);
}

/* Programme principal. */
  //En avant = 0
  //Sens horaire = 1
  
  
void loop()
{
  char p = 0;
  
  
  etape = 0;
  avanceR(49,0);
  rotation(87,1,vitrot);
  avanceR(46,0);
  rotation(90, 1, vitrot);
  pions[etape] = chope();
  rotation(90,1,vitrot);
  debloquage();
  avanceR(24, 1);
  fermeture();
  rotation(90, 0, vitrot);
  etape = 1;
  p = chope();
  if (p && pions[etape - 1] == 0) {
    rotation(90, 1, vitrot);
    pose();
    rotation(180, 0, vitrot);
  } 
  rotation(180, 0, vitrot);
  avanceR(18, 0);
  debloquage();
  avanceR(18, 1);
  updown('d');
  fermeture();
  rotation(90, 1, vitrot);
  avanceR(32, 0);
  rotation(90, 1, vitrot);
  chope();
  rotation(90, 1, vitrot);
  avanceR(10, 1);
  debloquage();
  avanceR(21, 1);
  rotation(90, 0, vitrot);
  updown('d');
  fermeture();
  chope();
  avanceR(70, 1);
  rotation(270, 1, vitrot);
  avanceR(7, 0);
  debloquage();
  
 analogWrite(pwm, 0);
 ordreI2C(1, 1, 1, 1, 0);
 lcd.clear();
 lcd.setCursor(0,0);
 lcd.print("Temps écoulé :");
 lcd.setCursor(0,1);
 lcd.print(millis() / 1000);
while(1);
}







