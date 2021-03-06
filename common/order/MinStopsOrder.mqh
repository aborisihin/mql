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
   
      MinStopsOrder( string symbol_string,               //символ торгового инструмента
                     int operation_type,                 //тип торговой операции
                     double volume = 0.,                 //количество лотов; по умолчанию выставляется минимальный лот
                     unsigned int attempts_count = 0 );  //максимальное количество попыток открытия; по умолчанию не ограничено
      
   public:
   
      //виртуальная функция открытия ордера
      virtual void processSend();
      
   private:
   
      unsigned int attempts;
   
};

//+------------------------------------------------------------------+

MinStopsOrder::MinStopsOrder( string symbol_string,
                              int operation_type,
                              double volume,
                              unsigned int attempts_count )
   : BaseOrder( symbol_string, operation_type )
   , attempts( attempts_count )
{
   if( volume > 0. ) //установленный лот
   {
      params.obj().volume = volume; 
   }
   else //минимальный лот
   {
      MarketData m_data( params.obj().getSymbol() );
      params.obj().volume = m_data.min_lot;
      Print( "No lot value. Set ninimal: ", params.obj().volume );
   }
}

void MinStopsOrder::processSend()
{
   MarketData m_data( params.obj().getSymbol() );
   
   bool attempts_limit = (bool)( attempts > 0 );

   while( !attempts_limit || ( attempts_limit && attempts > 0 ) ) 
   {
      if( attempts_limit ) attempts--;
   
      //минимальная дистанция из параметров маркета
      int min_dist = m_data.stop_level;
      
      Print( "current market data: ask=", m_data.ask, " bid=", m_data.bid, " min_dist=", min_dist );
      
      //если спред больше минимальной дистанции, скорректируем ее
      int spread = (int)MathRound( MathAbs(m_data.ask - m_data.bid) / m_data.point );
      
      if( spread >= min_dist ) 
      {
         min_dist = spread + 1;
         Print( "correct min_dist value: ", min_dist );
      }
      
      params.obj().setMarketData( m_data, min_dist, min_dist );
      
      if( !checkParameters() )
      {
         Print( "error: incorrect order parameters" );
         //params.print();
         break;
      }
      
      Print( "try to open order: price=", params.obj().open_price, " sl=", params.obj().stoploss, " tp=", params.obj().takeprofit );
      
      // отправка ордера
      sendOrder();
      
      if( !opened )
      {
         int error = TradeErrorProcessor::getLastError();
         
         if( error == ERR_PRICE_CHANGED || 
             error == ERR_OFF_QUOTES || 
             error == ERR_TRADE_CONTEXT_BUSY ||
             error == ERR_INVALID_STOPS )
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