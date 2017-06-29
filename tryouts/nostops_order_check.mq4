//+------------------------------------------------------------------+
//|                                          nostops_order_check.mq4 |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

#include "./../common/order/NoStopsOrder.mqh"
//+------------------------------------------------------------------+

enum TradeType { BUY = OP_BUY, SELL = OP_SELL }; 

extern TradeType TType = BUY; //Type of trade

//+------------------------------------------------------------------+
void OnStart()
{
   NoStopsOrder order( Symbol(), TType );
   order.tryToOpen();
}
//+------------------------------------------------------------------+
