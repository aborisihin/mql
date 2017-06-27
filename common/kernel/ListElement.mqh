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

//шаблонный класс элемента списка ордеров
template < typename T >
class ListElement
{
   public:
   
      ListElement( T *data );
      ~ListElement();
      
      //операции чтения и задания следующего элемента списка
      ListElement* next();
      void setNext( ListElement *el );
      
      //получить объект, на который ссылается элемент списка
      T* data();
      
   private:
   
      T *m_data;
      ListElement *next_element;
};

template < typename T >
ListElement::ListElement( T *data )
   : m_data( data )
   , next_element( NULL )
{
}

template < typename T >
ListElement::~ListElement()
{
   if( m_data != NULL ) 
   {
      delete m_data;
      m_data = NULL;
   }
}

template < typename T >
ListElement* ListElement::next()
{
   return next_element;
}

template < typename T >
void ListElement::setNext( ListElement *el )
{
   next_element = el;
}

template < typename T >
T* ListElement::data()
{
   return m_data;
}

#endif