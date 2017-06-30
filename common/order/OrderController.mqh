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
      
      //взять под контроль ордер
      void takeOwnership( BaseOrder *order );
      
      //взять под контроль и получить данные о всех открытых ордерах по финансовому инструменту
      void collectOpenedOrders( string symbol_string );
      
      //взять под контроль и получить данные о всех закрытых ордерах по финансовому инструменту
      void collectClosedOrders( string symbol_string );
      
      //очистить список контролируемых ордеров
      void clearOrderList();
      
   public:
      
      //получить ордер из контролируемых по номеру тикета; в случае, если не найден - вернет нулевой указатель
      BaseOrder* findOrderByTicket( int ticket );
      
      //получить все ордеры по типу финансовой операции
      //List<BaseOrder>* getOrdersByType( int operation_type );
      
   private:
   
      List<BaseOrder*> order_list;
      
      void collectOrders( string symbol_string, int total, int order_select_mode );
      
};

OrderController::OrderController()
   : order_list()
{
}

OrderController::~OrderController()
{
}

void OrderController::takeOwnership( BaseOrder *order )
{
   order_list.append( new ListElement<BaseOrder*>(order) );
}

void OrderController::collectOpenedOrders( string symbol_string )
{
   collectOrders( symbol_string, OrdersTotal(), MODE_TRADES );
}

void OrderController::collectClosedOrders( string symbol_string )
{
   collectOrders( symbol_string, OrdersHistoryTotal(), MODE_HISTORY );
}

void OrderController::collectOrders( string symbol_string, int total, int order_select_mode )
{
   for( int n_order = 0; n_order < total; n_order++ )
   {
      if( OrderSelect( n_order, SELECT_BY_POS, order_select_mode ) )
      {
         if( OrderSymbol() != symbol_string ) continue;
         
         BaseOrder *cur_order = new BaseOrder( OrderSymbol(), OrderType(), OrderTicket() );
         cur_order.updateParametersFromServer();
         
         order_list.append( new ListElement<BaseOrder*>(cur_order) );
      }
   }
}

void OrderController::clearOrderList()
{
   order_list.clear();
}

BaseOrder* OrderController::findOrderByTicket( int ticket )
{
   for( unsigned int i = 0; i < order_list.size(); i++ )
   {
      ListElement<BaseOrder*> *current_element = order_list.at(i);
   
      if( current_element == NULL)
         continue;
      
      if( current_element.data().getTicket() == ticket )
         return current_element.data();
   }

   return NULL;
}

/*List<BaseOrder>* OrderController::getOrdersByType( int operation_type )
{
   List<BaseOrder>* result;

   for( unsigned int i = 0; i < order_list.size(); i++ )
   {
      ListElement<BaseOrder*> *current_element = order_list.at(i);
   
      if( current_element == NULL || current_element.data() == NULL )
         continue;
      
      if( current_element.data().getParameters().getOperationType() == operation_type )
         result.append( current_element );
   }

   return result;
}*/

#endif