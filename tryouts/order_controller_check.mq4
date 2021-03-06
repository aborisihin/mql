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
   OrderCollection order_collection;
   
   order_collection.collectClosedOrders( Symbol() );
   
   List< SPtr<BaseOrder> > all_orders = order_collection.getAllOrders();
   
   List< SPtr<BaseOrder> > opened_orders = order_collection.getOpenedOrders( all_orders );
   List< SPtr<BaseOrder> > closed_orders = order_collection.getClosedOrders( all_orders );
   List< SPtr<BaseOrder> > sell_orders = order_collection.getOrdersByType( all_orders, OP_SELL );
   SPtr<BaseOrder> by_ticket = order_collection.findOrderByTicket( all_orders, 112133307);
   
   Print( "opened_orders: ", opened_orders.size() );
   Print( "closed_orders: ", closed_orders.size() );
   Print( "sell_orders: ", sell_orders.size() );
   Print( "by_ticket: ", by_ticket.alive() );
}
//+------------------------------------------------------------------+
