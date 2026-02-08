package body Clientes is

   --  Procedimiento privado para copiar un string a un campo de tamaño fijo
   procedure Copiar_Campo (Origen : String; Destino : out String) is
   begin
      Destino := (others => ' ');
      Destino (Destino'First .. Destino'First + Origen'Length - 1) := Origen;
   end Copiar_Campo;

   --  Función privada: verificar si un campo está vacío o excede el límite
   function Esta_En_Rango (Campo : String; Maximo : Integer) return Boolean is
   begin
      return Campo'Length > 0 and then Campo'Length <= Maximo;
   end Esta_En_Rango;

   function Crear_Cliente (
      Nuevo_Cliente : out Cliente;
      Cedula    : String;
      Nombre    : String;
      Apellido  : String;
      Direccion : String;
      Correo    : String;
      Telefono  : String
   ) return Boolean is
   begin
      if not Esta_En_Rango (Cedula, MAX_CEDULA) then
         return False;
      end if;

      if not Esta_En_Rango (Nombre, MAX_NOMBRE) then
         return False;
      end if;

      if not Esta_En_Rango (Apellido, MAX_APELLIDO) then
         return False;
      end if;

      if not Esta_En_Rango (Direccion, MAX_DIRECCION) then
         return False;
      end if;

      if not Esta_En_Rango (Correo, MAX_CORREO) then
         return False;
      end if;

      if not Esta_En_Rango (Telefono, MAX_TELEFONO) then
         return False;
      end if;

      Copiar_Campo (Cedula, Nuevo_Cliente.Cedula);
      Copiar_Campo (Nombre, Nuevo_Cliente.Nombre);
      Copiar_Campo (Apellido, Nuevo_Cliente.Apellido);
      Copiar_Campo (Direccion, Nuevo_Cliente.Direccion);
      Copiar_Campo (Correo, Nuevo_Cliente.Correo);
      Copiar_Campo (Telefono, Nuevo_Cliente.Telefono);

      return True;
   end Crear_Cliente;

   function Actualizar_Cliente (
      Cliente_Actual : in out Cliente;
      Nombre    : String;
      Apellido  : String;
      Direccion : String;
      Correo    : String;
      Telefono  : String
   ) return Boolean is
   begin
      if not Esta_En_Rango (Nombre, MAX_NOMBRE) then
         return False;
      end if;

      if not Esta_En_Rango (Apellido, MAX_APELLIDO) then
         return False;
      end if;

      if not Esta_En_Rango (Direccion, MAX_DIRECCION) then
         return False;
      end if;

      if not Esta_En_Rango (Correo, MAX_CORREO) then
         return False;
      end if;

      if not Esta_En_Rango (Telefono, MAX_TELEFONO) then
         return False;
      end if;

      Copiar_Campo (Nombre, Cliente_Actual.Nombre);
      Copiar_Campo (Apellido, Cliente_Actual.Apellido);
      Copiar_Campo (Direccion, Cliente_Actual.Direccion);
      Copiar_Campo (Correo, Cliente_Actual.Correo);
      Copiar_Campo (Telefono, Cliente_Actual.Telefono);

      return True;
   end Actualizar_Cliente;

end Clientes;
