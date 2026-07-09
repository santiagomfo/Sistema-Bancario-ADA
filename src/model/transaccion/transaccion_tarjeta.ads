with Tarjeta_Credito;
with Length;
with Tarjeta_Resultado;

--  FRONTERA SPARK: estrategias de transaccion de tarjeta con despacho dinamico.
--  Fuera del subconjunto SPARK por diseno.
package Transaccion_Tarjeta with SPARK_Mode => Off is

   use Tarjeta_Credito;
   use Tarjeta_Resultado;

   -- Interfaz para estrategias de tarjeta (separada de I_Transaccion_Strategy)
   type I_Transaccion_Tarjeta_Strategy is interface;

   type Tipo_Estrategia_Tarjeta is (Compra, Pago_Tarjeta);

   function Get_Tipo (Self : I_Transaccion_Tarjeta_Strategy)
      return Tipo_Estrategia_Tarjeta is abstract;

   function Ejecutar (Self    : I_Transaccion_Tarjeta_Strategy;
                      Tarjeta : in out Tarjeta_Credito_Type'Class;
                      Monto   : Saldo_Type) return Tarjeta_Resultado_Type is abstract
     with
       Pre'Class => Monto > 0.0 and Monto <= Length.MAX_MONTO_TRANSACCION;

   -- Estrategia de Compra
   type Compra_Strategy is new I_Transaccion_Tarjeta_Strategy with null record;

   overriding
   function Get_Tipo (Self : Compra_Strategy) return Tipo_Estrategia_Tarjeta;

   overriding
   function Ejecutar (Self    : Compra_Strategy;
                      Tarjeta : in out Tarjeta_Credito_Type'Class;
                      Monto   : Saldo_Type) return Tarjeta_Resultado_Type;

   -- Estrategia de Pago
   type Pago_Tarjeta_Strategy is new I_Transaccion_Tarjeta_Strategy with null record;

   overriding
   function Get_Tipo (Self : Pago_Tarjeta_Strategy) return Tipo_Estrategia_Tarjeta;

   overriding
   function Ejecutar (Self    : Pago_Tarjeta_Strategy;
                      Tarjeta : in out Tarjeta_Credito_Type'Class;
                      Monto   : Saldo_Type) return Tarjeta_Resultado_Type;

end Transaccion_Tarjeta;
