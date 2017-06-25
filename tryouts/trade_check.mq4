//+------------------------------------------------------------------+
//|                                                  trade_check.mq4 |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

#include "./../common/info/TradeErrorProcessor.mqh"
#include "./../common/info/MarketData.mqh"
//+------------------------------------------------------------------+

enum TradeType { BUY_TRADE, SELL_TRADE }; 

extern TradeType TType = BUY_TRADE; //Type of trade
extern bool MinStops = true; //Use minimum stops
extern int StopLoss; //Stop loss
extern int TakeProfit; //Take profit
extern int MaxSlippage; //Maximum slippage

//+------------------------------------------------------------------+
void OnStart()
{
   int order_type = -1;
   double price = 0;
   double stoploss = 0;
   double takeprofit = 0;
   
   MarketData market_data( Symbol() );
   
   if( MinStops )
   {
      Print( "Use minimal stops! stop_level = ", market_data.stop_level );
   }
      
   if( TType == BUY_TRADE ) 
   {
      order_type = OP_BUY;
      price = Ask;
      
      if( MinStops )
      {
         stoploss = Bid - (market_data.stop_level) * Point;
         takeprofit = Bid + (market_data.stop_level) * Point;
      }
      else
      {
         stoploss = Bid - StopLoss * Point;
         takeprofit = Bid + TakeProfit * Point;
      }
   }
   else if( TType == SELL_TRADE )
   {
      order_type = OP_SELL;
      price = Bid;
      
      if( MinStops )
      {
         stoploss = Ask + (market_data.stop_level) * Point;
         takeprofit = Ask - (market_data.stop_level) * Point;
      }
      else
      {
         stoploss = Ask + StopLoss * Point;
         takeprofit = Ask - TakeProfit * Point;
      }
   }

   /*int order_result = OrderSend(
      Symbol(),
      order_type,
      0.01, //volume
      price,
      MaxSlippage,
      stoploss,
      takeprofit
      );
      
   if( order_result == -1 )
   {
      TradeErrorProcessor::notifyLastError();
   }*/
}
//+------------------------------------------------------------------+
