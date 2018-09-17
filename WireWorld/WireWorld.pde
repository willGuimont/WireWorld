final int SCREEN_WIDTH = 500;
final int SCREEN_HEIGTH = 500;
final int CELL_SIZE = 20;
final int NUM_CELL_X = SCREEN_WIDTH / CELL_SIZE;
final int NUM_CELL_Y = SCREEN_HEIGTH / CELL_SIZE;
final int DELTA_T = 50;
enum CellType {Empty, Head, Tail, Wire}

CellType[][] cells = new CellType[NUM_CELL_X][NUM_CELL_Y];
int time = 0;
boolean paused = true;

void setup()
{
  size(500, 500);
  background(0);
  initCells();
  time = millis();
}

void draw()
{
  background(0);
  int newTime = millis();
  if (!paused && newTime - time >= DELTA_T)
  {
    time = newTime;
    cells = getNewCells(cells);
  }
  drawCells(cells);
  
  if (paused)
  {
    textSize(32);
    fill(255);
    text("Paused", 10, 32);
  }
}

void mousePressed()
{
  int x = mouseX / CELL_SIZE;
  int y = mouseY / CELL_SIZE;
  
  CellType current = cells[x][y];
  
  if (mouseButton == LEFT)
  {
    if (current == CellType.Wire)
      cells[x][y] = CellType.Empty;
    else
      cells[x][y] = CellType.Wire;
  }
  else if (mouseButton == RIGHT)
  {
    if (current == CellType.Head)
      cells[x][y] = CellType.Empty;
    else
      cells[x][y] = CellType.Head;
  }
}

void keyPressed()
{
  if (key == ' ')
    paused = !paused;
}

void initCells()
{
  for (int i = 0; i < NUM_CELL_X; ++i)
  {
    for (int j = 0; j < NUM_CELL_Y; ++j)
    {
      cells[i][j] = CellType.Empty;
    }
  }
}

int getHeadNeighbors(int i, int j, CellType[][] currentCells)
{
  int numHead = 0;
  for (int di = 0; di < 3; ++di)
  {
    int ni = i + di - 1;
    if (ni >= 0 && ni < NUM_CELL_X)
    {
      for (int dj = 0; dj < 3; ++dj)
      {
        int nj = j + dj - 1;
        if (nj >= 0 && nj < NUM_CELL_X)
        {
          if (currentCells[ni][nj] == CellType.Head)
          {
            ++numHead;
          }
        }
      }
    }
  }
  return numHead;
}

CellType[][] getNewCells(CellType[][] currentCells)
{
  CellType[][] out = new CellType[NUM_CELL_X][NUM_CELL_Y];
  
  for (int i = 0; i < NUM_CELL_X; ++i)
  {
    for (int j = 0; j < NUM_CELL_Y; ++j)
    {
      CellType current = currentCells[i][j];
      switch (current)
      {
        case Empty:
          out[i][j] = CellType.Empty;
          break;
        case Head:
          out[i][j] = CellType.Tail;
          break;
        case Tail:
          out[i][j] = CellType.Wire;
          break;
        case Wire:
          int numHead = getHeadNeighbors(i, j, currentCells);
          if (numHead == 1 || numHead == 2)
          {
            out[i][j] = CellType.Head;
          }
          else
          {
            out[i][j] = CellType.Wire;
          }
          break;
        default:
          out[i][j] = CellType.Empty;
          break;
      }
    }
  }
  return out;
}

int getCellColor(CellType type)
{
  switch (type)
  {
    case Empty:
      return color(0);
    case Head:
      return color(0, 0, 255);
    case Tail:
      return color(255, 0, 0);
    case Wire:
      return color(255, 255, 0);
    default:
      return color(0);
  }
}

void drawCell(int x, int y, CellType type)
{
  int c = getCellColor(type);
  fill(c);
  stroke(c);
  rect(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
}

void drawCells(CellType[][] currentCells)
{
  for (int i = 0; i < NUM_CELL_X; ++i)
  {
    for (int j = 0; j < NUM_CELL_Y; ++j)
    {
      CellType current = currentCells[i][j];
      drawCell(i, j, current);
    }
  }
}
