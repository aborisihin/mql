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

#include "./../../common/info/MarketData.mqh"

//класс-контейнер параметров ордера
class OrderParameters
{
   public:
   
      //конструкторы по-умолчанию, копирования и присваивания
      OrderParameters( string symbol_string, int operation_type );
      OrderParameters( const OrderParameters &p );
      void operator=( const OrderParameters &p );
      
      //установить уровень price, stoploss и takeprofit из данных MarketData
      void setMarketParameters( MarketData &m_data, int sl_points, int tp_points );
      
      //получить неизменяемые параметры ордера
      string getSymbol() const;
      int getOperationType() const;
      
      //базовая проверка корректности параметров
      bool baseCheck() const;
      
      //распечатать параметры
      void print() const;
      
   public:
      
      double   volume;              // количество лотов
      double   price;               // цена
      int      slippage;            // проскальзывание
      double   stoploss;            // stop loss
      double   takeprofit;          // take profit
      
      //необязательные параметры
      string   comment;             // комментарий
      int      custom_id;           // пользовательский идентификатор (magic в официальной документации)
      datetime expiration;          // срок истечения ордера
      color    arrow_color;         // цвет  
      
   protected:
   
      string   symbol;              // символ
      int      cmd;                 // торговая операция

};

OrderParameters::OrderParameters( string symbol_string, int operation_type )
   : volume( 0 )
   , price( 0 )
   , slippage( 0 )
   , stoploss( 0 )
   , takeprofit( 0 )
   , comment( "" )
   , custom_id( 0 )
   , expiration( 0 )
   , arrow_color( clrNONE )
   , symbol( symbol_string )
   , cmd( operation_type )
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
   custom_id = p.custom_id;
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
   custom_id = p.custom_id;
   expiration = p.expiration;
   arrow_color = p.arrow_color;
}

void OrderParameters::setMarketParameters( MarketData &m_data, int sl_points, int tp_points )
{
   if( cmd == OP_BUY || cmd == OP_BUYLIMIT || cmd == OP_BUYSTOP )
   {
      price = m_data.ask;
      
      if( sl_points > 0. )
         stoploss = m_data.bid - sl_points * m_data.point;
      else
         stoploss = 0.;
            
      if( tp_points > 0. )
         takeprofit = m_data.bid + tp_points * m_data.point;
      else
         takeprofit = 0.;
   }
   else if( cmd == OP_SELL || cmd == OP_SELLLIMIT || cmd == OP_SELLSTOP )
   {
      price = m_data.bid;
      
      if( sl_points > 0. )
         stoploss = m_data.ask + sl_points * m_data.point;
      else
         stoploss = 0.;
      
      if( tp_points > 0. )
         takeprofit = m_data.ask - tp_points * m_data.point;
      else
         takeprofit = 0.;
   }
   else
   {
      price = 0.;
      stoploss = 0.;
      takeprofit = 0.;
   }
}

string OrderParameters::getSymbol() const
{
   return symbol;
}

int OrderParameters::getOperationType() const
{
   return cmd;
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
   if( stoploss < 0. ) return false;
   if( takeprofit < 0. ) return false;
   if( cmd == OP_BUY || cmd == OP_BUYLIMIT || cmd == OP_BUYSTOP )
   {
      if( stoploss >= takeprofit ) return false;
   }
   if( cmd == OP_SELL || cmd == OP_SELLLIMIT || cmd == OP_SELLSTOP )
   {
      if( stoploss <= takeprofit ) return false;
   }
   
   return true;
}

void OrderParameters::print() const
{
   Print( "=================" );
   Print( "takeprofit = ", takeprofit );
   Print( "stoploss = ", stoploss );
   Print( "slippage = ", slippage );
   Print( "price = ", price );
   Print( "volume = ", volume );
   Print( "cmd = ", cmd );
   Print( "symbol = ", symbol );
   Print( "Order parameters:" );
   Print( "=================" );
}

#endif