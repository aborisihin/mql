//+------------------------------------------------------------------+
//|                                                    BaseOrder.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef BASEORDER_H
#define BASEORDER_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

#include "./../../common/order/OrderParameters.mqh"

//базовый класс работы с ордером
class BaseOrder
{
   public:
   
      //конструктор; принимает символ торгового инструмента и тип торговой операции
      BaseOrder( string symbol_string, int operation_type );
      
      //задать параметры ордера; возвращает результат первичной проверки параметров и факт задания
      bool setParameters( const OrderParameters &p );
      
      //получить параметры ордера
      OrderParameters getParameters() const;
      
      //получить параметры имеющегося ордера на сервере
      bool fillParametersFromServer( int ticket_number );
      
      //получить статус ордера (открыт / не открыт)
      bool isOpened() const;
      
      //получить номер тикета (возвращает -1 в случае не открытого ордера)
      int getTicket() const;
      
   public:
   
      //функция открытия ордера
      virtual void tryOpen();
      
   protected:
   
      //возвращает результат проверки параметров ордера
      virtual bool checkParameters( const OrderParameters &p ) const;
      
      //отправка ордера
      virtual void sendOrder();
      
   protected:
   
      OrderParameters params;    //параметры ордера
   
      bool open;                 //статус ордера
      int ticket;                //номер тикета
      
};

BaseOrder::BaseOrder( string symbol_string, int operation_type )
   : params( symbol_string, operation_type )
   , open( false )
   , ticket( -1 )
{
}

bool BaseOrder::setParameters( const OrderParameters &p )
{
   bool check_result = checkParameters( p );
   
   if( check_result )
      params = p;
      
   return check_result;
}

OrderParameters BaseOrder::getParameters() const
{
   return params;
}

bool BaseOrder::checkParameters( const OrderParameters &p ) const
{
   return p.baseCheck();
}

void BaseOrder::tryOpen()
{
   if( open ) return; //уже открыт
   
   sendOrder();
}

void BaseOrder::sendOrder()
{
   ticket = OrderSend( params.getSymbol(), params.getOperationType(),
                       params.volume, params.price, params.slippage, params.stoploss, params.takeprofit,
                       params.comment, params.custom_id, params.expiration, params.arrow_color );
                       
   if( ticket > 0 )
      open = true;
   else
      open = false;
}

bool BaseOrder::isOpened() const
{
   return open;
}

int BaseOrder::getTicket() const
{
   return ticket;
}

bool BaseOrder::fillParametersFromServer( int ticket_number )
{
   bool order_select_result = OrderSelect( ticket_number, SELECT_BY_TICKET );
   
   if( !order_select_result ) 
      return false;
   
   if( params.getSymbol() != OrderSymbol() ) //ордер по тикету не соответствует текущему
      return false;
      
   if( params.getOperationType() != OrderType() ) //ордер по тикету не соответствует текущему
      return false;
   
   return true;
}

#endif