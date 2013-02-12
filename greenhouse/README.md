# Greenhouse demonstrator #

A demonstrator of the Eclipse M2M technologies (http://m2m.eclipse.org) has been created at the end of 2012.
You'll find here the source code of all the projects used in this demo: 

* The Arduino application that emulates a Modbus PLC
* The embedded application that runs on a Raspberry Pi, written using the Eclipse Mihini framework 
* The mobile application that runs on a phone or a tablet, written using the CoronaSDK framework

http://www.youtube.com/watch?v=Ao6ioP7s9_8

## Arduino application ##

This Arduino sketch is very basic, and its single purpose is making available the I/Os of the Arduino over Modbus serial.

## Mihini application ##

This application aims at being deployed on a RaspberryPi (or virtually any kind of Linux system for which you've successfuly been able to deploy Mihini on, and that you are able to connect to your Arduino's serial port – either using USB-Serial or the RX/TX pins).
It uses Mihini Modbus API for interacting with the Arduino "PLC". Every second, it will read the modbus registers corresponding to the analog inputs, decode the data, and publish it to m2m.eclipse.org's MQTT broker. If MQTT messages are posted on a specific topic, the Mihini application will interpret these messages as commands, and react by writing into specific Modbus registers (e.g. for switching a relay).

## CoronaSDK application ##

This application is written using CoronaSDK (http://www.coronalabs.com/products/corona-sdk/) and provides a nice UI for publishing/receiving the MQTT messages corresponding to sensor values retrieved from the Mihini app and commands to send to the app.

Nota: the Corona app. contains a local copy of the Lua MQTT client since it is not really easy in Corona to split projects in separate physical folders. Or maybe it is?