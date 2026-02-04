package body Movimiento_Service is

   package Mov renames Movimientos;
   package Cta renames Model.Cuentas;

   LIMITE_TRANSACCION : constant Mov.Dinero_Type := Mov.Dinero_Type(Length.MAX_TRANSACCION);

   procedure Deposito
     (Id_Mov      : Mov.Id_Movimiento_Type;
      Cta_Destino : in out Cta.Cuenta_Type;
      Monto       : Mov.Dinero_Type;
      Descripcion : String;
      Resultado   : out Mov.Movimiento_Type)
   is
   begin
      Resultado := Mov.Crear_Movimiento
        (Id           => Id_Mov,
         Monto        => Monto,
         Descripcion  => Descripcion,
         Tipo         => Mov.Deposito,
         Monto_Maximo => LIMITE_TRANSACCION,
         Destino      => Cta.Get_Id(Cta_Destino)); -- Solo ID

      -- 2. Ejecutar Lógica (Modificar Saldo en Memoria)
      Cta.Acreditar(Cta_Destino, Monto);
   end Deposito;

   procedure Retiro
     (Id_Mov      : Mov.Id_Movimiento_Type;
      Cta_Origen  : in out Cta.Cuenta_Type;
      Monto       : Mov.Dinero_Type;
      Descripcion : String;
      Resultado   : out Mov.Movimiento_Type)
   is
   begin
      if Monto > LIMITE_TRANSACCION then
          raise Transaccion_Invalida with "Monto excede el límite permitido";
      end if;

      Resultado := Mov.Crear_Movimiento
        (Id           => Id_Mov,
         Monto        => Monto,
         Descripcion  => Descripcion,
         Tipo         => Mov.Retiro,
         Monto_Maximo => LIMITE_TRANSACCION,
         Origen       => Cta.Get_Id(Cta_Origen));

      Cta.Debitar(Cta_Origen, Monto);
   end Retiro;

   procedure Transferencia
     (Id_Mov      : Mov.Id_Movimiento_Type;
      Cta_Origen  : in out Cta.Cuenta_Type;
      Cta_Destino : in out Cta.Cuenta_Type;
      Monto       : Mov.Dinero_Type;
      Descripcion : String;
      Resultado   : out Mov.Movimiento_Type)
   is
   begin
      if Monto > LIMITE_TRANSACCION then
          raise Transaccion_Invalida with "Monto excede el límite permitido";
      end if;

      Resultado := Mov.Crear_Movimiento
        (Id           => Id_Mov,
         Monto        => Monto,
         Descripcion  => Descripcion,
         Tipo         => Mov.Transferencia,
         Monto_Maximo => LIMITE_TRANSACCION,
         Origen       => Cta.Get_Id(Cta_Origen),
         Destino      => Cta.Get_Id(Cta_Destino));

      Cta.Debitar(Cta_Origen, Monto);
      Cta.Acreditar(Cta_Destino, Monto);
   end Transferencia;

end Movimiento_Service;
