import java.util.*; 
import java.util.concurrent.ThreadLocalRandom;


float[] PSet={900, 900, 900, 1200, 1200, 1200};
float[] WSet={50, 116.7, 200, 50, 116.7, 200};
int condition=0;
int trial=0;

int trials=50;

int[] conditions={0, 1, 2, 3, 4, 5};
float P;
float Wt;
int currentTime=0;

boolean isSuccess=false;
boolean isPressed=false;
float successMoment=0;

PrintWriter logger;


void setup() {
  size(600, 600);
  background(255);  
  shuffleArray(conditions);
  setCondition();
  logger=createWriter("data.txt");
}      

void draw() {

  background(0);
  fill(255);
  text(int(P) +"  (ms) Period", 10, 50);
  text(int(Wt) +"  (ms) Temporal Width", 10, 80); 
  text(int(trial)+" / "+trials, 10, 110); 
  text(int(condition)+"/"+conditions.length, 10, 140);

  currentTime=millis()%int(P);

  if (currentTime<Wt) {
    fill(255);
    ellipse(width/2, height/2, 300, 300);
  }
}


void keyReleased() {

  trial++;
  int pressedTime=currentTime;
  if (pressedTime<Wt) {    
    fill(0, 255, 0);
    ellipse(width/2, height/2, 400, 400);
    logger.println(condition+","+trial+","+P+","+Wt+","+pressedTime+","+1);
  } else {
    logger.println(condition+","+trial+","+P+","+Wt+","+pressedTime+","+0);
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
}
