package body Cuenta_Ahorros is

   function Crear_Cuenta_Ahorros
     (Numero_Cuenta : String;
      Saldo         : Saldo_Ahorros_Type;
      Estado        : Cuentas.Estado_Type)
      return Cuenta_Ahorros_Type
   is
      Base : constant Cuentas.Cuenta_Type :=
         Cuentas.Crear_Cuenta (Numero_Cuenta, Saldo, Estado);
   begin
      return (Base with Tasa_Interes => Length.DEFAULT_TASA_INTERES_AHORROS);
   end Crear_Cuenta_Ahorros;

   function Get_Tasa_Interes (C : Cuenta_Ahorros_Type) return Tasa_Interes_Type is
   begin
      return C.Tasa_Interes;
   end Get_Tasa_Interes;

   overriding procedure Set_Saldo (C : in out Cuenta_Ahorros_Type; Saldo : Cuentas.Saldo_Type) is
   begin
      -- La precondición ya verifica Saldo >= 0.0
      Cuentas.Set_Saldo (Cuentas.Cuenta_Type (C), Saldo);
   end Set_Saldo;

end Cuenta_Ahorros;
