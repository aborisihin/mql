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
      
      //функция открытия ордера
      virtual void tryOpen();
      
      //TODO
      //продумать схему открытия, и какую функцию должны реализовывать потомки
      //схема: checkParameters -> tryOpen (в базовом классе просто вызов sendOrder) -> getServerParameters
      //лишнее спрятать в protected
      
      //получить статус ордера (открыт / не открыт)
      bool isOpened() const;
      
      //получить статус ордера (был закрыт / не был закрыт)
      bool isClosed() const;
      
      //получить номер тикета (возвращает -1 в случае не открытого ордера)
      int getTicket() const;
      
   public:
   
      //задать параметры ордера
      void setParameters( const OrderParameters &p );
      
      //получить параметры ордера
      OrderParameters getParameters() const;
      
      //получить параметры имеющегося ордера на сервере
      bool fillParametersFromServer( int ticket_number );
      
      //TODO
      //разделить получение ВСЕХ параметров по ордеру с сервера
      //и получение параметров открытого ордера (может и не надо, а переписывать все параметры)
      
   protected:
   
      //возвращает результат проверки параметров ордера
      virtual bool checkParameters( const OrderParameters &p ) const;
      
      //отправка ордера
      void sendOrder();
      
   protected:
   
      OrderParameters params;    //параметры ордера
   
      bool opened;               //статус ордера
      bool closed;               //статус закрытия ордера   
      int ticket;                //номер тикета
      
};

BaseOrder::BaseOrder( string symbol_string, int operation_type )
   : params( symbol_string, operation_type )
   , opened( false )
   , closed( false )
   , ticket( -1 )
{
}

void BaseOrder::setParameters( const OrderParameters &p )
{
   params = p;
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
   if( opened ) return; //уже открыт
   
   if( !checkParameters( params ) )
   {
      Print( "error: incorrect order parameters" );
      params.print();
      return;
   }
   
   sendOrder();
}

void BaseOrder::sendOrder()
{
   ticket = OrderSend( params.getSymbol(), params.getOperationType(),
                       params.volume, params.open_price, params.slippage, params.stoploss, params.takeprofit,
                       params.comment, params.custom_id, params.expiration, params.arrow_color );
                       
   if( ticket > 0 )
      opened = true;
   else
      opened = false;
}

bool BaseOrder::isOpened() const
{
   return opened;
}

bool BaseOrder::isClosed() const
{
   return closed;
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
      
   params.volume = OrderLots();
   params.open_price = OrderOpenPrice();
   //params.slippage недоступно
   params.stoploss = OrderStopLoss();
   params.takeprofit = OrderTakeProfit();
   params.comment = OrderComment();
   params.custom_id = OrderMagicNumber();
   params.expiration = OrderExpiration();
   //params.arrow_color недоступно
   
   params.open_time = OrderOpenTime();
   params.close_price = OrderClosePrice();
   params.close_time = OrderCloseTime();
   params.comission = OrderCommission();
   params.profit = OrderProfit();
   params.swap = OrderSwap();
   
   return true;
}

#endif