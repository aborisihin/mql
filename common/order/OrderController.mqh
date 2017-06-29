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
}

void OrderController::collectClosedOrders( string symbol_string )
{
}

void OrderController::clearOrderList()
{
   order_list.clear();
}

#endif