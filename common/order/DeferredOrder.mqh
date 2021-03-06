//+------------------------------------------------------------------+
//|                                                DeferredOrder.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef NOSTOPSORDER_H
#define NOSTOPSORDER_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

#include "./../../common/order/MinStopsOrder.mqh"
#include "./../../common/info/MarketData.mqh"
#include "./../../common/info/TradeErrorProcessor.mqh"

//класс отложенного ордера с минимальными стоп-значениями
class DeferredOrder : public MinStopsOrder
{
   public:
   
      DeferredOrder( string symbol_string,               //символ торгового инструмента
                     int operation_type,                 //тип торговой операции
                     double open_price,                  //цена открытия
                     double volume = 0.);                //количество лотов; по умолчанию выставляется минимальный лот
                     
   public:
   
      //виртуальная функция открытия ордера
      virtual void processSend();
      
      //виртуальная функция проверки параметров ордера
      virtual bool checkParameters() const;
   
};

//+------------------------------------------------------------------+

DeferredOrder::DeferredOrder( string symbol_string,
                            int operation_type,
                            double open_price,
                            double volume )
   : MinStopsOrder( symbol_string, operation_type, volume )
{
   params.obj().open_price = open_price;
}

bool DeferredOrder::checkParameters() const
{
   if( !MinStopsOrder::checkParameters() )
      return false;
   
   //проверим цену открытия отложенного ордера
   MarketData m_data( params.obj().getSymbol() );
   
   int op_type = params.obj().getOperationType();
   double open_price = params.obj().open_price;
      
   if( op_type == OP_BUYLIMIT )
   {
      if( open_price >= m_data.ask ) return false;
   }
   else if( op_type == OP_BUYSTOP )
   {
      if( open_price <= m_data.ask ) return false;
   }
   else if( op_type == OP_SELLLIMIT )
   {
      if( open_price <= m_data.bid ) return false;
   }
   else if( op_type == OP_SELLSTOP )
   {
      if( open_price >= m_data.bid ) return false;
   }
      
   return true;
}

void DeferredOrder::processSend()
{
   MarketData m_data( params.obj().getSymbol() );

   while( true )
   {
      if( !checkParameters() )
      {
         Print( "error: incorrect order parameters" );
         //params.print();
         break;
      }
      
      Print( "try to open order: price=", params.obj().open_price, " volume=", params.obj().volume );
      
      // отправка ордера
      sendOrder();
      
      if( !opened )
      {
         int error = TradeErrorProcessor::getLastError();
         
         if( error == ERR_SERVER_BUSY || 
             error == ERR_BROKER_BUSY || 
             error == ERR_TRADE_CONTEXT_BUSY )
         {
            //система занята, обновимся и попробуем снова
            Print( "regular error: ", TradeErrorProcessor::getDescription( error )  );
            Print( "update..." );
            
            Sleep(1000); //подождем 1 секунду
            continue;
         }
         else
         {
            Print( "other error: ", TradeErrorProcessor::getDescription( error ) );
            break;
         }
      }
      else
      {
         Print( "order was opened!" );
         break;
      }
   }
}

#endif