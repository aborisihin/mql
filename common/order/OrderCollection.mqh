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
   
      //получить все контролируемые ордера
      List< SPtr<BaseOrder> > getAllOrders() const;
      
      //получить все открытые ордеры из списка
      static List< SPtr<BaseOrder> > getOpenedOrders( const List< SPtr<BaseOrder> > &orders );
      
      //получить все закрытые ордеры из списка
      static List< SPtr<BaseOrder> > getClosedOrders( const List< SPtr<BaseOrder> > &orders );
      
      //получить все ордеры из списка по типу финансовой операции
      static List< SPtr<BaseOrder> > getOrdersByType( const List< SPtr<BaseOrder> > &orders, int operation_type );
      
      //получить ордер из списка по номеру тикета; в случае, если не найден - вернет нулевой указатель
      static SPtr<BaseOrder> findOrderByTicket( const List< SPtr<BaseOrder> > &orders, int ticket );
      
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

List< SPtr<BaseOrder> > OrderCollection::getAllOrders() const
{
   return order_list;
}

List< SPtr<BaseOrder> > OrderCollection::getOpenedOrders( const List< SPtr<BaseOrder> > &orders )
{
   List< SPtr<BaseOrder> > result;

   for( unsigned int order_pos = 0; order_pos < orders.size(); order_pos++ )
   {
      if( orders.at(order_pos) == NULL)
         continue;
      
      SPtr<BaseOrder> current_order = orders.at(order_pos).data();
      
      if( !current_order.alive() )
         continue;
         
      if( current_order.obj().isOpened() )
      {
         result.append( current_order );
      }
   }
   
   return result;
}
      
List< SPtr<BaseOrder> > OrderCollection::getClosedOrders( const List< SPtr<BaseOrder> > &orders )
{
   List< SPtr<BaseOrder> > result;

   for( unsigned int order_pos = 0; order_pos < orders.size(); order_pos++ )
   {
      if( orders.at(order_pos) == NULL)
         continue;
      
      SPtr<BaseOrder> current_order = orders.at(order_pos).data();
      
      if( !current_order.alive() )
         continue;
         
      if( current_order.obj().isClosed() )
      {
         result.append( current_order );
      }
   }
   
   return result;
}

SPtr<BaseOrder> OrderCollection::findOrderByTicket( const List< SPtr<BaseOrder> > &orders, int ticket )
{
   for( unsigned int order_pos = 0; order_pos < orders.size(); order_pos++ )
   {
      if( orders.at(order_pos) == NULL)
         continue;
         
      SPtr<BaseOrder> current_order = orders.at(order_pos).data();
      
      if( !current_order.alive() )
         continue;
      
      if( current_order.obj().getTicket() == ticket )
         return current_order;
   }

   return NULL;
}

List< SPtr<BaseOrder> > OrderCollection::getOrdersByType( const List< SPtr<BaseOrder> > &orders, int operation_type )
{
   List< SPtr<BaseOrder> > result;

   for( unsigned int order_pos = 0; order_pos < orders.size(); order_pos++ )
   {
      if( orders.at(order_pos) == NULL)
         continue;
      
      SPtr<BaseOrder> current_order = orders.at(order_pos).data();
      
      if( !current_order.alive() )
         continue;
         
      SPtr<OrderParameters> current_order_params = current_order.obj().getParameters();
         
      if( current_order_params.obj().getOperationType() == operation_type )
      {
         result.append( current_order );
      }
   }
   
   return result;
}

#endif