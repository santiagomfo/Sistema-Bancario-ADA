with Transaccion; use Transaccion;

--  FRONTERA SPARK: patron State con despacho dinamico sobre Transaccion.
--  Fuera del subconjunto SPARK por diseno.
package Cuenta_Estado with SPARK_Mode => Off is

   -- Modelo puro: solo define los estados y sus comportamientos básicos
   -- La lógica de negocio debe estar en Services

   type I_Cuenta_Estado is interface;

   function Puede_Realizar_Operacion
     (Self      : I_Cuenta_Estado;
      Operacion : Estrategia_Transaccion) return Boolean is abstract;

   type Estado_Activa_Type is new I_Cuenta_Estado with null record;

   overriding
   function Puede_Realizar_Operacion
     (Self      : Estado_Activa_Type;
      Operacion : Estrategia_Transaccion) return Boolean;

   type Estado_Bloqueada_Type is new I_Cuenta_Estado with null record;

   overriding
   function Puede_Realizar_Operacion
     (Self      : Estado_Bloqueada_Type;
      Operacion : Estrategia_Transaccion) return Boolean;

end Cuenta_Estado;
