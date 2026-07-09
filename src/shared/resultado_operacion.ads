-- Tipo base para resultados de operaciones
-- Reemplaza el uso de excepciones para permitir SPARK
pragma SPARK_Mode (On);

package Resultado_Operacion is

   -- Estados base de operación
   type Estado_Operacion is
     (Exito,
      Error_Validacion,
      Error_Estado,
      Error_Negocio,
      Error_Sistema);

   -- Tipo genérico para mensajes de error
   subtype Mensaje_Error is String (1 .. 200);

   -- Función helper para crear mensajes.
   -- Postcondición corregida: copia los primeros Min (Texto'Length, 200)
   -- caracteres de Texto y rellena el resto con espacios. (La version anterior
   -- afirmaba erroneamente que no habia espacios en la parte copiada.)
   function Crear_Mensaje (Texto : String) return Mensaje_Error
   with Post => (for all I in Crear_Mensaje'Result'Range =>
                   (if I <= Natural'Min (Texto'Length, Mensaje_Error'Length)
                    then Crear_Mensaje'Result (I) = Texto (Texto'First + (I - 1))
                    else Crear_Mensaje'Result (I) = ' '));

end Resultado_Operacion;
