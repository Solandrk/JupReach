class Player
{
  int[] colorRGB = new int[3];
  PImage character ;
  float[] coordinate;
  public Player(float[] coordinate){
    fill(random(255),random(255),random(255));
    character =loadImage("char.png");
    coordinate[0] -=10; // -character width/2
    coordinate[1] -=24; // -character height
    
    image(character,coordinate[0],coordinate[1],20,24);
    this.coordinate = coordinate;
  }
  public void shoot()
  {
    if(ev.direction <= -PI/2){
       shooting = false;
       force = 0;
       ev.shootedDistance = 0;
       falling = true;
       ev.stepY = -4;
    }
    if(!checkCollision()){
     coordinate[0]+= ev.stepX;  
     coordinate[1]-=ev.stepY;
    }
    drawC();
  }
  public void falling()
  {
    coordinate[1]-=ev.stepY;
    drawC();
    checkCollision();  
}
  public void drawC()
  {
    image(character,coordinate[0],coordinate[1],20,24);
    ev.player.drawTarget();
  }
  private boolean checkCollision()
  {
    for(int i = 0 ; i<ev.blocks.size();i++)
    {
      if(i == ev.correntBlockI)
        continue;
     if(ev.blocks.get(i).collision()){
       ev.correntBlockI = i;  
       return true;
     }
    } 
    return false;
  }
  
  public void setColor()
  {
    colorRGB = new int[]{ev.blocks.get(ev.targetBlockI).colorRGB[0],ev.blocks.get(ev.targetBlockI).colorRGB[1],ev.blocks.get(ev.targetBlockI).colorRGB[2]};
  }
  public void drawTarget()
  {
    translate(0,0);
    fill(colorRGB[0],colorRGB[1],colorRGB[2]);
    rect(coordinate[0]+6,coordinate[1]+5,8,10);
  }
}
class Block
{ 
  public float widthS;
  public float heightS;
  public float[] coordinate;
  public int[] colorRGB ;
  int index ;
  public Block(float xCoordinate,int index){
    this.index = index;
    colorRGB = new int[]{(int)random(255),(int)random(255),(int)random(255)};
    fill(colorRGB[0],colorRGB[1],colorRGB[2]);
    heightS = random(60,200);
    widthS = random(17,40);
    coordinate = new float[]{xCoordinate,600-heightS};
    drawA();
  }
  public void drawA()
  {
    fill(colorRGB[0],colorRGB[1],colorRGB[2]);
    rect(coordinate[0],coordinate[1],widthS,heightS);
  }
  
  public boolean collision()
  {
    if(ev.player.coordinate[0] <= coordinate[0] +widthS &&
    ev.player.coordinate[0] >= coordinate[0]-15 &&
    ev.player.coordinate[1] >= coordinate[1]-24 &&
    ev.player.coordinate[1] < 600){
       shooting = false;
       force = 0;
       if(ev.player.coordinate[1] > coordinate[1]+1){
          ev.shootedDistance = 0;
          ev.stepY = -4;
          ev.player.coordinate[0]-= 10;
          ev.drawAgain();
         falling = true;
       }else{
         falling = false;
         selectingD = true;
         falling = false;
          selectingD = true;
          ev.direction = 0;
           System.out.println(index + "|| "+ev.targetBlockI);
         if(index == ev.targetBlockI){
            fill(0, 408, 612);
            gameCondition = 1;
            translate(0,height/2);
            rotate(0);
            textSize(48);
            text("!!! You Win !!!",48,0,0);
            System.out.println("Win");
         }
         if(index > ev.targetBlockI){
            fill(0, 408, 612);
            gameCondition = 2;
            translate(0,height/2);
            rotate(0);
            textSize(40);
            text("!!! Game Over !!!",48,0,0);
            System.out.println("Lose");
         }
       }
       if(ev.player.colorRGB[0] == colorRGB[0]&&
       ev.player.colorRGB[1] == colorRGB[1]&&
       ev.player.colorRGB[2] == colorRGB[0]){
         
       }
         
     return true;    
    }
    return false;
  }
}
class Environment{
  public PImage arrowD = loadImage("arrow.png");
  public ArrayList<Block> blocks ;
  public float xLPosition;
  public Player player;
  public float stepY;
  public float stepX;
  public float shootedDistance = 0;
  public float direction = 0;
  public boolean reverseD =false;
  public int correntBlockI = 0;
  public int targetBlockI;
  public Environment(){
    blocks = new ArrayList<Block>();
    xLPosition = 0;
    while(true){
      newBlock(blocks.size()); 
      if(xLPosition >= 400)
        break;
    }
    targetBlockI = (int)random(blocks.size()-1);
    targetBlockI += (targetBlockI==0)?2:0;
    System.out.println(targetBlockI);
    createPlayer();
    selectingD = true;
    shooting = false;
    falling = false;
    forcePressed = false;
}
  
