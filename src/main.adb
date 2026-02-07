with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;
with Clientes;
with Clientes_Service;

procedure Main is
   C : Clientes.Cliente_Type;
begin
   -------------------------------------------------------
   -- 1. Prueba de creación de cliente
   -------------------------------------------------------
   Put_Line ("--- Intentando crear cliente ---");

   begin
      Clientes_Service.Crear_Cliente
        (Resultado     => C,
         Cedula        => "0102030405",
         Nombre        => "Armando",
         Apellido      => "Paredes",
         Direccion     => "Av. Central",
         Correo        => "juan@mail.com",
         Telefono      => "0999999999",
         Tipo_Cuenta   => Clientes_Service.Ahorros,
         Numero_Cuenta => "1234567890",
         Saldo_Inicial => 500.00);

      -- Si llega aquí, es que no hubo excepción
      Put_Line ("Cliente creado correctamente.");

   exception
      when Clientes_Service.Datos_Invalidos =>
         Put_Line ("Error: Datos inválidos al crear cliente.");
         return; -- Salimos si no se pudo crear
   end;

   -------------------------------------------------------
   -- 2. Mostrar datos iniciales
   -------------------------------------------------------
   Put_Line ("");
   Put_Line ("--- Datos iniciales ---");
   Put_Line ("Nombre   : " & Clientes.Get_Nombre (C));
   Put_Line ("Apellido : " & Clientes.Get_Apellido (C));
   Put_Line ("Correo   : " & Clientes.Get_Correo (C));

   -------------------------------------------------------
   -- 3. Prueba de actualización de cliente
   -------------------------------------------------------
   Put_Line ("");
   Put_Line ("--- Actualizando cliente ---");

   Clientes_Service.Actualizar_Cliente
     (Cliente   => C,
      Nombre    => "Juan Carlos",
      Apellido  => "Perez Gomez",
      Direccion => "Av. Siempre Viva 123",
      Correo    => "juan.c@mail.com",
      Telefono  => "0988888888");

   Put_Line ("Cliente actualizado correctamente.");

   -------------------------------------------------------
   -- 4. Mostrar datos actualizados
   -------------------------------------------------------
   Put_Line ("--- Datos actualizados ---");
   Put_Line ("Nombre   : " & Clientes.Get_Nombre (C));
   Put_Line ("Apellido : " & Clientes.Get_Apellido (C));
   Put_Line ("Correo   : " & Clientes.Get_Correo (C));

   -------------------------------------------------------
   -- 5. Prueba de validación (debe lanzar excepción)
   -------------------------------------------------------
   Put_Line ("");
   Put_Line ("--- Prueba de validación (Nombre vacío) ---");

   begin
      Clientes_Service.Actualizar_Cliente
        (Cliente   => C,
         Nombre    => "", -- ESTO DEBE FALLAR
         Apellido  => "Perez",
         Direccion => "Av. Central",
         Correo    => "mail@test.com",
         Telefono  => "0999999999");

      -- Si llega aquí, la validación falló (malo)
      Put_Line ("FALLO: Se permitió actualizar con nombre vacío.");

   exception
      when E : Clientes_Service.Datos_Invalidos =>
         -- Si entra aquí, la validación funcionó (bueno)
         Put_Line ("EXITO: Se capturó la excepción esperada.");
         Put_Line ("Mensaje de error: " & Ada.Exceptions.Exception_Message (E));
   end;

end Main;
