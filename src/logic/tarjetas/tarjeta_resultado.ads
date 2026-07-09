-- Tipos de resultado para operaciones de tarjeta
-- Reemplaza las excepciones: Limite_Credito_Excedido, Pago_Invalido, etc.
with Resultado_Operacion;

--  FRONTERA SPARK: capa de resultados de servicios. Fuera de SPARK.
package Tarjeta_Resultado with SPARK_Mode => Off is

   use Resultado_Operacion;

   -- Códigos de error específicos del dominio Tarjeta
   type Tarjeta_Error_Code is
     (Sin_Error,
      Limite_Excedido,
      Pago_Excede_Deuda,
      Tarjeta_Vencida,
      Tarjeta_No_Existe,
      Tiene_Deuda_Pendiente,
      Monto_Invalido);

   -- Tipo resultado para operaciones de tarjeta
   type Tarjeta_Resultado_Type is record
      Estado  : Estado_Operacion;
      Error   : Tarjeta_Error_Code;
      Mensaje : Mensaje_Error;
   end record;

   -- Constructor para resultado exitoso
   function Crear_Exito return Tarjeta_Resultado_Type is
     ((Estado => Exito, Error => Sin_Error, Mensaje => (others => ' ')));

   -- Constructor para resultado con error
   function Crear_Error
     (Codigo  : Tarjeta_Error_Code;
      Mensaje : String;
      Tipo    : Estado_Operacion := Error_Negocio) return Tarjeta_Resultado_Type;

end Tarjeta_Resultado;
