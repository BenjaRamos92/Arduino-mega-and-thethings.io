#include <GSM.h>
#include <thethingsiO.h>
#include <thethingsiOClient.h>
#include <thethingsiOEthernet.h>
#include <thethingsiOGSM.h>


#define TOKEN "aWLjoCBHJt43HrKLYCphzzpyzCcoiTRI6amDQacS72k"

// PIN Number
#define PINNUMBER "1111"

// APN data
#define GPRS_APN "bam.clarochile.cl"
#define GPRS_LOGIN "clarochile"
#define GPRS_PASSWORD "clarochile"

int count = 0;

thethingsiOGSM thing(TOKEN);

GPRS gprs;
GSM gsmAccess;

const int button = 6;
bool lastPressed = false;

void setup() {
    Serial.begin(9600);
    pinMode(button, INPUT);
    Serial.println("inicio");
    startGSM();
}

void loop() {


    if (digitalRead(button) == HIGH) {
        if (!lastPressed) {
            Serial.println("PUSH!");
            Serial.println(count);
            thing.addValue("Button", count++);
            while(thing.send()!=""){
            Serial.println(thing.send());}
            delay(100);
            lastPressed = true;
        }
    }
    else {
        lastPressed = false;
    }
}

void startGSM() {
    boolean notConnected = true;
    Serial.println("GSM start");
    // Start GSM
    // If your SIM has PIN, pass it as a parameter of begin() in quotes

        Serial.println("GSM intento");
        if (gsmAccess.begin() == GSM_READY)
        { 
            Serial.println("OK GSM");
            while(notConnected) 
            {
              delay(1000);
              gprs.attachGPRS(GPRS_APN, GPRS_LOGIN, GPRS_PASSWORD); // The third parameter is zero because it means asynchronous mode
              while(gprs.ready()==0)
              {
                // Your code...
                Serial.println("Waiting to GPRS attachment");
                delay(1000);
              }
              if (gprs.ready()==1) Serial.println("Attached");
                 Serial.println("Connected to GPRS network");
                notConnected = false;
              }
            }
            else 
            {
              Serial.println("pin incorrecto");
              delay(1000);
            }
    Serial.println("Connected");
}
