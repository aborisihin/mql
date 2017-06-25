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
   
      //конструкторы по-умолчанию, копирования и присваивания
      OrderParameters();
      OrderParameters( const OrderParameters &p );
      void operator=( const OrderParameters &p );
      
      //базовая проверка корректности параметров
      bool baseCheck() const;
      
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

OrderParameters::OrderParameters( const OrderParameters &p )
{
   symbol = p.symbol;
   cmd = p.cmd;
   volume = p.volume;
   price = p.price;
   slippage = p.slippage;
   stoploss = p.stoploss;
   takeprofit = p.takeprofit;
   comment = p.comment;
   magic = p.magic;
   expiration = p.expiration;
   arrow_color = p.arrow_color;
}

void OrderParameters::operator=( const OrderParameters &p )
{
   symbol = p.symbol;
   cmd = p.cmd;
   volume = p.volume;
   price = p.price;
   slippage = p.slippage;
   stoploss = p.stoploss;
   takeprofit = p.takeprofit;
   comment = p.comment;
   magic = p.magic;
   expiration = p.expiration;
   arrow_color = p.arrow_color;
}

bool OrderParameters::baseCheck() const
{
   if( symbol == "" ) return false;
   if( cmd != OP_BUY && cmd != OP_SELL &&
       cmd != OP_BUYLIMIT && cmd != OP_BUYSTOP &&
       cmd != OP_SELLLIMIT && cmd != OP_SELLSTOP  ) return false;
   if( volume <= 0. ) return false;
   if( price <= 0. ) return false;
   if( slippage < 0 ) return false;
   if( stoploss <= 0. ) return false;
   if( takeprofit <= 0. ) return false;
   if( cmd == OP_BUY || cmd == OP_BUYLIMIT || cmd == OP_BUYSTOP )
   {
      if( stoploss >= price ) return false;
      if( takeprofit <= price ) return false;
   }
   if( cmd == OP_SELL || cmd == OP_SELLLIMIT || cmd == OP_SELLSTOP )
   {
      if( stoploss <= price ) return false;
      if( takeprofit >= price ) return false;
   }
   
   return true;
}

#endif