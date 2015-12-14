import javax.swing.JColorChooser; //import color palate
import java.awt.Color;            //library

PImage bkg;                       // screen saver variable

PImage pencil;                    // menu image of pencil 
PImage circle;                    // menu image of circle
PImage radiant;                   // menu image of radiants 
PImage line;                      // menu image of line 
PImage circleRepeat;              // menu image of repeating Circles

PFont font;                       // stock font

color c = color(0,0,0);              // temporary color variable
color fillColor = color(0, 0, 0);    // stores color of shape
color borderColor = color(0, 0, 0);  // stores color of border of shape
Color javaColor;                     // variable for Color palete

boolean click;                       // stores status of mouse click pressed
int count;                           // stores number of clicks

//These variables store which menu item is selected:
boolean pencilStatus;
boolean circleStatus;
boolean repeatStatus;
boolean circleRepeatStatus;
boolean radiantStatus;
boolean lineStatus;
boolean customStatus;                 //custom Image
boolean eraserStatus;
boolean hollowStatus;                 // hollow means only border will be displayed


boolean pointerBoxStatus; //pointer box is activated when the user selects 'Tip' on screen
boolean borderBoxStatus;  //border box is activated when the user selects 'Border' on screen

String inputText;       //temporary store input data

int borderSize;         //stores thickness of border
int pointerSize;        //stores size of shape

PImage img;             //stores custom image chosen by user
int X = 0;              //counter used to allows opening custom image chooser window to come only once
float zoom;             // magnitude of zoom
float angle;            //magnitude of angle
int x, y;               //size of image
void setup()
{
  smooth();             //for smooth edges
  frameRate(5000);      //for smooth display
  size(1280, 720);      //size of the main window in pixels
  
  font = loadFont("CordiaNew-Bold-48.vlw"); // load custom font
  textFont(font, 20);                       //activate selected font with the required font size
  
  //load custom image of menu items
  pencil = loadImage("pencil.jpg");
  circle = loadImage("circle.png");
  radiant = loadImage("radiant.jpg");
  line = loadImage("line.png");
  circleRepeat = loadImage("circleRepeat.jpg");
  pencil.resize(25, 25);
  circle.resize(25, 25);
  radiant.resize(25, 25);
  line.resize(25, 25);
  circleRepeat.resize(10, 25);
  
  //load default screen
  bkg = loadImage("background.jpg");
  bkg.resize(1280, 720); 
  
  //by default, no mode is selected
  pencilStatus = false;
  circleStatus = false;
  repeatStatus = false;
  circleRepeatStatus = false;
  radiantStatus = false;
  lineStatus = false;
  customStatus = false;
  eraserStatus = false;
  hollowStatus = false;
  
  pointerBoxStatus = false;
  borderBoxStatus = false;
  
  //setting initial/default values
  pointerSize = 10;
  borderSize = 0;
 
  click = false;  
  count = 0;  
  
  x=0;
  y=0;
  
  angle = 0.0;
  zoom = 1;
  
  inputText = "";
}

void draw()
{  
 // to prevent errors
 x = checkValue(x);
 y = checkValue(y); 
 pointerSize = checkValue(pointerSize);
 borderSize = checkValue(borderSize);
 
 noStroke(); 
 image(bkg, 0, 0);   //display default screen
 menu();             //display menu
 
 //activate the mode selected by user
 if(pencilStatus) 
      PencilMode();
 else if(circleStatus)
      CircleMode(); 
 else if(radiantStatus)
      RadiantMode();
 else if(lineStatus)
      LineMode();
 else if(customStatus)
      {        
        if(X==0)           
         selectInput("Choose Image", "fileSelected");         
        
        customMode();
        X++;
      }
 else if(eraserStatus)
       eraserMode();
 else if(circleRepeatStatus)
       circleRepeatMode();
   
 changeCursor(); //change cursor to make it User-friendly
 
}

