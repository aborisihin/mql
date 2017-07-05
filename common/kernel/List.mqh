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
      virtual ~List();
      
      //получить размер списка
      unsigned int  size() const;
      
      //очистить список
      void clear();
      
      //получить элемент спсика по индексу
      ListElement<T>* at( int index ) const;
      
      //получить индекс элемента списка
      int find( ListElement<T> *element ) const;
      
      //добавить элемент в конец списка
      //void append( ListElement<T> *element );
      void append( T& data );
      
      //вставить элемент в список на место, определяемое индексом
      void insert( ListElement<T> *element, int position );
      
      //удалить заданный элемент списка
      void remove( ListElement<T> *element );
      
   private:
   
      ListElement<T> *first;
      
   public:
   
      //конструкторы копирования и присваивания
      List( const List<T>& list );
      void operator=( const List<T>& list );
   
};

//+------------------------------------------------------------------+

template < typename T >
List::List()
   : first( NULL )
{
}

template < typename T >
List::List( const List<T>& list )
   : first( NULL )
{
   this = list;
}

template < typename T >
void List::operator=( const List<T>& list )
{
   if( list.first == NULL )
   {
      first = NULL;
      return;
   }
   else
   {
      first = new ListElement<T>( new T( list.first.data() ) );
   }
   
   ListElement<T> *prev = list.first;
   ListElement<T> *current = list.first.next();
      
   while( current != NULL )
   {
      ListElement<T> *current_copy = new ListElement<T>( new T( current.data() ) );
      prev.setNext( current_copy );
      prev = current;
      current = current.next();
   }
}

template < typename T >
List::~List()
{
   clear();
}

template < typename T >
unsigned int List::size() const
{
   if( first == NULL )
      return 0;
   
   unsigned int n = 1;
   
   ListElement<T> *current = first;
   
   while( current.next() != NULL )
   {
      current = current.next();
      n++;
   }
   
   return n;
}

template < typename T >
void List::clear()
{
   ListElement<T> *current = first;
   
   while( current != NULL )
   {
      ListElement<T> *tmp = current;
      current = current.next();
      
      delete tmp;
   }
   
   first = NULL;
}

template < typename T >
ListElement<T>* List::at( int index ) const
{
   int pos=0;
   
   ListElement<T> *current = first;
   
   while( current != NULL )
   {
      if( pos == index )
         return current;
         
      current = current.next();
      pos++;
   }
   
   return NULL; //не нашли
}

template < typename T >
int List::find( ListElement<T> *element ) const
{
   int pos = 0;

   ListElement<T> *current = first;
   
   while( current != NULL )
   {
      if( current == element )
         return pos;
      
      current = current.next();
      pos++;
   }
   
   return -1;
}

template < typename T >
void List::append( T& data )
{   
   ListElement<T> *last = at( size() - 1 );
   
   T data_copy( data );
   ListElement<T> *element = new ListElement<T>( data_copy ); //новый элемент с копией data
   
   if( last == NULL ) //список пуст
   {
      element.setNext( NULL );
      first = element;
   }
   else
   {
      last.setNext( element );
      element.setNext( NULL );
   }
}

template < typename T >
void List::insert( ListElement<T> *element, int position )
{
   if( position == size() ) //вставляем в конец
   {
      //append( element );
      return;
   }
   
   if( position == 0 ) //вставляем в начало
   {
      element.setNext( first );
      first = element;
      return;
   }
   
   ListElement<T> *element_prev_pos = at( position - 1 );
   
   if( element_prev_pos == NULL )
      return;
      
   element.setNext( element_prev_pos.next() );
   element_prev_pos.setNext( element );
}

template < typename T >
void List::remove( ListElement<T> *element )
{
   ListElement<T> *current = first;
   ListElement<T> *prev = NULL;
   
   while( current != NULL )
   {
      if( current == element )
      {
         if( prev == NULL ) //удаляем первый элемент
         {
            first = current.next();
         }
         else
         {
            prev.setNext( current.next() );
         }
         
         delete current;
         break;
      }
      
      prev = current;
      current = current.next();
   }
}

#endif