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

#endif