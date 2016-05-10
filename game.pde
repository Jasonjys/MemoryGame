int cardShowing = 0;                                          // count the clicking time
Cards[][] manycards = new Cards[4][3];                        // 12 objects
int [][] twoRowArray = {                                      // the array to make sure the numbers appear in pair
  {
    0, 1, 2, 3, 4, 5
  }
  , {
    0, 0, 0, 0, 0, 0
  }
};
int[] currentPair = {                                        // the array to store the information for pairNum and which object
  -1, -1, -1, 0
};
PImage img0, img1, img2, img3, img4, img5;

void setup()
{
  size(800, 600);
  rectMode(CENTER);
  background(255);
  frameRate(1000);
  giveCardsPos(manycards, manycards.length, manycards[0].length-1);
  cardsfacedown(manycards, manycards.length, manycards[0].length-1);
  img0 = loadImage("0.jpg");
  img1 = loadImage("1.jpg");
  img2 = loadImage("2.jpg");
  img3 = loadImage("3.jpg");
  img4 = loadImage("4.jpg");
  img5 = loadImage("5.jpg");
}


void draw()
{
}
class Cards
{
  float x, y;
  float cardHeight = 120;
  float cardWidth = 100;
  boolean cardvisible = false;
  boolean Matchfound = false;
  int pairNum;

  Cards(float x, float y)
  {
    this.x = x;
    this.y = y;
  }

  void drawCards()
  {
    noStroke();
    if (cardvisible == false)
    {
      fill(252, 54, 90);  // red color
      rect(x, y, cardWidth, cardHeight);
    } else if (pairNum == 0)
    {
      image(img0, x-cardWidth/2, y-cardHeight/2);
    } else if (pairNum == 1)
    {
      image(img1, x-cardWidth/2, y-cardHeight/2);
    } else if (pairNum == 2)
    {
      image(img2, x-cardWidth/2, y-cardHeight/2);
    } else if (pairNum == 3)
    {
      image(img3, x-cardWidth/2, y-cardHeight/2);
    } else if (pairNum == 4)
    {
      image(img4, x-cardWidth/2, y-cardHeight/2);
    } else if (pairNum == 5)  
    {
      image(img5, x-cardWidth/2, y-cardHeight/2);
    }
    // rect(x, y, cardWidth, cardHeight);
  }
}



// give objects x and y position
void giveCardsPos(Cards[][] array, int row, int colum)
{
  float spacingX = width/4;
  float spacingY = height/3;

  if (row>0)
  {
    row--;
    array[row][colum] = new Cards(row*spacingX + spacingX/2, colum*spacingY+spacingY/2);
    GiveObject(twoRowArray, array[row][colum]);
    giveCardsPos(array, row, colum);
  } else if (colum>0)
  {
    colum--;
    row = array.length;
    giveCardsPos(array, row, colum);
  }
}

// turn every card face down
void cardsfacedown(Cards[][] array, int row, int colum)
{
  if (row>0)
  {
    row--;
    if (array[row][colum].Matchfound == false)
    {
      array[row][colum].cardvisible = false;
    } else if (currentPair[3] == 6)
    {
      array[row][colum].Matchfound = false;
      array[row][colum].cardvisible = false;
    }
    array[row][colum].drawCards();
    cardsfacedown(array, row, colum);
  } else if (colum>0)
  {
    colum--;
    row = array.length;
    cardsfacedown(array, row, colum);
  }
}

// check if u click on the card or not
void cardPressed(Cards[][] array, int row, int colum)
{

  if (mouseX< array[row][colum].x + array[row][colum].cardWidth/2 && mouseX > array[row][colum].x - array[row][colum].cardWidth/2
    && mouseY< array[row][colum].y + array[row][colum].cardHeight/2 && mouseY> array[row][colum].y - array[row][colum].cardHeight/2)
  {
    if (array[row][colum].cardvisible == false && cardShowing==0)
    {
      cardShowing++;
      array[row][colum].cardvisible = true;
      currentPair[0] = array[row][colum].pairNum;
      currentPair[1] = row;
      currentPair[2] = colum;
    } else if (array[row][colum].cardvisible == false && cardShowing==1)
    {
      cardShowing++;
      array[row][colum].cardvisible = true;
      if (array[row][colum].pairNum  == currentPair[0])
      {
        currentPair[3]++;
        array[row][colum].Matchfound = true;
        array[currentPair[1]][currentPair[2]].Matchfound = true;
        if (currentPair[3] == 6)
        {
          fill(0);
          textAlign(CENTER, CENTER);
          text("You Won!", width/2, height/2);
        }
      }
    } else if (array[row][colum].cardvisible == false && cardShowing==2)
    {
      cardShowing = 1;
      cardsfacedown(array, array.length, array[0].length-1);
      array[row][colum].cardvisible = true;
      currentPair[0] = array[row][colum].pairNum;
      currentPair[1] = row;
      currentPair[2] = colum;
    }

    array[row][colum].drawCards();
  } else if (row>0)
  {
    row--;
    cardPressed(array, row, colum);
  } else if (colum>0)
  {
    colum--;
    row = array.length-1;
    cardPressed(array, row, colum);
  }
}

// give 6 pairs of numbers
void GiveObject(int[][] array, Cards cardSent)
{
  int i = int(random(6));
  if (array[1][i] != 2)
  {
    cardSent.pairNum = array[0][i]; 
    array[1][i]++;
  } else
  {
    GiveObject(array, cardSent);
  }
}

// reset the numbers
void startover(Cards[][] array, int row, int colum)
{
  if (row>0)
  {
    row--;
    GiveObject(twoRowArray, array[row][colum]);
    startover(array, row, colum);
  } else if (colum>0)
  {
    colum--;
    row = array.length;
    startover(array, row, colum);
  }
}


// mouseClick function
void mouseClicked()
{
  if (currentPair[3]<6)
  {
    cardPressed(manycards, manycards.length-1, manycards[0].length-1);
  } else
  {
    background(255); 
    for (int i =0; i<6; i++)
    {
      twoRowArray[1][i] = 0;
    }
    startover(manycards, manycards.length, manycards[0].length-1);

    cardsfacedown(manycards, manycards.length, manycards[0].length-1);
    currentPair[3] =0;
  }
}

