package body Cuenta_Ahorros is
   use type Cuentas.Saldo_Type;

   overriding function Crear_Cuenta
     (Saldo         : Cuentas.Saldo_Type;
      Estado        : Cuentas.Estado_Type)
      return Cuenta_Ahorros_Type
   is
   begin
      if Saldo < 0.0 then
         raise Program_Error with "Saldo inicial negativo no permitido en Cuenta Ahorros";
      end if;
      return Crear_Cuenta_Ahorros (Saldo_Ahorros_Type (Saldo), Estado);
   end Crear_Cuenta;

   function Crear_Cuenta_Ahorros
     (Saldo         : Saldo_Ahorros_Type;
      Estado        : Cuentas.Estado_Type)
      return Cuenta_Ahorros_Type
   is
      Base : constant Cuentas.Cuenta_Type :=
         Cuentas.Crear_Cuenta (Saldo, Estado);
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
