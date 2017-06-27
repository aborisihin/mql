//+------------------------------------------------------------------+
//|                                                         List.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef LIST_H
#define LIST_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

#include "./../../common/kernel/ListElement.mqh"

//шаблонный класс связанного списка
template < typename T >
class List
{
   public:
   
      List();
      ~List();
      
   private:
   
      ListElement<T> *first;
   
};

template < typename T >
List::List()
   : first( NULL )
{
}

template < typename T >
List::~List()
{
   //удалить список
}

#endif