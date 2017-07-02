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
//#include "./../common/kernel/ListElement.mqh"
#include "./../common/order/BaseOrder.mqh"
#include "./../common/order/DeferredOrder.mqh"
//#include "./../common/order/OrderController.mqh"

//+------------------------------------------------------------------+

//enum TradeType { BUY = OP_BUY, SELL = OP_SELL }; 

//extern TradeType TType = BUY; //Type of trade

extern int find_order_ticket = 0;

//+------------------------------------------------------------------+
void OnStart()
{
   BaseOrder *order = new BaseOrder( Symbol(), OP_BUY );
   DeferredOrder *def_order = new DeferredOrder( Symbol(), OP_BUY, 0.1 );
   OrderParameters *params1 = new OrderParameters( Symbol(), OP_BUY );
   OrderParameters *params2 = new OrderParameters( Symbol(), OP_BUY );
   
   SPtr<BaseOrder> s_ptr1( order );
   SPtr<DeferredOrder> s_ptr2( s_ptr1 );
   SPtr<BaseOrder> s_ptr3( s_ptr2 );
   s_ptr3 = def_order; 
   
   SPtr<OrderParameters> s_ptr4( params1 );
   SPtr<OrderParameters> s_ptr5;
   s_ptr5 = params2;
   
   /*BaseOrder o1(Symbol(),OP_BUY);
   BaseOrder *o2 = new BaseOrder(Symbol(),OP_BUY);
   ListElement<BaseOrder> l1(o1);
   ListElement<BaseOrder*> l2(o2);
   ListElement<BaseOrder*> l3(o2);
   l2.setNext(&l3);
   int a=0;
   ListElement<int> int_el(a);*/

   /*OrderController controller;
   
   controller.collectClosedOrders( Symbol() );
   
   Print( "Find order: ", find_order_ticket, " ", controller.findOrderByTicket(find_order_ticket) );*/
}
//+------------------------------------------------------------------+
