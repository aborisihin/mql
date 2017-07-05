//+------------------------------------------------------------------+
//|                                       order_controller_check.mq4 |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

#include "./../common/kernel/SPtr.mqh"
#include "./../common/order/BaseOrder.mqh"
#include "./../common/order/OrderCollection.mqh"

//+------------------------------------------------------------------+

//enum TradeType { BUY = OP_BUY, SELL = OP_SELL }; 

//extern TradeType TType = BUY; //Type of trade

//+------------------------------------------------------------------+
void OnStart()
{
   //проверить List::find
   //проверить List::remove

   OrderCollection order_collection;
   
   order_collection.collectClosedOrders( Symbol() );
   Print("closed orders: ", order_collection.size() );
   List< SPtr<BaseOrder> > sell_orders = order_collection.getOrdersByType( OP_SELL );
   Print("closed sell orders: ", sell_orders.size());
}
//+------------------------------------------------------------------+
