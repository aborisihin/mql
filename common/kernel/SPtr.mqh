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

//шаблонный класс smart pointer с подсчетом ссылок
//поддерживаются только наследники UObject
template < typename T >
class SPtr
{
   public:
   
      //указатель на объект
      T* m_obj;

   public:
   
      //конструктор по умолчанию
      SPtr();
      
      //конструктор из указателя на объект
      SPtr( T* obj );
      
      //конструктор копирования 
      SPtr( const SPtr& ptr );
      
      //конструктор копирования из SPtr другого типа
      template < typename _T > 
      SPtr( const SPtr<_T>& _ptr );
      
      //оператор присваивания нового указателя на объект
      void operator=( T* obj );
      
      //оператор присваивания нового указателя другого типа
      template < typename _T > 
      void operator=( _T* _obj );
      
      virtual ~SPtr();
      
   private:
   
      //безопасные функции обращения к счетчику объекта
      void Ref();
      void UnRef();
   
};

//+------------------------------------------------------------------+

template <typename T>
SPtr::SPtr()
{
   m_obj = NULL;
}

template <typename T>
SPtr::SPtr( T* obj )
{
   m_obj = obj;
   Ref();
}

template <typename T>
SPtr::SPtr( const SPtr& ptr )
{
   m_obj = ptr.m_obj;
   Ref();
}

template <typename T>
template <typename _T>
SPtr::SPtr( const SPtr<_T>& _ptr )
{
   m_obj = dynamic_cast<T*>( _ptr.m_obj );
   Ref();
}

template <typename T>
void SPtr::operator=( T* obj )
{
   if( obj != m_obj )
   {
      UnRef();
      m_obj = obj;
      Ref();
   }
}

template < typename _T >
template <typename _T>
void SPtr::operator=( _T* _obj )
{
   T* obj = dynamic_cast<T*>( _obj );
   if( obj != m_obj )
   {
      UnRef();
      m_obj = obj;
      Ref();
   }
}

template <typename T>
SPtr::~SPtr()
{
   UnRef();
   m_obj = NULL;
}

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

#endif