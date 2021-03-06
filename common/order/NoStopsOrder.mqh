//+------------------------------------------------------------------+
//|                                                 NoStopsOrder.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef NOSTOPSORDER_H
#define NOSTOPSORDER_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

#include "./../../common/order/BaseOrder.mqh"
#include "./../../common/info/MarketData.mqh"
#include "./../../common/info/TradeErrorProcessor.mqh"

//класс ордера с нулевыми стоп-значениями
//при отсутствии критических ошибок сервера, может производиться несколько попыток открытия
class NoStopsOrder : public BaseOrder
{
   public:
   
      NoStopsOrder( string symbol_string,               //символ торгового инструмента
                    int operation_type,                 //тип торговой операции
                    double volume = 0. );               //количество лотов; по умолчанию выставляется минимальный лот
                     
   public:
   
      //виртуальная функция открытия ордера
      virtual void processSend();
   
};

//+------------------------------------------------------------------+

NoStopsOrder::NoStopsOrder( string symbol_string,
                            int operation_type,
                            double volume )
   : BaseOrder( symbol_string, operation_type )
{
   if( volume > 0. ) //установленный лот
   {
      params.obj().volume = volume; 
   }
   else //минимальный лот
   {
      MarketData m_data( params.obj().getSymbol() );
      params.obj().volume = m_data.min_lot;
   }
}

void NoStopsOrder::processSend()
{
   MarketData m_data( params.obj().getSymbol() );

   while( true )
   {
      params.obj().setMarketData( m_data, 0, 0 );
      
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
         
         if( error == ERR_PRICE_CHANGED || 
             error == ERR_OFF_QUOTES || 
             error == ERR_TRADE_CONTEXT_BUSY )
         {
            //ошибки цен или система занята, обновимся и попробуем снова
            Print( "regular error: ", TradeErrorProcessor::getDescription( error )  );
            Print( "update..." );
            
            while( !m_data.updateData() ) {}
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