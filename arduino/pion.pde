void updown ( char ud) {   // u pour monter et d pour descendre
    Wire.beginTransmission(65);
    Wire.send(byte(ud));   
    Wire.send(byte(ud));     
    Wire.send(byte(ud)); 
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

char chope () {
  double xavt = x, yavt = y;
  int sf = 0;
  
  ouverture();
  while (digitalRead(pion)) {
    ordreI2C(1, 10, 0, 1, VITCHOPE);  
  }
  ordreI2C(1, 30, 0, 1, 4); 
  fermeture();
  bloquage();
  if (analogRead(sharpfig) > FIGURE) {
      sf = 1;
      for (int i = 0; i < 5; i++) {
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("FIGURE !!!");
      delay(50);
      }
    }
  updown('u');
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

