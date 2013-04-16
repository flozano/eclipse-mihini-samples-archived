# Greenhouse demonstrator #

An demonstrator of the Eclipse M2M technologies (http://m2m.eclipse.org) inspired from the mqtt one.
You'll find here the source code of all the projects used in this demo: 

* The Arduino application that emulates a Modbus PLC
* The embedded application that runs on a Raspberry Pi, written using the Eclipse Mihini framework 

## Arduino application ##

This Arduino sketch is very basic, and its single purpose is making available the I/Os of the Arduino over Modbus serial.

## Mihini application ##

This application aims at being deployed on a RaspberryPi (or virtually any kind of Linux system for which you've successfuly been able to deploy Mihini on, and that you are able to connect to your Arduino's serial port – either using USB-Serial or the RX/TX pins).
It uses Mihini Modbus API for interacting with the Arduino "PLC".

Every 10 second, it will read the modbus registers corresponding to the analog inputs, decode the data, and publish it to m2m.eclipse.org's M3DA server.

## Wiring your sensors ##

When you'll have both your Arduino and Mihini apps setup correctly, you might want to actually connect actual sensors... :-)

* A1: Temperature sensor (modbus register #1, corresponding to 'temperature' alias in Mihini app)
* A2: Luminosity sensor (modbus register #2, corresponding to 'luminosity' alias in Mihini app)
* A3: Humidity sensor (modbus register #3, corresponding to 'humidity' alias in Mihini app)
* D3: switch light (modbus register #7, corresponding to 'light' alias in Mihini app)