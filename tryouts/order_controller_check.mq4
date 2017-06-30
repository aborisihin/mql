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

#include "./../common/order/OrderController.mqh"
//+------------------------------------------------------------------+

//enum TradeType { BUY = OP_BUY, SELL = OP_SELL }; 

//extern TradeType TType = BUY; //Type of trade

extern int find_order_ticket = 0;

//+------------------------------------------------------------------+
void OnStart()
{
   OrderController controller;
   
   controller.collectClosedOrders( Symbol() );
   
   Print( "Find order: ", find_order_ticket, " ", controller.findOrderByTicket(find_order_ticket) );
}
//+------------------------------------------------------------------+
