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

#include "./../common/TradeErrorProcessor.mqh"
//+------------------------------------------------------------------+

enum TradeType { BUY_TRADE, SELL_TRADE }; 

extern TradeType TType = BUY_TRADE; //Type of trade
extern int StopLoss; //Stop loss
extern int TakeProfit; //Take profit
extern int MaxSlippage; //Maximum slippage

//+------------------------------------------------------------------+
void OnStart()
{
   int cmd = -1;
   if( TType == BUY_TRADE ) cmd = OP_BUY;
   else if( TType == SELL_TRADE ) cmd = OP_SELL;
   
   int ttype_coeff = 0;
   if( TType == BUY_TRADE ) ttype_coeff = 1;
   else if( TType == SELL_TRADE ) ttype_coeff = -1;

   int order_result = OrderSend(
      Symbol(),         //current symbol
      cmd,              //type
      0.01,             //volume
      Ask,              //price
      MaxSlippage,      //max slippage
      //Bid - ttype_coeff * StopLoss * Point,   //stop loss
      0,
      Bid + ttype_coeff * TakeProfit * Point    //take profit
      );
      
   if( order_result == -1 )
   {
      TradeErrorProcessor::notifyLastError();
   }
}
//+------------------------------------------------------------------+
