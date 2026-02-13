package body Strategies is

   procedure Ejecutar (Self    : Deposito_Strategy;
                       Origen  : in out Cuenta_Type;
                       Destino : in out Cuenta_Type;
                       Monto   : Saldo_Type) is
   begin
      Cuentas.Acreditar(Destino, Monto);
   end Ejecutar;

   procedure Ejecutar (Self    : Transferencia_Strategy;
                       Origen  : in out Cuenta_Type;
                       Destino : in out Cuenta_Type;
                       Monto   : Saldo_Type) is
   begin
      Cuentas.Debitar(Origen, Monto);
      Cuentas.Acreditar(Destino, Monto);
   end Ejecutar;

   procedure Ejecutar (Self    : Retiro_Strategy;
                       Origen  : in out Cuenta_Type;
                       Destino : in out Cuenta_Type;
                       Monto   : Saldo_Type) is
   begin
      Cuentas.Debitar(Origen, Monto);
   end Ejecutar;

end Strategies;
