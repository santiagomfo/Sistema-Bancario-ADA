package body Transaccion is

   function Get_Tipo (Self : Deposito_Strategy) return Tipo_Estrategia is
   begin
      return Deposito;
   end Get_Tipo;

   procedure Ejecutar (Self    : Deposito_Strategy;
                       Origen  : in out Cuenta_Type'Class;
                       Destino : in out Cuenta_Type'Class;
                       Monto   : Saldo_Type) is
   begin
      Cuentas.Acreditar(Destino, Monto);
   end Ejecutar;

   function Get_Tipo (Self : Transferencia_Strategy) return Tipo_Estrategia is
   begin
      return Transferencia;
   end Get_Tipo;

   procedure Ejecutar (Self    : Transferencia_Strategy;
                       Origen  : in out Cuenta_Type'Class;
                       Destino : in out Cuenta_Type'Class;
                       Monto   : Saldo_Type) is
   begin
      Cuentas.Debitar(Origen, Monto);
      Cuentas.Acreditar(Destino, Monto);
   end Ejecutar;

   function Get_Tipo (Self : Retiro_Strategy) return Tipo_Estrategia is
   begin
      return Retiro;
   end Get_Tipo;

   procedure Ejecutar (Self    : Retiro_Strategy;
                       Origen  : in out Cuenta_Type'Class;
                       Destino : in out Cuenta_Type'Class;
                       Monto   : Saldo_Type) is
   begin
      Cuentas.Debitar(Origen, Monto);
   end Ejecutar;

end Transaccion;
