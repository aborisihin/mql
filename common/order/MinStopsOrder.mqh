//+------------------------------------------------------------------+
//|                                                MinStopsOrder.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef MINSTOPSORDER_H
#define MINSTOPSORDER_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

#include "./../../common/order/BaseOrder.mqh"
#include "./../../common/info/MarketData.mqh"
#include "./../../common/info/TradeErrorProcessor.mqh"

//класс ордера с минимальными стоп-значениями
//при отсутствии критических ошибок сервера, может производиться несколько попыток открытия
class MinStopsOrder : public BaseOrder
{
   public:
   
      MinStopsOrder( string symbol_string,            //символ торгового инструмента
                     int operation_type,              //тип торговой операции
                     double volume );                 //количество лотов
      
   public:
   
      //виртуальная функция открытия ордера
      virtual void tryOpen();
};

MinStopsOrder::MinStopsOrder( string symbol_string,
                              int operation_type,
                              double volume )
   : BaseOrder( symbol_string, operation_type )
{
   params.volume = volume;
}

void MinStopsOrder::tryOpen()
{
   MarketData m_data( params.getSymbol() );

   while( true ) //попытки открытия ордера
   {
      int min_dist = m_data.stop_level;
      
      params.setMarketParameters( m_data, min_dist, min_dist );
      
      //params.print();
      
      if( !checkParameters( params ) )
      {
         Print( "error: incorrect order parameters" );
         break;
      }
      
      Print( "try to open order: price=", params.price, " sl=", params.stoploss, " tp=", params.takeprofit, " min_dist=", min_dist );
      
      sendOrder();
      
      if( !opened )
      {
         int error = TradeErrorProcessor::getLastError();
         
         if( error == ERR_PRICE_CHANGED || 
             error == ERR_OFF_QUOTES || 
             error == ERR_TRADE_CONTEXT_BUSY ||
             error == ERR_INVALID_STOPS )
         {
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