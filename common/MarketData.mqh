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
};

MarketData::MarketData( string symbol )
   : min_daily_price( MarketInfo( symbol, MODE_LOW ) )
   , max_daily_price( MarketInfo( symbol, MODE_HIGH ) )
{
}