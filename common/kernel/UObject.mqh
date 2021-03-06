//+------------------------------------------------------------------+
//|                                                      UObject.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef UOBJECT_H
#define UOBJECT_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

//Базовый класс для объектов, реализующих механизм подсчета ссылок
class UObject
{
   public:
   
      UObject();
      virtual ~UObject();
      
   public:
   
      //увеличение числа ссылок на объект; возвращает текущее состояние счетчика
      virtual long AddRef();
      
      //уменьшение числа ссылок на объект; возвращает текущее состояние счетчика
      virtual long Release();
      
   private:
   
      int ref_counter;
   
};

//+------------------------------------------------------------------+

UObject::UObject(void)
   : ref_counter(0)
{
}

UObject::~UObject(void)
{
}

long UObject::AddRef(void)
{
   //Print( "UObject: increase ref_counter" );
   return ++ref_counter;
}

long UObject::Release(void)
{
   //Print( "UObject: decrease ref_counter" );
   return --ref_counter;
}

#endif