#include <Stepper.h>

int incomingByte = 0; 
const int stepsPerRevolution = 200;  // Number of steps per revolution for the motor

Stepper myStepper(stepsPerRevolution, 12, 13);     
 
const int pwmA = 3;
const int pwmB = 11;
const int brakeA = 9;
const int brakeB = 8;
const int dirA = 12;
const int dirB = 13;

void setup() {
  Serial.begin(9600);
   
  // Set the PWM and brake pins so that the direction pins
  // can be used to control the motor:
  pinMode(pwmA, OUTPUT);
  pinMode(pwmB, OUTPUT);
  pinMode(brakeA, OUTPUT);
  pinMode(brakeB, OUTPUT);
  digitalWrite(pwmA, HIGH);
  digitalWrite(pwmB, HIGH);
  digitalWrite(brakeA, LOW);
  digitalWrite(brakeB, LOW);
   
  // Set the motor speed (for multiple steps only):
  myStepper.setSpeed(50);
}
 
void loop() {  
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    Serial.print("I received: ");
    Serial.println(incomingByte - 48);
    
    if(incomingByte == 49) {
      myStepper.step(50);
    }
    else {
      myStepper.step(-50);
    }
  }
}