void menu()
{
    //background of menu
    fill(224, 237, 249);
    rect(0, 0, 90, height);
    
    //heading of menu items
    fill(10, 10, 10);
    text("DRAW MODE", 5, 20);
    
    //display menu items
    image(pencil, 5, 30);
    image(circle, 40, 30);
    image(radiant, 5, 65);
    image(line, 40, 65);
    
    if(inside(75, 85, 30, 55))
    fill(248, 169, 194);
    else
    fill(243, 184, 203);
    rect(75, 30, 10, 25);
    
    image(circleRepeat, 75, 65);
   
    if(inside(5, 88, 100, 152))   
    fill(235);
    else
    fill(255);
    rect(5, 100, 83, 52);
    fill(0);
    text("CUSTOM", 20, 120);
    text("IMAGE", 24, 140);
    
    if(inside(5, 88, 162, 192))
    fill(235);
    else
    fill(255);
    rect(5, 162, 83, 30);
    fill(0);
    text("EXPORT", 20, 180);
    
    
    if(pointerBoxStatus || inside(3, 86, 550, 580)) fill(235);
    else fill(255);
    rect(3, 550, 83, 30);    
    fill(0);    
    text("Tip", 10, 570);
    
    
    if(borderBoxStatus || inside(3, 86, 590, 610)) fill(235);
    else fill(255);
    rect(3, 590, 83, 30);
    fill(0);
    text("Border", 10, 610);
    
    if(inside(3, 86, 640, 670) && (borderBoxStatus || pointerBoxStatus))
    fill(235);
    else
    fill(255);
    rect(3, 640, 83, 30);
    fill(100);
    text("Select Color", 10, 660);
    
    //display the input box
    fill(255);
    rect(3, 680, 83, 30);
    fill(100);
    text(inputText, 10, 700);

}

void eraserMode()
{
 if(click)
  {
   stroke(255);
   strokeWeight(pointerSize); 
   line(pmouseX, pmouseY, mouseX, mouseY);
   
   bkg = get();   
  } 
}

void customMode()
{  
 if(img != null)
 {      
 
  img.resize(x, y);
  
  translate(mouseX/2, mouseY/2);
  rotate(angle*TWO_PI/360);
  translate(-img.width/2, -img.height/2);
 
  scale(zoom);
  
  image(img, mouseX, mouseY);

    
  if(count == 1)
  {
    bkg = get();
    count=0;    
  }
 }
}  

void fileSelected(File selection)
{   
  if(selection != null)  
    {
      img = loadImage(selection.getAbsolutePath());     
      
      x = img.width;
      y = img.height;
      
    }
}

void LineMode()
{  
  if(count == 0)
  {
  fill(borderColor);
  ellipse(mouseX, mouseY, pointerSize+borderSize, pointerSize+borderSize);
  fill(fillColor);
  ellipse(mouseX, mouseY, pointerSize, pointerSize);
  x=mouseX; y=mouseY;  
  }
  if(count >0)
  {    
    strokeWeight(pointerSize+borderSize);
    stroke(borderColor);
    line(x, y, mouseX, mouseY);
    strokeWeight(pointerSize);
    stroke(fillColor);
    line(x, y, mouseX, mouseY);   
    
    if(count == 2 || lineStatus == false)
    {
      bkg = get();
      count = 0;
    }
  }
  
}

void RadiantMode()
{ 
  if(count == 0)
  {
  fill(borderColor);
  ellipse(mouseX, mouseY, pointerSize+borderSize, pointerSize+borderSize);  
  fill(fillColor);
  ellipse(mouseX, mouseY, pointerSize, pointerSize);
  x=mouseX; y=mouseY;
  }
  if(count == 1)
  {
    strokeWeight(pointerSize+borderSize);
    stroke(borderColor);
    line(x, y, mouseX, mouseY);
    strokeWeight(pointerSize);
    stroke(fillColor);
    line(x, y, mouseX, mouseY);
    bkg = get();
  }
  if(count == 2 || radiantStatus==false) count = 0;
  
}

