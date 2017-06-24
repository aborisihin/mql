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
      bool setParameters( OrderParameters &p );
      
      //получить параметры ордера
      OrderParameters& getParameters() const;
      
   public:
   
      //виртуальная функция открытия ордера
      virtual void tryOpen() = 0;
      
   protected:
   
      bool opened;
      int ticket;
      
      OrderParameters params;    //параметры ордера
      
      //возвращает результат первичной проверки параметров ордера
      virtual bool checkParameters( OrderParameters &p );
      
};

BaseOrder::BaseOrder( string symbol_string, int operation_type )
   : opened( false )
   , ticket( -1 )
   , params()
{
   params.symbol = symbol_string;
   params.cmd = operation_type;
}

bool BaseOrder::checkParameters( OrderParameters &p )
{
   return true;
}

bool BaseOrder::setParameters( OrderParameters &p )
{
   bool check_result = checkParameters( p );
   
   if( check_result )
      params = p;
      
   return check_result;
}

OrderParameters& BaseOrder::getParameters() const
{
   return params;
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