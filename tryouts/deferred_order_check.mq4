//+------------------------------------------------------------------+
//|                                         deferred_order_check.mq4 |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

#include "./../common/order/DeferredOrder.mqh"
//+------------------------------------------------------------------+

enum TradeType { BUY_LIMIT = OP_BUYLIMIT, 
                 BUY_STOP = OP_BUYSTOP,
                 SELL_LIMIT = OP_SELLLIMIT,
                 SELL_STOP = OP_SELLSTOP }; 

extern TradeType TType = BUY_LIMIT; //Type of trade

//+------------------------------------------------------------------+
void OnStart()
{
   double user_price = WindowPriceOnDropped();
   DeferredOrder order( Symbol(), TType, user_price, 0 );
   order.tryToOpen();
}
//+------------------------------------------------------------------+
