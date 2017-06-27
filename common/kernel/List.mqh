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
      
      //опреации работы со списком
      void append( ListElement<T> *element );
      void insert( ListElement<T> *prev, ListElement<T> *element );
      void remove( ListElement<T> *element );
      void clear();
      int size();
      
   private:
   
      ListElement<T> *first;
      
      ListElement<T> getLastElement();
   
};

template < typename T >
List::List()
   : first( NULL )
{
}

template < typename T >
List::~List()
{
   clear();
}

template < typename T >
void List::append( ListElement<T> *element )
{   
   ListElement<T> *last = getLastElement();
   
   if( last == NULL ) //список пока пустой
   {
      element->setNext( NULL );
      first = element;
   }
   else
   {
      last->setNext( element );
      element->setNext( NULL );
   }
}

template < typename T >
void List::insert( ListElement<T> *prev, ListElement<T> *element )
{
}

template < typename T >
void List::remove( ListElement<T> *element )
{
}

template < typename T >
void List::clear()
{
}

template < typename T >
int List::size()
{
   if( current == NULL )
      return 0;
   
   int n = 1;
   
   ListElement<T> *current = first;
   
   while( current->next() != NULL )
   {
      current = current->next();
      n++;
   }
   
   return n;
}

template < typename T >
ListElement<T> List::getLastElement()
{
   ListElement<T> *current = first;
   
   while( current != NULL && current->next() != NULL )
   {
      current = current->next();
   }
   
   return current;
}

#endif