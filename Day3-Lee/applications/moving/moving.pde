import java.util.*; 
import java.util.concurrent.ThreadLocalRandom;

float[] PSet={1000, 1000, 1000, 2000, 2000, 2000};
float[] tcSet={0, 80, 250, 0, 80,250};
float[] WSet={100, 100, 100, 100, 100, 100};
int[] conditions={0, 1, 2, 3, 4, 5};

int condition=0;
int trial=0;

int trials=50;
int fr=60; // set framerate

float targetSpeed=0; // Pixels/frame
float targetLocation=0;

float shadeWidth=0;
float regionWidth=0;


float P;
float Wt;
float tc;
int currentLocation=0;

boolean isSuccess=false;
boolean isPressed=false;
float successMoment=0;

PrintWriter logger;

boolean preventRepeat=false;

void setup() {
  size(900, 400);
  background(255);  
  shuffleArray(conditions);
  setCondition();
  logger=createWriter("data.txt");
  frameRate(fr);
}      

void draw() {
  targetLocation+=targetSpeed;
  targetLocation%=width;
  background(0);

  noStroke();
  fill(255, 0, 0, 50);
  rect(width-regionWidth, 0, regionWidth, height);

  stroke(255);
  strokeWeight(1);  
  line(targetLocation, 0, targetLocation, height);

  noStroke();
  fill(0);
  rect(0, 0, shadeWidth, height);
  fill(255);
  text(int(P) +"  (ms) Period", 10, 50);
  text(int(Wt) +"  (ms) Temporal Width", 10, 80); 
  text(int(trial)+" / "+trials, 10, 110); 
  text(int(condition)+"/"+conditions.length, 10, 140);
}


void keyPressed() {
  if (!preventRepeat) {
    preventRepeat=true;
    trial++;
    float currentLocation =targetLocation;
    if (currentLocation>=(width-regionWidth)&&currentLocation<=width) {    
      fill(0, 255, 0);
      rect(width-regionWidth, 0, regionWidth, height);
      logger.println(condition+","+trial+","+P+","+Wt+","+tc+","+currentLocation+","+1+","+width+","+height+","+targetSpeed);
    } else {
      logger.println(condition+","+trial+","+P+","+Wt+","+tc+","+currentLocation+","+0+","+width+","+height+","+targetSpeed);
    }

    if (trial==trials) {
      trial=0;
      condition++;

      if (condition>=conditions.length) {
        logger.flush();
        logger.close();
        exit();
      } else {
        setCondition();
      }
    }
  }
}

void keyReleased() {
  preventRepeat=false;
}

// Implementing Fisher–Yates shuffle
// https://stackoverflow.com/questions/1519736/random-shuffling-of-an-array
void shuffleArray(int[] ar)
{
  // If running on Java 6 or older, use `new Random()` on RHS here
  Random rnd = ThreadLocalRandom.current();
  for (int i = ar.length - 1; i > 0; i--)
  {
    int index = rnd.nextInt(i + 1);
    // Simple swap
    int a = ar[index];
    ar[index] = ar[i];
    ar[i] = a;
  }
}


void setCondition() {
  P=PSet[conditions[condition]];
  Wt=WSet[conditions[condition]];
  tc=tcSet[conditions[condition]];

  targetSpeed=width/(P/1000)/60;
  regionWidth=Wt/1000*fr*targetSpeed;
  shadeWidth=(width-regionWidth)-tc/1000*targetSpeed*fr;
}
