//+------------------------------------------------------------------+
//|                                          TradeErrorProcessor.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef TRADEERRORPROCESSOR_H
#define TRADEERRORPROCESSOR_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

#include <stderror.mqh>
//#include <stdlib.mqh>

//процессор обработки торговых ошибок
class TradeErrorProcessor
{     
   public:
   
      //получить код последней ошибки
      static int getLastError();
      
      //уведомить в логе о последней ошибке посредством метода Print()
      static void notifyLastError();
      
      //получить строковое описание ошибки
      static string getDescription( int error );
      
   private:
   
      TradeErrorProcessor();
      TradeErrorProcessor( TradeErrorProcessor& );
      TradeErrorProcessor operator=( TradeErrorProcessor& );
   
};

//+------------------------------------------------------------------+

int TradeErrorProcessor::getLastError()
{
   return GetLastError();
}

void TradeErrorProcessor::notifyLastError()
{
   Print( "TradeErrorProcessor: ", getDescription( getLastError() ) );
}

string TradeErrorProcessor::getDescription( int error )
{
   //return ErrorDescription( error );
   
   switch( error )
   {
      case ERR_NO_ERROR: return "No errors";
      case ERR_NO_RESULT: return "No error, but no result";
      case ERR_COMMON_ERROR: return "Common error";
      case ERR_INVALID_TRADE_PARAMETERS: return "Invalid trade parameters";
      case ERR_SERVER_BUSY: return "Trade server is busy";
      case ERR_OLD_VERSION: return "Client terminal's old version";
      case ERR_NO_CONNECTION: return "No connection to trade server";
      case ERR_NOT_ENOUGH_RIGHTS: return "Not enough rights";
      case ERR_TOO_FREQUENT_REQUESTS: return "Too frequent requests";
      case ERR_MALFUNCTIONAL_TRADE: return "Not allowed operation";
      case ERR_ACCOUNT_DISABLED: return "Account is disabled";
      case ERR_INVALID_ACCOUNT: return "Invalid account number";
      case ERR_TRADE_TIMEOUT: return "Trade timeout";
      case ERR_INVALID_PRICE: return "Invalid price";
      case ERR_INVALID_STOPS: return "Invalid stops";
      case ERR_INVALID_TRADE_VOLUME: return "Invalid trade volume";
      case ERR_MARKET_CLOSED: return "Market is closed";
      case ERR_TRADE_DISABLED: return "Trade operations is disabled";
      case ERR_NOT_ENOUGH_MONEY: return "Not enough money";
      case ERR_PRICE_CHANGED: return "Price was changed";
      case ERR_OFF_QUOTES: return "Off quotes";
      case ERR_BROKER_BUSY: return "Broker is busy";
      case ERR_REQUOTE: return "Requote";
      case ERR_ORDER_LOCKED: return "Order is locked and already processing";
      case ERR_LONG_POSITIONS_ONLY_ALLOWED: return "Long positions only allowed";
      case ERR_TOO_MANY_REQUESTS: return "Too many requests";
      case ERR_TRADE_MODIFY_DENIED: return "Trade modify denied";
      case ERR_TRADE_CONTEXT_BUSY: return "Trade context is busy";
      case ERR_TRADE_EXPIRATION_DENIED: return "Trade expiration date is denied";
      case ERR_TRADE_TOO_MANY_ORDERS: return "Too many orders";
      case ERR_TRADE_HEDGE_PROHIBITED: return "Trade hedge prohibited";
      case ERR_TRADE_PROHIBITED_BY_FIFO: return "Trade prohibited by FIFO";
      case ERR_TRADE_NOT_ALLOWED: return "Trade operations not allowed by settings";

      default: return "Unknown trade error. Code = " + IntegerToString(error);
   }
   
   return "";
}

#endif