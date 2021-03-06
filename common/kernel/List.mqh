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
      
      //получить элемент списка по индексу
      ListElement<T>* at( int index ) const;
      
      //получить индекс элемента списка
      int find( const T& data ) const;
      
      //добавить элемент в конец списка
      void append( const T& data );
      
      //вставить элемент в список на место, определяемое индексом
      void insert( const T& data, int position );
      
      //удалить элемент списка, заданный индексом
      void remove( int position );
      
   private:
   
      ListElement<T> *first;
      
   public:
   
      //конструкторы копирования и присваивания
      List( const List<T>& source );
      void operator=( const List<T>& source );
   
};

//+------------------------------------------------------------------+

template < typename T >
List::List()
   : first( NULL )
{
}

template < typename T >
List::List( const List<T>& source )
   : first( NULL )
{
   this = source;
}

template < typename T >
void List::operator=( const List<T>& source )
{
   if( source.first == NULL )
   {
      first = NULL;
      return;
   }
   else
   {
      first = new ListElement<T>( source.first.data() );
   }
   
   ListElement<T> *prev = first;
   ListElement<T> *current_source = source.first.next();
      
   while( current_source != NULL )
   {
      ListElement<T> *current_copy = new ListElement<T>( current_source.data() );
      
      prev.setNext( current_copy );
      prev = current_copy;
      current_source = current_source.next();
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
int List::find( const T& data ) const
{
   ListElement<T> *current = first;
   
   int pos = 0;
   
   while( current != NULL )
   {
      if( current.data() == data )
         return pos;
      
      current = current.next();
      pos++;
   }
   
   return -1;
}

template < typename T >
void List::append( const T& data )
{   
   insert( data, size() );
}

template < typename T >
void List::insert( const T& data, int position )
{
   if( position < 0 || position > (int)size() ) //ошибка индекса
   {
      return;
   }
   
   ListElement<T> *element = new ListElement<T>( data );
   
   if( position == 0 ) //вставляем в начало
   {
      element.setNext( first );
      first = element;
   }
   else //вставляем во всех дургих случаях
   {
      ListElement<T> *element_prev_pos = at( position - 1 );
      
      if( element_prev_pos == NULL )
         return;
         
      element.setNext( element_prev_pos.next() );
      element_prev_pos.setNext( element );
   }
}

template < typename T >
void List::remove( int position )
{
   ListElement<T> *current = first;
   ListElement<T> *prev = NULL;
   int current_position = 0;
   
   while( current != NULL )
   {
      if( current_position == position )
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
      current_position++;
   }
}

#endif