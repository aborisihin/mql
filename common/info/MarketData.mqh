//+------------------------------------------------------------------+
//|                                                   MarketData.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef MARKETDATA_H
#define MARKETDATA_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

//агрегатор данных по финансовому инструменту
class MarketData
{
   public:
   
      //конструктор, принимающий строковое наименование финансового инструмента
      MarketData( string symbol );
      
      //обновить данные
      bool updateData();
      
   public:
   
      double min_daily_price;    //минимальная дневная цена
      double max_daily_price;    //максимальная дневная цена
      datetime last_price_time;  //время поступления последней котировки
      double bid;                //последняя поступившая цена предложения
      double ask;                //последняя поступившая цена продажи
      double point;              //размер пункта в валюте котировки
      int digits;                //количество цифр после запятой в цене инструмента
      int spread;                //спред в пунктах
      int stop_level;            //минимально допустимый уровень stop_loss / take_profit в пунктах
                                 //нулевое значение означает либо отсутствие ограничений, либо использование динамических уровней
      double lot_size;           //размер контракта в базовой валюте инструмента
      double tick_value;         //размер минимального изменения цены инструмента в валюте депозита
      double tick_size;          //минимальный шаг изменения цены инструмента в пунктах
      double swap_long;          //размер свопа для ордеров на покупку
      double swap_short;         //размер свопа для ордеров на продажу
      datetime starting;         //календарная дата начала торгов (для фьючерсов)
      datetime expiration;       //календарная дата конца торгов (для фьючерсов)
      bool trade_allowed;        //разрешение торгов по указанному инструменту
      double min_lot;            //минимальный размер лота
      double lot_step;           //шаг изменения размера лота
      double max_lot;            //максимальный размер лота
      int swap_type;             //метод вычисления свопов.
                                 //0 - в пунктах, 1 - в базовой валюте инструмента, 2 - в процентах, 3 - в валюте залоговых средств
      int profit_calc_mode;      //способ расчета прибыли
                                 //0 - Forex, 1 - CFD, 2 - Futures
      int margin_calc_mode;      //способ расчета залоговых средств
                                 //0 - Forex, 1 - CFD, 2 - Futures, 3 - CFD на индексы
      double margin_init;        //начальные залоговые требования для одного лота
      double margin_maintenance; //размер залоговых средств для поддержки открытых ордеров в расчете на один лот
      double margin_hedget;      //маржа, взимаемая с перекрытых ордеров в расчете на один лот
      double margin_required;    //размер свободных средств, необходимых для открытия одного лота на покупку
      int freeze_level;          //уровень заморозки ордеров в пунктах
      bool closeby_allowed;      //разрешение на закрытие встречных ордеров
      
   private:
      
      void fillFromMarket();
      
   private:
   
      const string trade_symbol;
   
};

//+------------------------------------------------------------------+

MarketData::MarketData( string symbol )
   : trade_symbol( symbol )
{
   fillFromMarket();
}

bool MarketData::updateData()
{
   if( !RefreshRates() ) return false;
   
   fillFromMarket();
   
   return true;
}

void MarketData::fillFromMarket()
{
   min_daily_price = MarketInfo( trade_symbol, MODE_LOW );
   max_daily_price = MarketInfo( trade_symbol, MODE_HIGH );
   last_price_time = (datetime)MarketInfo( trade_symbol, MODE_TIME );
   bid = MarketInfo( trade_symbol, MODE_BID );
   ask = MarketInfo( trade_symbol, MODE_ASK );
   point = MarketInfo( trade_symbol, MODE_POINT );
   digits = (int)MarketInfo( trade_symbol, MODE_DIGITS );
   spread = (int)MarketInfo( trade_symbol, MODE_SPREAD );
   stop_level = (int)MarketInfo( trade_symbol, MODE_STOPLEVEL );
   lot_size = MarketInfo( trade_symbol, MODE_LOTSIZE );
   tick_value = MarketInfo( trade_symbol, MODE_TICKVALUE );
   tick_size = MarketInfo( trade_symbol, MODE_TICKSIZE );
   swap_long = MarketInfo( trade_symbol, MODE_SWAPLONG );
   swap_short = MarketInfo( trade_symbol, MODE_SWAPSHORT );
   starting = (datetime)MarketInfo( trade_symbol, MODE_STARTING );
   expiration = (datetime)MarketInfo( trade_symbol, MODE_EXPIRATION );
   trade_allowed = (bool)MarketInfo( trade_symbol, MODE_TRADEALLOWED );
   min_lot = MarketInfo( trade_symbol, MODE_MINLOT );
   lot_step = MarketInfo( trade_symbol, MODE_LOTSTEP );
   max_lot = MarketInfo( trade_symbol, MODE_MAXLOT );
   swap_type = (int)MarketInfo( trade_symbol, MODE_SWAPTYPE );
   profit_calc_mode = (int)MarketInfo( trade_symbol, MODE_PROFITCALCMODE );
   margin_calc_mode = (int)MarketInfo( trade_symbol, MODE_MARGINCALCMODE );
   margin_init = MarketInfo( trade_symbol, MODE_MARGININIT );
   margin_maintenance = MarketInfo( trade_symbol, MODE_MARGINMAINTENANCE );
   margin_hedget = MarketInfo( trade_symbol, MODE_MARGINHEDGED );
   margin_required = MarketInfo( trade_symbol, MODE_MARGINREQUIRED );
   freeze_level = (int)MarketInfo( trade_symbol, MODE_FREEZELEVEL );
   closeby_allowed = (bool)MarketInfo( trade_symbol, MODE_CLOSEBY_ALLOWED );
}

#endif