with Cuentas;
with Cuenta_Corriente;

package body Cuentas_Corriente_Service is

   procedure Aplicar_Interes (Cuenta : in out Cuenta_Corriente.Cuenta_Corriente_Type) is
      Saldo_Actual   : constant Cuentas.Saldo_Type := Cuentas.Get_Saldo (Cuentas.Cuenta_Type (Cuenta));
      Tasa_Anual     : constant Cuenta_Corriente.Interes_Sobregiro_Type := Cuenta_Corriente.Get_Interes_Sobregiro (Cuenta);
      Factor_Mensual : constant Cuentas.Saldo_Type := Cuentas.Saldo_Type (Tasa_Anual) / 100.0 / 12.0;
      Interes        : Cuentas.Saldo_Type;
   begin
      if Saldo_Actual < 0.0 then
         Interes := Saldo_Actual * Factor_Mensual;
         Cuenta_Corriente.Set_Saldo (Cuenta, Saldo_Actual + Interes);
      end if;
   end Aplicar_Interes;

end Cuentas_Corriente_Service;
