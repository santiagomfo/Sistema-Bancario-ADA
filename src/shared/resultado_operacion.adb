pragma SPARK_Mode (On);

package body Resultado_Operacion is

   function Crear_Mensaje (Texto : String) return Mensaje_Error is
      Resultado : Mensaje_Error := (others => ' ');
      Longitud : constant Natural := Natural'Min (Texto'Length, Mensaje_Error'Length);
   begin
      if Longitud > 0 then
         --  Parentesis en (Longitud - 1) para evitar overflow del indice
         --  intermedio Texto'First + Longitud cuando Texto'First es grande.
         Resultado (1 .. Longitud) := Texto (Texto'First .. Texto'First + (Longitud - 1));
      end if;
      return Resultado;
   end Crear_Mensaje;

end Resultado_Operacion;
