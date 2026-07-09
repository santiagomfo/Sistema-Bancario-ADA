-- Tipos de resultado para operaciones de transacción
-- Reemplaza el uso de Boolean para indicar éxito/fallo
with Resultado_Operacion;

--  FRONTERA SPARK: capa de resultados de servicios. Fuera de SPARK.
package Transaccion_Resultado with SPARK_Mode => Off is

   use Resultado_Operacion;

   -- Códigos de error específicos del dominio Transacción
   type Transaccion_Error_Code is
     (Sin_Error,
      Operacion_No_Permitida,
      Cuenta_Bloqueada,
      Estrategia_Invalida,
      Parametros_Invalidos);

   -- Tipo resultado para operaciones de transacción
   type Transaccion_Resultado_Type is record
      Estado  : Estado_Operacion;
      Error   : Transaccion_Error_Code;
      Mensaje : Mensaje_Error;
   end record;

   -- Constructor para resultado exitoso
   function Crear_Exito return Transaccion_Resultado_Type is
     ((Estado => Exito, Error => Sin_Error, Mensaje => (others => ' ')));

   -- Constructor para resultado con error
   function Crear_Error
     (Codigo  : Transaccion_Error_Code;
      Mensaje : String;
      Tipo    : Estado_Operacion := Error_Estado) return Transaccion_Resultado_Type;

end Transaccion_Resultado;
