with Ada.Text_IO; use Ada.Text_IO;
with Clientes;

procedure Main is
   Nuevo_Cliente : Clientes.Cliente;
   Operacion_Exitosa : Boolean;
begin
   --  Prueba de creación de cliente
   Operacion_Exitosa := Clientes.Crear_Cliente (
      Nuevo_Cliente,
      "0102030405",
      "Armando",
      "Paredes",
      "Av. Central",
      "juan@mail.com",
      "0999999999"
   );

   if Operacion_Exitosa then
      Put_Line ("Cliente creado correctamente");
   else
      Put_Line ("Error al crear cliente");
      return;
   end if;

   --  Mostrar datos iniciales
   Put_Line ("--- Datos iniciales ---");
   Put_Line ("Nombre   : " & Nuevo_Cliente.Nombre);
   Put_Line ("Apellido : " & Nuevo_Cliente.Apellido);
   Put_Line ("Correo   : " & Nuevo_Cliente.Correo);

   --  Prueba de actualización de cliente
   Operacion_Exitosa := Clientes.Actualizar_Cliente (
      Nuevo_Cliente,
      "Juan Carlos",
      "Perez Gomez",
      "Av. Siempre Viva 123",
      "juan.c@mail.com",
      "0988888888"
   );

   if Operacion_Exitosa then
      Put_Line ("Cliente actualizado correctamente");
   else
      Put_Line ("Error al actualizar cliente");
      return;
   end if;

   --  Mostrar datos actualizados
   Put_Line ("--- Datos actualizados ---");
   Put_Line ("Nombre   : " & Nuevo_Cliente.Nombre);
   Put_Line ("Apellido : " & Nuevo_Cliente.Apellido);
   Put_Line ("Correo   : " & Nuevo_Cliente.Correo);

end Main;
