//+------------------------------------------------------------------+
//|                                                 bars_analyze.mq4 |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+

extern int BarsToAnalyze = 10;

//+------------------------------------------------------------------+

//int ExpertsTotal;

//+------------------------------------------------------------------+

int OnInit()
{
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
}

void OnTick()
{
   Print( "For last ", BarsToAnalyze, " bars: max = ", getMaxPrice(BarsToAnalyze), " min = ", getMinPrice(BarsToAnalyze) );
}
//+------------------------------------------------------------------+

double getMaxPrice(int size)
{
   double max = Bid;
   
   for( int i = 0; i < size; i++ )
   {
      if( High[i] > max )
         max = High[i];
   }
   
   return max;
}

double getMinPrice(int size)
{
   double min = Bid;
   
   for( int i = 0; i < size; i++ )
   {
      if( Low[i] < min )
         min = Low[i];
   }
   
   return min;
}

//+------------------------------------------------------------------+
