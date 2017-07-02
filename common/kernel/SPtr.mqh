//+------------------------------------------------------------------+
//|                                                         SPtr.mqh |
//|                                               Borisikhin Aleksey |
//|                                            a.borisihin@gmail.com |
//+------------------------------------------------------------------+
#ifndef SPTR_H
#define SPTR_H

#property copyright "Borisikhin Aleksey"
#property link      "a.borisihin@gmail.com"
#property strict

//шаблонный класс smart pointer
template < typename T >
class SPtr
{
   public:
   
      SPtr( T* obj );
      
      virtual ~SPtr();
      
   public:
   
      //безопасные функции обращения к счетчику объекта
      void Ref();
      void UnRef();
      
   private:
   
      T* m_obj;
   
};

//+------------------------------------------------------------------+

template <typename T>
 void SPtr::Ref()
 {
   if( m_obj != NULL )
      m_obj.AddRef();
 }
 
 template <typename T>
 void SPtr::UnRef()
 {
   if( m_obj != NULL )
   {
      if( m_obj.Release() == 0 )
      {
         Print( "SPtr: delete owned object" );
         delete m_obj;
      }
   }
 }

template <typename T>
SPtr::SPtr( T* obj )
   : m_obj( obj )
{
   m_obj = obj;
   Ref();
}

template <typename T>
SPtr::~SPtr()
{
   UnRef();
   m_obj = NULL;
}

#endif