//+------------------------------------------------------------------+
//|                                              OrderParameters.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef ORDERPARAMETERS_H
#define ORDERPARAMETERS_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

//класс-контейнер параметров ордера
class OrderParameters
{
   public:
   
      OrderParameters();
      
      string   symbol;              // символ
      int      cmd;                 // торговая операция
      double   volume;              // количество лотов
      double   price;               // цена
      int      slippage;            // проскальзывание
      double   stoploss;            // stop loss
      double   takeprofit;          // take profit
      string   comment;             // комментарий
      int      magic;               // идентификатор
      datetime expiration;          // срок истечения ордера
      color    arrow_color;         // цвет  

};

OrderParameters::OrderParameters()
   : symbol( "" )
   , cmd( -1 )
   , volume( 0 )
   , price( 0 )
   , slippage( 0 )
   , stoploss( 0 )
   , takeprofit( 0 )
   , comment( "" )
   , magic( 0 )
   , expiration( 0 )
   , arrow_color( clrNONE )
{
}

#endif