void PencilMode()
{
  if(click)
  {
   stroke(borderColor);
   strokeWeight(borderSize); 
   line(pmouseX, pmouseY, mouseX, mouseY);
   
   stroke(fillColor);
   strokeWeight(pointerSize); 
   line(pmouseX, pmouseY, mouseX, mouseY);
   
   bkg = get();   
  }
}
void circleRepeatMode()
{
  if(hollowStatus)
     noFill();
    else
      fill(fillColor);
    stroke(borderColor);
    strokeWeight(borderSize);
    ellipse(mouseX, mouseY, pointerSize, pointerSize);
  
  if(click)  {
    
    bkg = get();
  }
}
void CircleMode()
{  
  if(count == 0)
  {
  fill(fillColor); 
  x = mouseX;
  y = mouseY;
  ellipse(x, y, 10, 10);    
  }
  if(count >0)
  {
    stroke(fillColor);
    strokeWeight(borderSize);
    noFill();
    ellipse(x, y, mouseX, mouseY);
    if(repeatStatus) bkg = get();    
    if(count == 2)
    {
      bkg = get();
      count = 0;
      circleStatus = false;
    }
  }  
  
  if(count>2 || circleStatus==false) count = 0;  
}
void inputBox()
{
  if(Character.isDigit(key))
    {
      inputText = inputText + key;
    }
  if(key == BACKSPACE)
  {
    inputText = inputText.substring(0, inputText.length()-1); // to remove character and the backspace
  }
  if(key == '\n')
  {
    int n = StringToInt(inputText);
    
    if(borderBoxStatus)    
        {
          borderSize = n;
          borderBoxStatus = false;
        }
    else if(pointerBoxStatus)
      {
        pointerSize = n;
        pointerBoxStatus = false;
      }
      
    inputText = "";
  }
}

boolean inside(int x1, int x2, int y1, int y2)
{
  if(mouseX>=x1 && mouseY>=y1 && mouseX<=x2 && mouseY<=y2)
  return true; 
  
  return false;
}

void selectColor()
{
  javaColor  = JColorChooser.showDialog(this,"Java Color Chooser",Color.white);
if(javaColor!=null) 
      c = color(javaColor.getRed(),javaColor.getGreen(),javaColor.getBlue());
  if(borderBoxStatus)
     {
       borderColor = c;
       borderBoxStatus = false;
     }
    
    else if(pointerBoxStatus)
   {
     fillColor = c;
     pointerBoxStatus = false;
   }
   click = false;
}
void keyPressed()
{
  if(pointerBoxStatus || borderBoxStatus)  
   inputBox();   
  
   switch(key)
  {
    case 'p': 
             circleRepeatStatus = eraserStatus = circleStatus = customStatus = lineStatus = radiantStatus = false;
             pencilStatus = true;
             break;
   case 'o': 
             circleRepeatStatus = eraserStatus = customStatus = lineStatus = radiantStatus = pencilStatus = false;
             circleStatus = true;
             break; 
    case 'r': 
             circleRepeatStatus = eraserStatus = circleStatus = customStatus = lineStatus = pencilStatus = false;
             radiantStatus = true;
             break;
   case 'l': 
             circleRepeatStatus = eraserStatus = circleStatus = customStatus = radiantStatus = pencilStatus = false;
             lineStatus = true;
             break;
   case 'x': 
             circleRepeatStatus = eraserStatus = circleStatus = lineStatus = radiantStatus = pencilStatus = false;
             customStatus = true;
             X=0;
             break;
   case 'e': circleRepeatStatus = customStatus = lineStatus = radiantStatus = pencilStatus = circleStatus = false;
             eraserStatus = true;
             break;
   case 'f': eraserStatus = customStatus = lineStatus = radiantStatus = pencilStatus = circleStatus = false;
             circleRepeatStatus = true;
             break;
   case 'c': if(borderBoxStatus || pointerBoxStatus)
             selectColor();
             break;
   case 'b': pointerBoxStatus = false;
             borderBoxStatus = true;
             break;
   case 's': borderBoxStatus = false;
             pointerBoxStatus = true;
             break;  
   case '+': if(borderBoxStatus) borderSize++;
             else if(pointerBoxStatus) pointerSize++;
             else if(customStatus) zoom += 0.01;
             break;
   case '-': if(borderBoxStatus) borderSize--;
             else if(pointerBoxStatus) pointerSize--;
             else if(customStatus) zoom -= 0.01;
             break;    
   case 'i': if(customStatus) angle++;
             break;
   case 'k': if(customStatus) angle--;
             break;
   case 'n': if(customStatus) x--;
             break;
   case 'm': if(customStatus) x++;
             break;
   case ',': if(customStatus) y--;
             break;
   case '.': if(customStatus) y++;
             break;
   case '[': if(circleRepeatStatus)
                hollowStatus = true;
             else if(circleStatus)
                repeatStatus = true;
             break;
   case ']': if(circleRepeatStatus)
               hollowStatus = false;
             else if(circleStatus)
                  repeatStatus = false;
             break;
   default:  break;
  }
  
 }  

