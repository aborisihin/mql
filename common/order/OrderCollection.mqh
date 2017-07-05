//+------------------------------------------------------------------+
//|                                              OrderCollection.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef ORDERCOLLECTION_H
#define ORDERCOLLECTION_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

#include "./../../common/kernel/UObject.mqh"
#include "./../../common/kernel/SPtr.mqh"
#include "./../../common/kernel/List.mqh"
#include "./../../common/order/BaseOrder.mqh"

//головной класс (фабрика) объектов-ордеров BaseOrder
class OrderCollection : public UObject
{
   public:
   
      OrderCollection();
      virtual ~OrderCollection();
      
      //взять под контроль ордер
      void takeOwnership( SPtr<BaseOrder> &order );
      
      //взять под контроль и получить данные о всех открытых ордерах по финансовому инструменту
      void collectOpenedOrders( string symbol_string );
      
      //взять под контроль и получить данные о всех закрытых ордерах по финансовому инструменту
      void collectClosedOrders( string symbol_string );
      
      //получить число контролируемых ордеров
      unsigned int size() const;
      
      //очистить список контролируемых ордеров
      void clearOrderList();
      
   public:
      
      //получить ордер из контролируемых по номеру тикета; в случае, если не найден - вернет нулевой указатель
      SPtr<BaseOrder> findOrderByTicket( int ticket );
      
      //получить все ордеры по типу финансовой операции
      List< SPtr<BaseOrder> > getOrdersByType( int operation_type );
      
   private:
   
      List< SPtr<BaseOrder> > order_list;
      
      void collectOrders( string symbol_string, int total, int order_select_mode );
      
};

//+------------------------------------------------------------------+

OrderCollection::OrderCollection()
   : order_list()
{
}

OrderCollection::~OrderCollection()
{
}

void OrderCollection::takeOwnership( SPtr<BaseOrder> &order )
{
   order_list.append( order );
}

void OrderCollection::collectOpenedOrders( string symbol_string )
{
   collectOrders( symbol_string, OrdersTotal(), MODE_TRADES );
}

void OrderCollection::collectClosedOrders( string symbol_string )
{
   collectOrders( symbol_string, OrdersHistoryTotal(), MODE_HISTORY );
}

void OrderCollection::collectOrders( string symbol_string, int total, int order_select_mode )
{
   for( int n_order = 0; n_order < total; n_order++ )
   {
      if( OrderSelect( n_order, SELECT_BY_POS, order_select_mode ) )
      {
         if( OrderSymbol() != symbol_string ) continue;
         
         SPtr<BaseOrder> cur_order = new BaseOrder( OrderSymbol(), OrderType(), OrderTicket() );
         cur_order.obj().updateParametersFromServer();
         
         order_list.append( cur_order );
      }
   }
}

unsigned int OrderCollection::size() const
{
   return order_list.size();
}

void OrderCollection::clearOrderList()
{
   order_list.clear();
}

SPtr<BaseOrder> OrderCollection::findOrderByTicket( int ticket )
{
   for( unsigned int i = 0; i < order_list.size(); i++ )
   {
      ListElement< SPtr<BaseOrder> > *current_element = order_list.at(i);
   
      if( current_element == NULL)
         continue;
      
      if( current_element.data().obj().getTicket() == ticket )
         return current_element.data();
   }

   return NULL;
}

List< SPtr<BaseOrder> > OrderCollection::getOrdersByType( int operation_type )
{
   List< SPtr<BaseOrder> > result;

   for( unsigned int order_pos = 0; order_pos < order_list.size(); order_pos++ )
   {
      ListElement< SPtr<BaseOrder> > *current_element = order_list.at(order_pos);
      SPtr<BaseOrder> current_order = current_element.data();
   
      if( current_element == NULL || !current_order.alive() )
         continue;
      
      if( current_order.obj().getParameters().getOperationType() == operation_type )
      {
         result.append( current_element.data() );
      }
   }
   
   Print("find sell orders: ",result.size());

   return result;
}

#endif