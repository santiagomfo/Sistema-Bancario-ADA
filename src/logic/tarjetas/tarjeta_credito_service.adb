with Ada.Containers.Vectors;

package body Tarjeta_Credito_Service is

   -- Almacenamiento en memoria de tarjetas
   package Tarjeta_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Tarjeta_Credito_Access);

   Tarjetas_Store : Tarjeta_Vectors.Vector;

   -- === OPERACIONES CRUD ===

   function Crear_Tarjeta
     (Tasa_Interes_Mensual  : Tasa_Interes_Type := Length.DEFAULT_TASA_INTERES_TARJETA)
      return Tarjeta_Credito_Access
   is
      Nueva_Tarjeta : constant Tarjeta_Credito_Access :=
        new Tarjeta_Credito_Type'(Crear_Tarjeta_Credito (Tasa_Interes_Mensual));
   begin
      Tarjetas_Store.Append (Nueva_Tarjeta);
      return Nueva_Tarjeta;
   end Crear_Tarjeta;

   function Obtener_Tarjeta (Numero_Tarjeta : String) return Tarjeta_Credito_Access is
   begin
      for Tarjeta of Tarjetas_Store loop
         if Get_Numero_Tarjeta (Tarjeta.all) = Numero_Tarjeta then
            return Tarjeta;
         end if;
      end loop;
      -- Retornamos null si no se encuentra
      return null;
   end Obtener_Tarjeta;

   procedure Actualizar_Limite_Credito
     (Status        : out Tarjeta_Resultado_Type;
      Numero_Tarjeta : String;
      Nuevo_Limite   : Limite_Credito_Type)
   is
      Tarjeta : constant Tarjeta_Credito_Access := Obtener_Tarjeta (Numero_Tarjeta);
   begin
      if Tarjeta = null then
         Status := Crear_Error (Tarjeta_No_Existe, "Tarjeta " & Numero_Tarjeta & " no encontrada");
         return;
      end if;

      -- Validar que el nuevo límite no sea menor que el saldo utilizado
      if Nuevo_Limite < Limite_Credito_Type (Get_Saldo_Utilizado (Tarjeta.all)) then
         Status := Crear_Error (Limite_Excedido, "El nuevo limite no puede ser menor que el saldo utilizado actual");
         return;
      end if;

      Set_Limite_Credito (Tarjeta.all, Nuevo_Limite);
      Status := Crear_Exito;
   end Actualizar_Limite_Credito;

   procedure Eliminar_Tarjeta
     (Status        : out Tarjeta_Resultado_Type;
      Numero_Tarjeta : String)
   is
      Tarjeta : constant Tarjeta_Credito_Access := Obtener_Tarjeta (Numero_Tarjeta);
   begin
      if Tarjeta = null then
         Status := Crear_Error (Tarjeta_No_Existe, "Tarjeta " & Numero_Tarjeta & " no encontrada");
         return;
      end if;

      -- Validar que no tenga deuda pendiente
      if Get_Saldo_Utilizado (Tarjeta.all) > 0.0 then
         Status := Crear_Error (Tiene_Deuda_Pendiente, "No se puede eliminar una tarjeta con deuda pendiente");
         return;
      end if;

      -- Buscar y eliminar de la colección
      for I in Tarjetas_Store.First_Index .. Tarjetas_Store.Last_Index loop
         if Get_Numero_Tarjeta (Tarjetas_Store.Element (I).all) = Numero_Tarjeta then
            Tarjetas_Store.Delete (I);
            Status := Crear_Exito;
            return;
         end if;
      end loop;

      -- Si llegamos aquí, no se encontró (aunque ya validamos con Obtener_Tarjeta)
      Status := Crear_Error (Tarjeta_No_Existe, "Error interno: tarjeta no encontrada en colección");
   end Eliminar_Tarjeta;

   function Ejecutar_Operacion
     (Estrategia     : Transaccion_Tarjeta.I_Transaccion_Tarjeta_Strategy'Class;
      Numero_Tarjeta : String;
      Monto          : Saldo_Type;
      Descripcion    : String := "") return Tarjeta_Resultado_Type
   is
      Tarjeta : constant Tarjeta_Credito_Access := Obtener_Tarjeta (Numero_Tarjeta);
   begin
      if Tarjeta = null then
         return Crear_Error (Tarjeta_No_Existe, "Tarjeta " & Numero_Tarjeta & " no encontrada");
      end if;

      if Esta_Vencida (Tarjeta.all) then
         return Crear_Error (Tarjeta_Vencida, "La tarjeta esta vencida");
      end if;

      -- Ejecutar_Tarjeta ahora debe retornar un Tarjeta_Resultado_Type
      return Transaccion_Tarjeta.Ejecutar (Estrategia, Tarjeta.all, Monto);
   end Ejecutar_Operacion;

   procedure Aplicar_Interes (Numero_Tarjeta : String) is
      Tarjeta : constant Tarjeta_Credito_Access := Obtener_Tarjeta (Numero_Tarjeta);
   begin
      if Get_Saldo_Utilizado (Tarjeta.all) > 0.0 then
         Aplicar_Interes (Tarjeta.all);
      end if;
   end Aplicar_Interes;

   function Consultar_Estado_Tarjeta (Numero_Tarjeta : String) return String is
      Tarjeta : constant Tarjeta_Credito_Access := Obtener_Tarjeta (Numero_Tarjeta);
   begin
      return "=== Estado de Tarjeta ===" & ASCII.LF &
             "Numero: " & Get_Numero_Tarjeta (Tarjeta.all) & ASCII.LF &
             "Limite Credito: " & Get_Limite_Credito (Tarjeta.all)'Image & ASCII.LF &
             "Saldo Utilizado: " & Get_Saldo_Utilizado (Tarjeta.all)'Image & ASCII.LF &
             "Credito Disponible: " & Get_Credito_Disponible (Tarjeta.all)'Image & ASCII.LF &
             "Pago Minimo: " & Get_Pago_Minimo (Tarjeta.all)'Image & ASCII.LF &
             "Tasa Interes Mensual: " & Get_Tasa_Interes_Mensual (Tarjeta.all)'Image & "%" & ASCII.LF &
             "Vencida: " & (if Esta_Vencida (Tarjeta.all) then "SI" else "NO");
   end Consultar_Estado_Tarjeta;

end Tarjeta_Credito_Service;
