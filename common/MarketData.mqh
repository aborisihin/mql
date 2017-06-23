//+------------------------------------------------------------------+
//|                                                   MarketData.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

//агрегатор данных по финансовому инструменту
class MarketData
{
   public:
   
      //конструктор, принимающий строковое наименование финансового инструмента
      MarketData( string symbol );
      
   public:
   
      const double min_daily_price;    //минимальная дневная цена
      const double max_daily_price;    //максимальная дневная цена
      const datetime last_price_time;  //время поступления последней котировки
      const double bid;                //последняя поступившая цена предложения
      const double ask;                //последняя поступившая цена продажи
      const double point;              //размер пункта в валюте котировки
      const int digits;                //количество цифр после запятой в цене инструмента
      const int spread;                //спред в пунктах
      const int stoplevel;             //минимально допустимый уровень stop_loss / take_profit в пунктах
                                       //нулевое значение означает либо отсутствие ограничений, либо использование динамических уровней
      const double lot_size;           //размер контракта в базовой валюте инструмента
      const double tick_value;         //размер минимального изменения цены инструмента в валюте депозита
      const double tick_size;          //минимальный шаг изменения цены инструмента в пунктах
      const double swap_long;          //размер свопа для ордеров на покупку
      const double swap_short;         //размер свопа для ордеров на продажу
      const datetime starting;         //календарная дата начала торгов (для фьючерсов)
      const datetime expiration;       //календарная дата конца торгов (для фьючерсов)
      const bool trade_allowed;        //разрешение торгов по указанному инструменту
      const double min_lot;            //минимальный размер лота
      const double lot_step;           //шаг изменения размера лота
      const double max_lot;            //максимальный размер лота
      const int swap_type;             //метод вычисления свопов.
                                       //0 - в пунктах, 1 - в базовой валюте инструмента, 2 - в процентах, 3 - в валюте залоговых средств
      const int profit_calc_mode;      //способ расчета прибыли
                                       //0 - Forex, 1 - CFD, 2 - Futures
      const int margin_calc_mode;      //способ расчета залоговых средств
                                       //0 - Forex, 1 - CFD, 2 - Futures, 3 - CFD на индексы
      const double margin_init;        //начальные залоговые требования для одного лота
      const double margin_maintenance; //размер залоговых средств для поддержки открытых ордеров в расчете на один лот
      const double margin_hedget;      //маржа, взимаемая с перекрытых ордеров в расчете на один лот
      const double margin_required;    //размер свободных средств, необходимых для открытия одного лота на покупку
      const int freeze_level;          //уровень заморозки ордеров в пунктах
      const bool closeby_allowed;      //разрешение на закрытие встречных ордеров
};

MarketData::MarketData( string symbol )
   : min_daily_price( MarketInfo( symbol, MODE_LOW ) )
   , max_daily_price( MarketInfo( symbol, MODE_HIGH ) )
   , last_price_time( (datetime)MarketInfo( symbol, MODE_TIME ) )
   , bid( MarketInfo( symbol, MODE_BID ) )
   , ask( MarketInfo( symbol, MODE_ASK ) )
   , point( MarketInfo( symbol, MODE_POINT ) )
   , digits( (int)MarketInfo( symbol, MODE_DIGITS ) )
   , spread( (int)MarketInfo( symbol, MODE_SPREAD ) )
   , stoplevel( (int)MarketInfo( symbol, MODE_STOPLEVEL ) )
   , lot_size( MarketInfo( symbol, MODE_LOTSIZE ) )
   , tick_value( MarketInfo( symbol, MODE_TICKVALUE ) )
   , tick_size( MarketInfo( symbol, MODE_TICKSIZE ) )
   , swap_long( MarketInfo( symbol, MODE_SWAPLONG ) )
   , swap_short( MarketInfo( symbol, MODE_SWAPSHORT ) )
   , starting( (datetime)MarketInfo( symbol, MODE_STARTING ) )
   , expiration( (datetime)MarketInfo( symbol, MODE_EXPIRATION ) )
   , trade_allowed( (bool)MarketInfo( symbol, MODE_TRADEALLOWED ) )
   , min_lot( MarketInfo( symbol, MODE_MINLOT ) )
   , lot_step( MarketInfo( symbol, MODE_LOTSTEP ) )
   , max_lot( MarketInfo( symbol, MODE_MAXLOT ) )
   , swap_type( (int)MarketInfo( symbol, MODE_SWAPTYPE ) )
   , profit_calc_mode( (int)MarketInfo( symbol, MODE_PROFITCALCMODE ) )
   , margin_calc_mode( (int)MarketInfo( symbol, MODE_MARGINCALCMODE ) )
   , margin_init( MarketInfo( symbol, MODE_MARGININIT ) )
   , margin_maintenance( MarketInfo( symbol, MODE_MARGINMAINTENANCE ) )
   , margin_hedget( MarketInfo( symbol, MODE_MARGINHEDGED ) )
   , margin_required( MarketInfo( symbol, MODE_MARGINREQUIRED ) )
   , freeze_level( (int)MarketInfo( symbol, MODE_FREEZELEVEL ) )
   , closeby_allowed( (bool)MarketInfo( symbol, MODE_CLOSEBY_ALLOWED ) )
{
}