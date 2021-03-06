//+------------------------------------------------------------------+
//|                                             gv_multi_experts.mq4 |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+

extern int MoneyForUsePercent = 40;

//+------------------------------------------------------------------+

int ExpertsTotal;
double MoneyTotal;

string GVQuantityName = "GV_Quantity";

//+------------------------------------------------------------------+

int OnInit()
{
   MoneyTotal = AccountInfoDouble( ACCOUNT_BALANCE );
   
   ExpertsTotal = (int)GlobalVariableGet( GVQuantityName );
   ExpertsTotal++;
   GlobalVariableSet( GVQuantityName, ExpertsTotal );

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   ExpertsTotal = (int)GlobalVariableGet( GVQuantityName );
   
   if( ExpertsTotal <= 1 )
      GlobalVariableDel( GVQuantityName );
   else
      GlobalVariableSet( GVQuantityName, --ExpertsTotal );
}

void OnTick()
{
   if( checkMoneyTotalChanged() || checkExpertsTotalChanged() )
   {
      Print( "MoneyTotal = ", getMoneyForUse() );
   }
}
//+------------------------------------------------------------------+

double getMoneyForUse()
{
   if( ExpertsTotal == 0 ) 
      return 0;
   else 
   {
      double mfu = ( MoneyTotal * ( MoneyForUsePercent / 100.0 ) ) / ExpertsTotal;
      return NormalizeDouble( mfu, 2 );
   }
}

bool checkMoneyTotalChanged()
{
   double cur_money = AccountInfoDouble( ACCOUNT_BALANCE );
   
   bool result = ( cur_money != MoneyTotal );
   
   MoneyTotal = cur_money;
   
   return result;
}

bool checkExpertsTotalChanged()
{
   int cur_experts = (int)GlobalVariableGet( GVQuantityName );
   
   bool result = ( cur_experts != ExpertsTotal );
   
   ExpertsTotal = cur_experts;
   
   return result;
}

void waitForTicks( int ticks_num )
{
   int ticks_count = 0;
   
   while( true )
   {
      if( RefreshRates() )
      {
         ticks_count++;
         Print( "got tick" );
      }
      
      if( ticks_count >= ticks_num )
         break;
   }
}

//+------------------------------------------------------------------+
