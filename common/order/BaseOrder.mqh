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
      BaseOrder( string symbol_string, int operation_type, int n_ticket = -1 );
      
      ~BaseOrder();
      
      //функция открытия ордера
      void tryToOpen();
      
      //получить статус ордера (открыт / не открыт)
      bool isOpened() const;
      
      //получить статус ордера (был закрыт / не был закрыт)
      bool isClosed() const;
      
      //получить номер тикета (возвращает -1 в случае не переданного на сервер ордера)
      int getTicket() const;
      
   public:
   
      //задать параметры ордера
      void setParameters( const OrderParameters &p );
      
      //получить параметры ордера
      OrderParameters getParameters() const;
      
      //обновить параметры ордера с сервера
      void updateParametersFromServer();
      
   protected:
   
      //приготовление параметров и осуществление попыток отправить ордер
      virtual void processSend();
      
      //отправка ордера
      void sendOrder();
   
      //возвращает результат проверки параметров ордера
      virtual bool checkParameters() const;
      
   protected:
   
      OrderParameters *params;    //параметры ордера
   
      bool opened;               //статус ордера
      bool closed;               //статус закрытия ордера   
      int ticket;                //номер тикета
      
};

BaseOrder::BaseOrder( string symbol_string, int operation_type, int n_ticket )
   : params( new OrderParameters(symbol_string, operation_type) )
   , opened( false )
   , closed( false )
   , ticket( n_ticket )
{
}

BaseOrder::~BaseOrder()
{
   if( params != NULL )
      delete params;
}

void BaseOrder::setParameters( const OrderParameters &p )
{
   params = p;
}

OrderParameters BaseOrder::getParameters() const
{
   return params;
}

void BaseOrder::updateParametersFromServer()
{
   if( ticket == -1 ) return; //еще не открыт
   
   bool update_result = params.fillParametersFromServer( ticket );
   
   if( !update_result )
   {
      Print( "error while updating order parameters from server; ticket = ", ticket );
      return;
   }
   
   if( params.close_time != 0 )
   {
      opened = false;
      closed = true;
   }
   else if( params.open_time != 0 )
   {
      opened = true;
      closed = false;
   }
   else
   {
      opened = false;
      closed = false;
   }
}

bool BaseOrder::checkParameters() const
{
   return params.baseCheck();
}

void BaseOrder::tryToOpen()
{
   if( opened ) return; //уже открыт
   
   //этот метод могут переопределить потомки
   processSend();
   
   if( opened )
   {
      updateParametersFromServer();
   }
}

void BaseOrder::processSend()
{
   if( !checkParameters() )
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

#endif