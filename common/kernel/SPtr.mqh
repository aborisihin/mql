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
   private:
   
      //указатель на объект
      T* m_obj;

   public:
   
      //конструктор по умолчанию
      SPtr();
      
      //конструктор из указателя на объект
      SPtr( T* obj );
      
      //конструктор копирования из SPtr
      template < typename _T > 
      SPtr( const SPtr<_T>& _ptr );
      
      //оператор присваивания нового указателя
      template < typename _T > 
      void operator=( _T* _obj );
      
      //оператор присваивания SPtr
      template < typename _T >
      void operator=( const SPtr<_T>& _ptr );
      
      //опреатор сравнения SPtr
      template < typename _T >
      bool operator == ( const SPtr<_T>& _ptr ) const;
      
      //оператор сравнения с указателем
      template < typename _T >
      bool operator == ( const _T* _obj ) const;
      
      //операция получения указателя на объект
      T* obj() const;
      
      //проверка указателя на достоверность
      bool alive() const;
      
      //прекращение владения объектом
      void setNull();
      
      //деструктор
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
template <typename _T>
SPtr::SPtr( const SPtr<_T>& _ptr )
{
   T* cast_obj = dynamic_cast<T*>( _ptr.obj() );
   if( _ptr.alive() && cast_obj == NULL )
   {
      Alert("SPtr cast error! SPtr::SPtr(const SPtr<_T>&)");
      return;
   }
   
   m_obj = cast_obj;
   Ref();
}

template < typename T >
template < typename _T >
void SPtr::operator=( _T* _obj )
{
   T* cast_obj = dynamic_cast<T*>( _obj );
   if( _obj != NULL  && cast_obj == NULL )
   {
      Alert("SPtr cast error! SPtr::operator=(_T*)");
      return;
   }

   if( cast_obj != m_obj )
   {
      UnRef();
      m_obj = cast_obj;
      Ref();
   }
}

template < typename T >
template < typename _T >
void SPtr::operator=( const SPtr<_T>& _ptr )
{
   T* cast_obj = dynamic_cast<T*>( _ptr.m_obj );
   if( _ptr.alive() && cast_obj == NULL )
   {
      Alert("SPtr cast error! SPtr::operator=(const SPtr<_T>&)");
      return;
   }

   if( cast_obj != m_obj )
   {
      UnRef();
      m_obj = cast_obj;
      Ref();
   }
}

template <typename T>
template < typename _T >
bool SPtr::operator == ( const SPtr<_T>& _ptr ) const
{
   return (bool)( m_obj == _ptr.m_obj );
}

template <typename T>
template < typename _T >
bool SPtr::operator == ( const _T* _obj ) const
{
   return (bool)( m_obj == _obj );
}

template < typename T >
T* SPtr::obj() const
{
   return m_obj;
}

template <typename T>
bool SPtr::alive() const
{
   return (bool)( m_obj != NULL );
}

template <typename T>
void SPtr::setNull()
{
   UnRef();
   m_obj = NULL;
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
   {
      m_obj.AddRef();
   }
}
 
template <typename T>
void SPtr::UnRef()
{
   if( m_obj != NULL )
   {
      if( m_obj.Release() == 0 )
      {
         delete m_obj;
      }
   }
}

#endif