void mousePressed()
{  
  click = true;   
  
  if((customStatus || circleStatus || radiantStatus || lineStatus) && inside(90, width, 0, height))
   count++;
  
 
  if(inside(5, 30, 30, 55))
  {
    bkg = get();
    circleRepeatStatus = eraserStatus = customStatus = lineStatus = radiantStatus = circleStatus = false;
    pencilStatus = true;
  }
  if(inside(40, 65, 30, 45))
  { 
    bkg = get();
    circleRepeatStatus = eraserStatus = customStatus = lineStatus = radiantStatus = pencilStatus = false;
    circleStatus = true;   
  }
  if(inside(5, 30, 55, 80))
  {
    bkg = get();
    circleRepeatStatus = eraserStatus =  customStatus = lineStatus = pencilStatus = circleStatus = false;
    radiantStatus = true;
  }
  if(inside(40, 65, 55, 80))
  {
    bkg = get();
    circleRepeatStatus = eraserStatus = customStatus = radiantStatus = pencilStatus = circleStatus = false;
    lineStatus = true;    
  }
  if(inside(5, 88, 100, 152))
  {
    bkg = get();
    circleRepeatStatus = eraserStatus = lineStatus = radiantStatus = pencilStatus = circleStatus = false;
    customStatus = true;
    X=0;
  }
 if(inside(75, 85, 30, 55))
 {
   circleRepeatStatus = customStatus = lineStatus = radiantStatus = pencilStatus = circleStatus = false;
   bkg = get();
   eraserStatus = true;
   
 }
 if(inside(75, 85, 65, 90))
 {
   eraserStatus = customStatus = lineStatus = radiantStatus = pencilStatus = circleStatus = false;
   bkg = get();
   circleRepeatStatus = true;
 }
  if(inside(5, 88, 162, 192))  
    {
      PImage outputFile = get(90, 0, 1190, height);
      outputFile.save("Image.jpg");
    }
    
  
  if(inside(3, 86, 550, 580))      
   {
     borderBoxStatus = false;
     pointerBoxStatus = true;
   }  
   
  if(inside(3, 86, 590, 610))
  {
    pointerBoxStatus = false;
    borderBoxStatus = true; 
  }
  
  if(borderBoxStatus || pointerBoxStatus)
  {
   if(inside(3, 86, 640, 670))
   selectColor();
  }  
}
void mouseReleased()
{
  click = false;
}


int StringToInt(String s)
{
  int number = 0;
  for(int i = 0; i<s.length(); i++)
  {
    char c = s.charAt(i);
    int digit = (int)c - 48;
    number = (number*10) + digit;
  }
  return number;
}
void changeCursor()
{
  if((inside(3, 86, 640, 670) && (borderBoxStatus || pointerBoxStatus)) || inside(5, 30, 30, 55) || inside(40, 65, 30, 45) || inside(5, 30, 55, 80) || inside(40, 65, 55, 80) || inside(5, 88, 100, 152) || inside(3, 86, 550, 580) || inside(3, 86, 590, 610) || inside(5, 88, 162, 192) || inside(75, 85, 30, 55) || inside(75, 85, 65, 90))
  {
   cursor(HAND);
  }
  else cursor(ARROW);
}
int checkValue(int value)
{ 
  if(value<0) return 0;
  else return value;
}
