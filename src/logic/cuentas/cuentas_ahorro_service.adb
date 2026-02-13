with Cuentas;
with Cuenta_Ahorros;

package body Cuentas_Ahorro_Service is

   procedure Aplicar_Interes (Cuenta : in out Cuenta_Ahorros.Cuenta_Ahorros_Type) is
      Saldo_Actual   : constant Cuentas.Saldo_Type := Cuentas.Get_Saldo (Cuentas.Cuenta_Type (Cuenta));
      Tasa_Anual     : constant Cuenta_Ahorros.Tasa_Interes_Type := Cuenta_Ahorros.Get_Tasa_Interes (Cuenta);
      Factor_Mensual : constant Cuentas.Saldo_Type := Cuentas.Saldo_Type (Tasa_Anual) / 100.0 / 12.0;
      Interes        : Cuentas.Saldo_Type;
   begin
      if Saldo_Actual > 0.0 then
         Interes := Saldo_Actual * Factor_Mensual;
         Cuenta_Ahorros.Set_Saldo (Cuenta, Saldo_Actual + Interes);
      end if;
   end Aplicar_Interes;

end Cuentas_Ahorro_Service;
