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

#include "OrderParameters.mqh"

//базовый класс работы с ордером
class BaseOrder
{
   public:
   
      //конструктор; принимает символ торгового инструмента и тип торговой операции
      BaseOrder( string symbol_string, int operation_type );
      
      //получить статус ордера (открыт / не открыт)
      bool wasOpened() const;
      
      //получить номер тикета (возвращает -1 в случае не открытого ордера)
      int getTicket() const;
      
      //задать параметры ордера; возвращает результат первичной проверки параметров и факт задания
      bool setParameters( const OrderParameters &p );
      
      //получить параметры ордера
      OrderParameters getParameters() const;
      
   public:
   
      //виртуальная функция открытия ордера
      virtual void tryOpen() = 0;
      
   protected:
   
      //возвращает результат проверки параметров ордера
      virtual bool checkParameters( const OrderParameters &p ) const;
      
      //отправка ордера
      virtual void sendOrder();
      
   protected:
   
      OrderParameters params;    //параметры ордера
   
      bool opened;               //статус ордера
      int ticket;                //номер тикета
      
};

BaseOrder::BaseOrder( string symbol_string, int operation_type )
   : params( symbol_string, operation_type )
   , opened( false )
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

void BaseOrder::sendOrder()
{
   ticket = OrderSend( params.getSymbol(), params.getOperation(),
                       params.volume, params.price, params.slippage, params.stoploss, params.takeprofit,
                       params.comment, params.custom_id, params.expiration, params.arrow_color );
                       
   if( ticket > 0 )
      opened = true;
   else
      opened = false;
}

bool BaseOrder::wasOpened() const
{
   return opened;
}

int BaseOrder::getTicket() const
{
   return ticket;
}

#endif