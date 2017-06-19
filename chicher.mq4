//+------------------------------------------------------------------+
//|                                                      chicher.mq4 |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
int Count = 0;
//+------------------------------------------------------------------+

int OnInit()
{
   Print( "OnInit()" );
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   Print( "OnDeinit()" );
}

void OnTick()
{
   // calcCyclesBetweenTicks
   int cycles = calcCyclesBetweenTicks();
   
   Print( "Cycles between ticks: ", cycles );
}
//+------------------------------------------------------------------+

int calcCyclesBetweenTicks()
{
   int cycles = 0;
   
   while( !RefreshRates() )
   {
      cycles++;
   }
   
   return cycles;
}
//+------------------------------------------------------------------+