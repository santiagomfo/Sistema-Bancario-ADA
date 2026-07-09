-- Tipos de resultado para operaciones de cliente
-- Reemplaza la excepción Datos_Invalidos
with Resultado_Operacion;

--  FRONTERA SPARK: capa de resultados de servicios. Fuera de SPARK.
package Cliente_Resultado with SPARK_Mode => Off is

   use Resultado_Operacion;

   -- Códigos de error específicos del dominio Cliente
   type Cliente_Error_Code is
     (Sin_Error,
      Cedula_Invalida,
      Nombre_Invalido,
      Apellido_Invalido,
      Direccion_Invalida,
      Correo_Invalido,
      Telefono_Invalido,
      Saldo_Inicial_Invalido);

   -- Tipo resultado para operaciones de cliente
   type Cliente_Resultado_Type is record
      Estado  : Estado_Operacion;
      Error   : Cliente_Error_Code;
      Mensaje : Mensaje_Error;
   end record;

   -- Constructor para resultado exitoso
   function Crear_Exito return Cliente_Resultado_Type is
     ((Estado => Exito, Error => Sin_Error, Mensaje => (others => ' ')));

   -- Constructor para resultado con error
   function Crear_Error
     (Codigo  : Cliente_Error_Code;
      Mensaje : String) return Cliente_Resultado_Type;

end Cliente_Resultado;
