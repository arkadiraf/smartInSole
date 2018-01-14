// Full orientation sensing using NXP's advanced sensor fusion algorithm.
//
// You *must* perform a magnetic calibration before this code will work.
//
// To view this data, use the Arduino Serial Monitor to watch the
// scrolling angles, or run the OrientationVisualiser example in Processing.

#include <NXPMotionSense.h>
#include <Wire.h>
#include <EEPROM.h>

NXPMotionSense imu;
NXPSensorFusion filter;

// timer
unsigned long millisStamp = 0;
unsigned long filterMiliis = 0;
#define MILLIS_DELAY 20

void setup() {
  Serial.begin(57600);
  Serial1.begin(57600);
  imu.begin();
  filter.begin(1000/MILLIS_DELAY);
  pinMode(21, OUTPUT);
  analogWrite(21, 0);
}

void loop() {
  millisStamp = millis();
  float ax, ay, az;
  float gx, gy, gz;
  float mx, my, mz;
  float roll, pitch, heading;
  if ((millisStamp - filterMiliis) >= MILLIS_DELAY) { 
    if (imu.available()) { 
      filterMiliis = millisStamp;
      // Read the motion sensors
      imu.readMotionSensor(ax, ay, az, gx, gy, gz, mx, my, mz);

      // Update the SensorFusion filter
      filter.update(gx, gy, gz, ax, ay, az, mx, my, mz);
      //filter.update(gz, gy, -gx, az, ay, -ax, mz, my, -mx); // xbee down
      //filter.update(-gz, gy, gx, -az, ay, ax, -mz, my, mx); // xbee up
      //filter.update(-gx, gz, gy, -ax, az, ay, -mx, mz, my); // Side Left shoe (xbee back) 
      // print the heading, pitch and roll
      roll = filter.getRoll();
      pitch = filter.getPitch();
      heading = filter.getYaw();

      // read analog
      float sensor1 = adcToForce(analogRead(A0));
      float sensor2 = adcToForce(analogRead(A1));
      float sensor3 = adcToForce(analogRead(A2));
      float sensor4 = adcToForce(analogRead(A3));
      int sensor5 = analogRead(A6);
      // send to screen
      Serial.print("IMU2:");
      Serial.print(filterMiliis);
      Serial.print(",");
      Serial.print(heading);
      Serial.print(",");
      Serial.print(pitch);
      Serial.print(",");
      Serial.print(roll);

      // adc
      Serial.print(",");
      Serial.print(sensor1);
      Serial.print(",");
      Serial.print(sensor2);
      Serial.print(",");
      Serial.print(sensor3);
      Serial.print(",");
      Serial.print(sensor4);
      Serial.print(",");
      Serial.println(sensor5);


      // send to xbee
      Serial1.print("IMU2:");
      Serial1.print(filterMiliis);
      Serial1.print(",");
      Serial1.print(heading);
      Serial1.print(",");
      Serial1.print(pitch);
      Serial1.print(",");
      Serial1.print(roll);

      //adc readings
      Serial1.print(",");
      Serial1.print(sensor1);
      Serial1.print(",");
      Serial1.print(sensor2);
      Serial1.print(",");
      Serial1.print(sensor3);
      Serial1.print(",");
      Serial1.print(sensor4);
      Serial1.print(",");
      Serial1.println(sensor5);
    }
  }
}

// convert adc reading to force
float adcToForce(int fsrADC) {
  const float VCC = 4.98; // Measured voltage of Ardunio 5V line
  const float R_DIV = 3230.0; // Measured resistance of 3.3k resistor
  float force = 0;
  if (fsrADC != 0) // If the analog reading is non-zero
  {
    // Use ADC reading to calculate voltage:
    float fsrV = fsrADC * VCC / 1023.0;
    // Use voltage and static resistor value to
    // calculate FSR resistance:
    float fsrR = R_DIV * (VCC / fsrV - 1.0);
    // Serial.println("Resistance: " + String(fsrR) + " ohms");
    // Guesstimate force based on slopes in figure 3 of
    // FSR datasheet:
    float fsrG = 1.0 / fsrR; // Calculate conductance
    // Break parabolic curve down into two linear slopes:
    if (fsrR <= 600)
      force = (fsrG - 0.00075) / 0.00000032639;
    else
      force =  fsrG / 0.000000642857;

    //    if (force>100 && force<10000) {
    //      Serial.println("Force: " + String(force) + " g");
    //      Serial.println();
    //    }
    //    delay(100);
  }
  return force;
}

