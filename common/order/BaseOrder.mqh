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

#include "./../../common/kernel/UObject.mqh"
#include "./../../common/kernel/SPtr.mqh"
#include "./../../common/order/OrderParameters.mqh"

//базовый класс работы с ордером
class BaseOrder : public UObject
{
   public:
   
      //конструктор; принимает символ торгового инструмента и тип торговой операции
      BaseOrder( string symbol_string, int operation_type, int n_ticket = -1 );
      
      virtual ~BaseOrder();
      
      //функция открытия ордера
      void tryToOpen();
      
      //получить статус ордера (открыт / не открыт)
      bool isOpened() const;
      
      //получить статус ордера (был закрыт / не был закрыт)
      bool isClosed() const;
      
      //получить номер тикета (возвращает -1 в случае не переданного на сервер ордера)
      int getTicket() const;
      
   public:
      
      //получить параметры ордера
      SPtr<OrderParameters> getParameters() const;
      
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
   
      SPtr<OrderParameters> params;    //параметры ордера
   
      bool opened;               //статус ордера
      bool closed;               //статус закрытия ордера   
      int ticket;                //номер тикета
      
   public:
   
      //конструкторы копирования и присваивания
      BaseOrder( const BaseOrder& );
      void operator=( const BaseOrder& );
      
};

//+------------------------------------------------------------------+

BaseOrder::BaseOrder( string symbol_string, int operation_type, int n_ticket )
   : params( new OrderParameters(symbol_string, operation_type) )
   , opened( false )
   , closed( false )
   , ticket( n_ticket )
{
}

BaseOrder::BaseOrder( const BaseOrder &o )
   : params( new OrderParameters( o.params.obj() ) )
   , opened( o.opened )
   , closed( o.closed )
   , ticket( o.ticket )
{
}

void BaseOrder::operator=( const BaseOrder &o )
{
   params = new OrderParameters( o.params.obj() );
   opened = o.opened;
   closed = o.closed;
   ticket = o.ticket;
}

BaseOrder::~BaseOrder()
{
}

SPtr<OrderParameters> BaseOrder::getParameters() const
{
   return params;
}

void BaseOrder::updateParametersFromServer()
{
   if( ticket == -1 ) return; //еще не открыт
   
   OrderParameters *params_ptr = params.obj();
   
   bool update_result = params_ptr.fillParametersFromServer( ticket );
   
   if( !update_result )
   {
      Print( "error while updating order parameters from server; ticket = ", ticket );
      return;
   }
   
   if( params_ptr.close_time != 0 )
   {
      opened = false;
      closed = true;
   }
   else if( params_ptr.open_time != 0 )
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
   return params.obj().baseCheck();
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
      params.obj().print();
      return;
   }

   sendOrder();
}

void BaseOrder::sendOrder()
{
   OrderParameters *params_ptr = params.obj();

   ticket = OrderSend( params_ptr.getSymbol(), params_ptr.getOperationType(),
                       params_ptr.volume, params_ptr.open_price, params_ptr.slippage, 
                       params_ptr.stoploss, params_ptr.takeprofit,
                       params_ptr.comment, params_ptr.custom_id, params_ptr.expiration, params_ptr.arrow_color );
                     
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