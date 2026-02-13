with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;
with Clientes;
with Clientes_Service;
with Cuentas;
with Movimiento_Service;
with Movimientos;

procedure Main is
   Cliente_1, Cliente_2 : Clientes.Cliente_Type;
   Cuenta_1, Cuenta_2   : Cuentas.Cuenta_Access;

   -- Variables for results with specific discriminants
   Mov_Res_Dep : Movimientos.Movimiento_Type (Movimientos.Deposito);
   Mov_Res_Ret : Movimientos.Movimiento_Type (Movimientos.Retiro);
   Mov_Res_Tra : Movimientos.Movimiento_Type (Movimientos.Transferencia);
begin
   Put_Line ("--- Sistema Bancario - Inicio ---");

   -------------------------------------------------------
   -- 1. Crear Cliente 1
   -------------------------------------------------------
   begin
      Clientes_Service.Crear_Cliente
        (Resultado     => Cliente_1,
         Cuenta_Nueva  => Cuenta_1,
         Cedula        => "0102030405",
         Nombre        => "Juan",
         Apellido      => "Perez",
         Direccion     => "Calle 1",
         Correo        => "juan@mail.com",
         Telefono      => "0999999999",
         Tipo_Cuenta   => Clientes_Service.Ahorros,
         Saldo_Inicial => 1000.00);

      Put_Line ("Cliente 1 creado: " & Clientes.Get_Nombre (Cliente_1) &
                " (Saldo: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)) &
                ")");
   exception
      when E : others =>
         Put_Line ("Error creando Cliente 1: " &
                   Ada.Exceptions.Exception_Message (E));
         return;
   end;

   -------------------------------------------------------
   -- 2. Crear Cliente 2
   -------------------------------------------------------
   begin
      Clientes_Service.Crear_Cliente
        (Resultado     => Cliente_2,
         Cuenta_Nueva  => Cuenta_2,
         Cedula        => "0203040506",
         Nombre        => "Maria",
         Apellido      => "Lopez",
         Direccion     => "Calle 2",
         Correo        => "maria@mail.com",
         Telefono      => "0988888888",
         Tipo_Cuenta   => Clientes_Service.Corriente,
         Saldo_Inicial => 500.00);

      Put_Line ("Cliente 2 creado: " & Clientes.Get_Nombre (Cliente_2) &
                " (Saldo: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)) &
                ")");
   exception
      when E : others =>
         Put_Line ("Error creando Cliente 2: " &
                   Ada.Exceptions.Exception_Message (E));
         return;
   end;

   Put_Line ("");

   -------------------------------------------------------
   -- 3. Depósito en Cuenta 1
   -------------------------------------------------------
   Put_Line ("--- Realizando Deposito en Cuenta 1 (+100.00) ---");
   Movimiento_Service.Deposito
     (Id_Mov         => 1,
      Cuenta_Destino => Cuenta_1.all,
      Monto          => 100.00,
      Descripcion    => "Deposito inicial",
      Resultado      => Mov_Res_Dep);

   Put_Line ("Nuevo Saldo Cliente 1: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));

   -------------------------------------------------------
   -- 4. Retiro en Cuenta 1
   -------------------------------------------------------
   Put_Line ("");
   Put_Line ("--- Realizando Retiro en Cuenta 1 (-50.00) ---");
   Movimiento_Service.Retiro
     (Id_Mov        => 2,
      Cuenta_Origen => Cuenta_1.all,
      Monto         => 50.00,
      Descripcion   => "Retiro para gastos",
      Resultado     => Mov_Res_Ret);

   Put_Line ("Nuevo Saldo Cliente 1: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));

   -------------------------------------------------------
   -- 5. Transferencia de Cuenta 1 a Cuenta 2
   -------------------------------------------------------
   Put_Line ("");
   Put_Line ("--- Transferencia de Cliente 1 a Cliente 2 (200.00) ---");
   Movimiento_Service.Transferencia
     (Id_Mov         => 3,
      Cuenta_Origen  => Cuenta_1.all,
      Cuenta_Destino => Cuenta_2.all,
      Monto          => 200.00,
      Descripcion    => "Pago de deuda",
      Resultado      => Mov_Res_Tra);

   Put_Line ("Saldo Final Cliente 1: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   Put_Line ("Saldo Final Cliente 2: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)));

   Put_Line ("");
   Put_Line ("--- Fin de operaciones ---");
end Main;
