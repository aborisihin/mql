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

#include "./../../common/kernel/UObject.mqh"
#include "./../../common/info/MarketData.mqh"

//класс-контейнер параметров ордера
class OrderParameters : public UObject
{
   public:
   
      //конструктор; принимает символ торгового инструмента и тип торговой операции
      OrderParameters( string symbol_string, int operation_type );
      virtual ~OrderParameters();
      
      //получить неизменяемые параметры ордера
      string getSymbol() const;
      int getOperationType() const;
      
      //базовая проверка корректности параметров для открытия ордера
      bool baseCheck() const;
      
      //установить уровень price, stoploss и takeprofit из данных MarketData в зависимости от типа ордера
      void setMarketData( MarketData &m_data, int sl_points, int tp_points );
      
      //получить параметры имеющегося ордера на сервере
      bool fillParametersFromServer( int ticket_number );
      
      //распечатать параметры для открытия ордера
      void print() const;
      
   public:
      
      double   volume;              // количество лотов
      double   open_price;          // цена открытия
      int      slippage;            // проскальзывание
      double   stoploss;            // stop loss
      double   takeprofit;          // take profit
      
      //необязательные параметры
      string   comment;             // комментарий
      int      custom_id;           // пользовательский идентификатор (magic в официальной документации)
      datetime expiration;          // срок истечения ордера
      color    arrow_color;         // цвет
      
      //параметры, доступные после обработки на сервере
      datetime open_time;           //время открытия
      double close_price;           //цена закрытия
      datetime close_time;          //время закрытия
      double comission;             //комиссия
      double profit;                //чистая прибыль; для открытых ордеров - текущая нереализованная прибыль, для закрытых - зафиксированная
      double swap;                  //значение свопа
      
   protected:
   
      string   symbol;              // символ
      int      cmd;                 // торговая операция
      
   public:
   
      //конструкторы копирования и присваивания
      OrderParameters( const OrderParameters &p );
      void operator=( const OrderParameters &p );

};

//+------------------------------------------------------------------+

OrderParameters::OrderParameters( string symbol_string, int operation_type )
   : volume( 0 )
   , open_price( 0 )
   , slippage( 0 )
   , stoploss( 0 )
   , takeprofit( 0 )
   , comment( "" )
   , custom_id( 0 )
   , expiration( 0 )
   , arrow_color( clrNONE )
   , open_time( 0 )
   , close_price( 0 )
   , close_time( 0 )
   , comission( 0 )
   , profit( 0 )
   , swap( 0 )
   , symbol( symbol_string )
   , cmd( operation_type )
{
}

OrderParameters::OrderParameters( const OrderParameters &p )
   : volume( p.volume )
   , open_price( p.open_price )
   , slippage( p.slippage )
   , stoploss( p.stoploss )
   , takeprofit( p.takeprofit )
   , comment( p.comment )
   , custom_id( p.custom_id )
   , expiration( p.expiration )
   , arrow_color( p.arrow_color )
   , open_time( p.open_time )
   , close_price( p.close_price )
   , close_time( p.close_time )
   , comission( p.comission )
   , profit( p.profit )
   , swap( p.swap )
   , symbol( p.symbol )
   , cmd( p.cmd )
{
}

void OrderParameters::operator=( const OrderParameters &p )
{
   symbol = p.symbol;
   cmd = p.cmd;
   
   volume = p.volume;
   open_price = p.open_price;
   slippage = p.slippage;
   stoploss = p.stoploss;
   takeprofit = p.takeprofit;
   comment = p.comment;
   custom_id = p.custom_id;
   expiration = p.expiration;
   arrow_color = p.arrow_color;
   
   open_time = p.open_time;
   close_price = p.close_price;
   close_time = p.close_time;
   comission = p.comission;
   profit = p.profit;
   swap = p.swap;
}

OrderParameters::~OrderParameters()
{
}

void OrderParameters::setMarketData( MarketData &m_data, int sl_points, int tp_points )
{
   if( cmd == OP_BUY || cmd == OP_BUYLIMIT || cmd == OP_BUYSTOP )
   {
      open_price = m_data.ask;
      
      if( sl_points > 0. )
         stoploss = NormalizeDouble( m_data.bid - sl_points * m_data.point, m_data.digits);
      else
         stoploss = 0.;
            
      if( tp_points > 0. )
         takeprofit = NormalizeDouble( m_data.bid + tp_points * m_data.point, m_data.digits );
      else
         takeprofit = 0.;
   }
   else if( cmd == OP_SELL || cmd == OP_SELLLIMIT || cmd == OP_SELLSTOP )
   {
      open_price = m_data.bid;
      
      if( sl_points > 0. )
         stoploss = NormalizeDouble( m_data.ask + sl_points * m_data.point, m_data.digits );
      else
         stoploss = 0.;
      
      if( tp_points > 0. )
         takeprofit = NormalizeDouble( m_data.ask - tp_points * m_data.point, m_data.digits );
      else
         takeprofit = 0.;
   }
   else
   {
      open_price = 0.;
      stoploss = 0.;
      takeprofit = 0.;
   }
}

bool OrderParameters::fillParametersFromServer( int ticket_number )
{
   bool order_select_result = OrderSelect( ticket_number, SELECT_BY_TICKET );
   
   if( !order_select_result )
      return false;
   
   if( symbol != OrderSymbol() ) //ордер по тикету не соответствует текущему
      return false;
      
   if( cmd != OrderType() ) //ордер по тикету не соответствует текущему
      return false;
      
   volume = OrderLots();
   open_price = OrderOpenPrice();
   //slippage недоступно
   stoploss = OrderStopLoss();
   takeprofit = OrderTakeProfit();
   comment = OrderComment();
   custom_id = OrderMagicNumber();
   expiration = OrderExpiration();
   //arrow_color недоступно
   
   //доступны для отправленных ордеров
   open_time = OrderOpenTime();
   close_price = OrderClosePrice();
   close_time = OrderCloseTime();
   comission = OrderCommission();
   profit = OrderProfit();
   swap = OrderSwap();
   
   return true;
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
   if( open_price <= 0. ) return false;
   if( slippage < 0 ) return false;
   if( stoploss < 0. ) return false;
   if( takeprofit < 0. ) return false;
   
   if( stoploss > 0. && takeprofit > 0. )
   {
      if( cmd == OP_BUY || cmd == OP_BUYLIMIT || cmd == OP_BUYSTOP )
      {
         if( stoploss >= takeprofit ) return false;
      }
      if( cmd == OP_SELL || cmd == OP_SELLLIMIT || cmd == OP_SELLSTOP )
      {
         if( stoploss <= takeprofit ) return false;
      }
   }
   
   return true;
}

void OrderParameters::print() const
{
   Print( "=================" );
   Print( "takeprofit = ", takeprofit );
   Print( "stoploss = ", stoploss );
   Print( "slippage = ", slippage );
   Print( "open_price = ", open_price );
   Print( "volume = ", volume );
   Print( "cmd = ", cmd );
   Print( "symbol = ", symbol );
   Print( "Order parameters:" );
   Print( "=================" );
}

#endif