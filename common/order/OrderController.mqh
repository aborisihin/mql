//+------------------------------------------------------------------+
//|                                              OrderController.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef ORDERCONTROLLER_H
#define ORDERCONTROLLER_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

#include "./../../common/kernel/List.mqh"
#include "./../../common/order/BaseOrder.mqh"

//головной класс (фабрика) объектов-ордеров BaseOrder
class OrderController
{
   public:
   
      OrderController();
      ~OrderController();
      
      //получить данные о всех открытых ордерах по финансовому инструменту
      void collectOpenedOrders( string symbol_string );
      
      //получить данные о всех закрытых ордерах по финансовому инструменту
      void collectClosedOrders( string symbol_string );
      
      //очистить список контролируемых ордеров
      void clearOrderList();
      
   private:
   
      List<BaseOrder> *order_list;
      
};

OrderController::OrderController()
   : order_list( new List<BaseOrder>() )
{
}

OrderController::~OrderController()
{
   delete order_list;
}

void OrderController::collectOpenedOrders( string symbol_string )
{
   for( int n_order = 0; n_order < OrdersTotal(); n_order++ )
   {
      if( OrderSelect( n_order, SELECT_BY_POS, MODE_TRADES ) )
      {
         if( OrderSymbol() != symbol_string ) continue;
         
         BaseOrder *cur_order = new BaseOrder( OrderSymbol(), OrderType(), OrderTicket() );
         cur_order.updateParametersFromServer();
         
         order_list.append( new ListElement<BaseOrder>(cur_order) );
      }
   }
   
   Print("list size after collect open orders: ", order_list.size() );
}

void OrderController::collectClosedOrders( string symbol_string )
{
   for( int n_order = 0; n_order < OrdersHistoryTotal(); n_order++ )
   {
      if( OrderSelect( n_order, SELECT_BY_POS, MODE_HISTORY ) )
      {
         if( OrderSymbol() != symbol_string ) continue;
         
         BaseOrder *cur_order = new BaseOrder( OrderSymbol(), OrderType(), OrderTicket() );
         cur_order.updateParametersFromServer();
         
         order_list.append( new ListElement<BaseOrder>(cur_order) );
      }
   }
   
   Print("list size after collect closed orders: ", order_list.size() );
}

void OrderController::clearOrderList()
{
   order_list.clear();
}

#endif