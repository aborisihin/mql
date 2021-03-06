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
   if( checkNewBarOpen() )
   {
      Print(   "For last ", BarsToAnalyze, 
               " closed bars: max = ", getMaxPrice(BarsToAnalyze,1), 
               " min = ", getMinPrice(BarsToAnalyze,1) );
   }
}
//+------------------------------------------------------------------+

bool checkNewBarOpen()
{
   static datetime last_open=0;
   
   if( Time[0] != last_open )
   {
      last_open = Time[0];
      return true;
   }
   
   return false;
}

double getMaxPrice(int size, int start_pos)
{
   return High[ ArrayMaximum( High, size, start_pos ) ];
}

double getMinPrice(int size, int start_pos)
{
   return Low[ ArrayMinimum( Low, size, start_pos ) ];
}

//+------------------------------------------------------------------+
