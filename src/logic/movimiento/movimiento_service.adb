package body Movimiento_Service is

   package Mov renames Movimientos;
   package Cta renames Cuentas;

   LIMITE_TRANSACCION : constant Mov.Dinero_Type := Mov.Dinero_Type (Length.MAX_TRANSACCION);

   procedure Deposito
     (Id_Mov         : Mov.Id_Movimiento_Type;
      Cuenta_Destino : in out Cta.Cuenta_Type'Class;
      Monto          : Mov.Dinero_Type;
      Descripcion    : String;
      Resultado      : out Mov.Movimiento_Type)
   is
   begin
      Resultado := Mov.Crear_Movimiento
        (Id             => Id_Mov,
         Monto          => Monto,
         Descripcion    => Descripcion,
         Tipo           => Mov.Deposito,
         Monto_Maximo   => LIMITE_TRANSACCION,
         Cuenta_Destino => Cta.Get_Id (Cuenta_Destino));

      Cta.Acreditar (Cuenta_Destino, Cta.Saldo_Type (Monto));
   end Deposito;

   procedure Retiro
     (Id_Mov        : Mov.Id_Movimiento_Type;
      Cuenta_Origen : in out Cta.Cuenta_Type'Class;
      Monto         : Mov.Dinero_Type;
      Descripcion   : String;
      Resultado     : out Mov.Movimiento_Type)
   is
   begin
      if Monto > LIMITE_TRANSACCION then
         raise Transaccion_Invalida with "Monto excede el límite permitido";
      end if;

      Resultado := Mov.Crear_Movimiento
        (Id            => Id_Mov,
         Monto         => Monto,
         Descripcion   => Descripcion,
         Tipo          => Mov.Retiro,
         Monto_Maximo  => LIMITE_TRANSACCION,
         Cuenta_Origen => Cta.Get_Id (Cuenta_Origen));

      Cta.Debitar (Cuenta_Origen, Cta.Saldo_Type (Monto));
   end Retiro;

   procedure Transferencia
     (Id_Mov         : Mov.Id_Movimiento_Type;
      Cuenta_Origen  : in out Cta.Cuenta_Type'Class;
      Cuenta_Destino : in out Cta.Cuenta_Type'Class;
      Monto          : Mov.Dinero_Type;
      Descripcion    : String;
      Resultado      : out Mov.Movimiento_Type)
   is
   begin
      if Monto > LIMITE_TRANSACCION then
         raise Transaccion_Invalida with "Monto excede el límite permitido";
      end if;

      Resultado := Mov.Crear_Movimiento
        (Id             => Id_Mov,
         Monto          => Monto,
         Descripcion    => Descripcion,
         Tipo           => Mov.Transferencia,
         Monto_Maximo   => LIMITE_TRANSACCION,
         Cuenta_Origen  => Cta.Get_Id (Cuenta_Origen),
         Cuenta_Destino => Cta.Get_Id (Cuenta_Destino));

      Cta.Debitar (Cuenta_Origen, Cta.Saldo_Type (Monto));
      Cta.Acreditar (Cuenta_Destino, Cta.Saldo_Type (Monto));
   end Transferencia;

end Movimiento_Service;
