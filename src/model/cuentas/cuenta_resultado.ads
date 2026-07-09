-- Tipos de resultado para operaciones de cuenta
-- Reemplaza el uso de Program_Error para validaciones de negocio
with Resultado_Operacion;

--  FRONTERA SPARK: tipo de resultado de operaciones de cuenta (capa de soporte
--  a servicios). Fuera del nucleo verificado.
package Cuenta_Resultado with SPARK_Mode => Off is

   use Resultado_Operacion;

   -- Códigos de error específicos del dominio Cuenta
   type Cuenta_Error_Code is
     (Sin_Error,
      Saldo_Insuficiente,
      Excede_Sobregiro,
      Saldo_Negativo_No_Permitido,
      Monto_Invalido,
      Operacion_No_Permitida);

   -- Tipo resultado para operaciones de cuenta
   type Cuenta_Resultado_Type is record
      Estado  : Estado_Operacion;
      Error   : Cuenta_Error_Code;
      Mensaje : Mensaje_Error;
   end record;

   -- Constructor para resultado exitoso
   function Crear_Exito return Cuenta_Resultado_Type is
     ((Estado => Exito, Error => Sin_Error, Mensaje => (others => ' ')));

   -- Constructor para resultado con error
   function Crear_Error
     (Codigo  : Cuenta_Error_Code;
      Mensaje : String;
      Tipo    : Estado_Operacion := Error_Negocio) return Cuenta_Resultado_Type;

end Cuenta_Resultado;
