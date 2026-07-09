--  Body fuera de SPARK: la ejecucion de estrategias despacha sobre
--  Cuenta_Type'Class (Strategy pattern). Aislado del analisis SPARK.
package body Transaccion with SPARK_Mode => Off is

   function Get_Tipo (Self : Deposito_Strategy) return Estrategia_Transaccion is
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

   function Get_Tipo (Self : Transferencia_Strategy) return Estrategia_Transaccion is
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

   function Get_Tipo (Self : Retiro_Strategy) return Estrategia_Transaccion is
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
