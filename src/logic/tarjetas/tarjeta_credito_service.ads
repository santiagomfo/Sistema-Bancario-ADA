with Tarjeta_Credito;
with Transaccion_Tarjeta;
with Length;
with Tarjeta_Resultado;

--  FRONTERA SPARK: capa de servicios con access/despacho dinamico. Fuera de SPARK.
package Tarjeta_Credito_Service with SPARK_Mode => Off is

   use Tarjeta_Credito;
   use Length;
   use Tarjeta_Resultado;

   function Crear_Tarjeta
      return Tarjeta_Credito_Access;

   function Obtener_Tarjeta (Numero_Tarjeta : String) return Tarjeta_Credito_Access
   with
      Pre => Numero_Tarjeta'Length > 0;

   procedure Actualizar_Limite_Credito
     (Status        : out Tarjeta_Resultado_Type;
      Numero_Tarjeta : String;
      Nuevo_Limite   : Limite_Credito_Type)
   with
      Pre => Numero_Tarjeta'Length > 0 and Nuevo_Limite > 0.0;


   function Ejecutar_Operacion
     (Estrategia     : Transaccion_Tarjeta.I_Transaccion_Tarjeta_Strategy'Class;
      Numero_Tarjeta : String;
      Monto          : Saldo_Type;
      Descripcion    : String := "") return Tarjeta_Resultado_Type
   with
      Pre => Numero_Tarjeta'Length > 0 and Monto > 0.0;

   procedure Aplicar_Interes (Numero_Tarjeta : String)
   with
      Pre => Numero_Tarjeta'Length > 0;

   function Consultar_Estado_Tarjeta (Numero_Tarjeta : String) return String
   with
      Pre => Numero_Tarjeta'Length > 0;

end Tarjeta_Credito_Service;
