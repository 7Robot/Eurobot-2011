void updown (char ud, char nbre) {   // u pour monter et d pour descendre
    
  Wire.beginTransmission(65);
  for (int i = 0; i < nbre; i++) 
    Wire.send(byte(ud));
  Wire.endTransmission();
}

void ouverture() {
  digitalWrite(sens2, LOW);
  digitalWrite(sens1, HIGH);
  delay (FERM);
  digitalWrite(sens2, HIGH);
  digitalWrite(sens1, LOW);
  delay(20);
  digitalWrite(sens2, LOW);
}

void fermeture() {
    digitalWrite(sens1, LOW);
    digitalWrite(sens2, HIGH);
    delay (FERM);
    digitalWrite(sens1, HIGH);
    digitalWrite(sens2, LOW);
    delay(20);
    digitalWrite(sens1, LOW);
}

void bloquage () {
  analogWrite (pwm, PW);
  digitalWrite(sens1, LOW);
  digitalWrite(sens2, HIGH);
}

void debloquage () {
  digitalWrite(sens2, LOW);
  analogWrite(pwm, PW);
  digitalWrite(sens2, LOW);
  digitalWrite(sens1, HIGH);
  delay (FERM/1.5);
  digitalWrite(sens2, HIGH);
  digitalWrite(sens1, LOW);
  delay(20);
  digitalWrite(sens2, LOW);
}

/*void chope (char vit) {
  double xavt = x, yavt = y;
  ouverture();
  while (digitalRead(pion)) ordreI2C(1, 10, 0, 1, vit);
  fermeture();
  bloquage();
  updown('u');
  while (abs(x - xavt) > eps || abs(y - yavt) > eps) ordreI2C(1, 10, 1, 1, vit);
}
*/

char chope (char pionAvt) {      // pionAvt = 1 si c'est une figure, 0 sinon. 
  double xavt = x, yavt = y;
  int sf = 0;                  // On met sf a 1 si le pion vers lequel on se dirige est une figure.
  
  ouverture();
  while (digitalRead(pion)) {
    ordreI2C(1, 10, 0, 1, VITCHOPE);  
  }
  fermeture();
  bloquage();
  if (analogRead(sharpfig) > FIGURE) {
     sf = 1;
     lcd.clear();
     lcd.print("FIGURE !!!");
     delay(3000);
      }
  if (sf == 1 && pionAvt == 0)
     updown('u', 7);
  else
    updown('u', 1);
  while (abs(x - xavt) > eps || abs(y - yavt) > eps) 
     ordreI2C(1, 10, 1, 1, VITCHOPE);
  return sf; 
}

void initPince () {
  analogWrite(pwm, 70);
  digitalWrite(sens1, LOW);
  digitalWrite(sens2, HIGH);
  delay(1300);
  digitalWrite(sens2, LOW);
  analogWrite(pwm, PW);
}


void pose() {        // Permet de poser une figure sur un pion pour un empilement.
  double xavt = x, yavt = y;
  
  while(digitalRead(pion))
    ordreI2C(1, 10, 0, 1, VITCHOPE);
  debloquage();
  while (abs(x - xavt) > eps || abs(y - yavt) > eps)
    ordreI2C(1, 10, 1, 1, VITCHOPE);
}
