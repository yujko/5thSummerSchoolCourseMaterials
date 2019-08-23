import java.util.*; 
import java.util.concurrent.ThreadLocalRandom;


float[] PSet={300, 500, 700, 900, 1100};
int condition=0;
int trial=0;

int Wt=30; // 30 millisecond duration
int trials=54;

int[] conditions={0, 1, 2, 3, 4};
float P;
int currentTime=0;
int previous_pressTime=0;

boolean isPressed=false;

PrintWriter logger;

boolean preventRepeat=false;

void setup() {
  size(600, 600);
  background(255);  
  shuffleArray(conditions);
  setCondition();
  logger=createWriter("data.txt");
  previous_pressTime=millis();
}      

void draw() {

  background(0);
  fill(255);
  text(int(P) +"  (ms) Period", 10, 50);
  text(int(trial)+" / "+trials, 10, 110); 
  text(int(condition)+"/"+conditions.length, 10, 140);

  currentTime=millis()%int(P);

  if (currentTime<Wt&&trial<=23) {  // 24 trials of paced tapping
    fill(255);
    ellipse(width/2, height/2, 300, 300);
  }

  if (trial>23) {
    fill(255, 0, 0);
    text("Unpaced tapping begins", width/2, 110);
  }
}


void keyPressed() {
  if (!preventRepeat) {
    preventRepeat=true;
    trial++;
    int current_pressTime=millis();
    logger.println(condition+","+trial+","+P+","+Wt+","+(current_pressTime-previous_pressTime));
    previous_pressTime=current_pressTime;
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
}
