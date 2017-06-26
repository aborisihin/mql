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

//класс ордера с минимальными стоп-значениями
//при отсутствии критических ошибок сервера, может производиться несколько попыток открытия
class MinStopsOrder : public BaseOrder
{
   public:
   
      MinStopsOrder( string symbol_string,            //символ торгового инструмента
                     int operation_type,              //тип торговой операции
                     double volume,                   //количество лотов
                     int slippage );                  //максимальное проскальзывание
      
   public:
   
      //виртуальная функция открытия ордера
      virtual void tryOpen();
};

MinStopsOrder::MinStopsOrder( string symbol_string,
                              int operation_type,
                              double volume,
                              int slippage )
   : BaseOrder( symbol_string, operation_type )
{
   params.volume = volume;
   params.slippage = slippage;
}

void MinStopsOrder::tryOpen()
{
   MarketData m_data( params.getSymbol() );

   while( true ) //попытки открытия ордера
   {
      int current_min_dist = m_data.stop_level;
      
      params.setMarketParameters( m_data, current_min_dist, current_min_dist );
      
      if( !checkParameters( params ) )
      {
         Print( "error: incorrect order parameters" );
         break;
      }
   }
}

#endif