  public Block newBlock(int index)
  {
    Block block = new Block(xLPosition,index);
    blocks.add(block);
    xLPosition += block.widthS;
    return block;
  }
  private Player createPlayer()
  {
    float[] lastBlockC = blocks.get(0).coordinate;
    player = new Player(new float[]{lastBlockC[0]+blocks.get(0).widthS/2,lastBlockC[1]});
    return player;
  }
  public void shootPlayer()
  {
    ev.drawAgain();
    updateDirection();
    player.shoot();
  }
  public void drawAgain()
  {
    background(165, 235, 52);
    for(int i = 0 ; i <blocks.size();i++)
    {
      blocks.get(i).drawA();
    }
  }
  public void updateDirection()
  {
     setUpSteps();
     direction -=PI/32;
  }
  public void setUpSteps()
  {
    stepX= (force+3)*cos(direction);
     stepY = (force+3)*sin(direction);
  }
  public void arrowRotate()
  {
    ev.drawAgain();
    player.drawC();
    translate(player.coordinate[0]+20,player.coordinate[1]);
    rotate(PI);
    rotate(direction);
    if(reverseD)
      direction -= PI/24;
    else 
      direction += PI/24;
      
    if(direction > PI/2)
      reverseD = true;
    else if(direction <= 0)
       reverseD = false;
    image(arrowD,0,direction,10,40); // max -> 2.1 ;
        
  }
  public void fall()
  {
    ev.drawAgain();
   player.falling(); 
  }
}


////////////////

Environment ev;
boolean selectingD = false;
boolean forcePressed = false;
boolean shooting = false;
boolean falling = false;
int force = 0;
int gameCondition;
void setup()
{
  size(400,600);
  background(165, 235, 52);
  ev = new Environment();
  ev.player.setColor();
}

void draw()
{
  if(frameCount %5 == 0){
    if(gameCondition == 0){
      if(selectingD){
        ev.arrowRotate();
      }
      else if(forcePressed){
        if(force<20)
          force++;
      }else if(shooting){
        ev.shootPlayer();
      }else if(falling){
        ev.fall();
      }
      if(ev.player.coordinate[0] >400 || ev.player.coordinate[0]<0 || ev.player.coordinate[1] >600 || ev.player.coordinate[1] <0)
      {
                 
       fill(0, 408, 612);
       gameCondition = 2;
       translate(0,height/2);
       rotate(0);
       textSize(40);
       text("!!! Game Over !!!",48,0,0);
       System.out.println("Lose");}
    }
  }
}
void mousePressed() {
  if (mouseButton == LEFT) {
    if(gameCondition == 0){
      if(selectingD)  
        ev.setUpSteps();
      else{
        if(!shooting && !falling)
          forcePressed = true;
      }  
    }else if(gameCondition == 1 || gameCondition ==2){
      setup();
    }
  }
}
void mouseReleased(){
  if(gameCondition ==0){
 if(!selectingD){
   if(forcePressed){
     forcePressed = false;
     ev.direction = PI/2 - ev.direction;
     shooting = true;
   }
 }else 
   selectingD = false;
  }else
   gameCondition = 0;
}
