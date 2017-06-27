//+------------------------------------------------------------------+
//|                                         minstops_order_check.mq4 |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

#include "./../common/order/MinStopsOrder.mqh"
//+------------------------------------------------------------------+

enum TradeType { BUY = OP_BUY, SELL = OP_SELL }; 

extern TradeType TType = BUY; //Type of trade

//+------------------------------------------------------------------+
void OnStart()
{
   MinStopsOrder order( Symbol(), TType, 0.01, 10 );
   order.tryOpen();
}
//+------------------------------------------------------------------+
