//+------------------------------------------------------------------+
//|                                                  ListElement.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef LISTELEMENT_H
#define LISTELEMENT_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

//шаблонный класс элемента списка
template < typename T >
class ListElement
{
   public:
   
      ListElement( const T& data );
      virtual ~ListElement();
      
      //операции чтения и задания следующего элемента списка
      ListElement* next() const;
      void setNext( ListElement* const el );
      
      //получить объект, на который ссылается элемент списка
      T data() const;
      
   private:
   
      T m_data;
      ListElement *next_element;
};

//+------------------------------------------------------------------+

template < typename T >
ListElement::ListElement( const T& data )
   : m_data( data )
   , next_element( NULL )
{
}

template < typename T >
ListElement::~ListElement()
{
}

template < typename T >
ListElement* ListElement::next() const
{
   return next_element;
}

template < typename T >
void ListElement::setNext( ListElement* const el )
{
   next_element = el;
}

template < typename T >
T ListElement::data() const
{
   return m_data;
}

#endif