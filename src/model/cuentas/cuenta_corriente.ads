with Cuentas;
with Length;

package Cuenta_Corriente is
   use type Cuentas.Saldo_Type;

   type Interes_Sobregiro_Type is delta 0.01 range 0.0 .. Length.MAX_TASA_INTERES;
   type Limite_Sobregiro_Type is delta 0.01 range 0.0 .. Length.MAX_LIMITE_SOBREGIRO;

   type Cuenta_Corriente_Type is new Cuentas.Cuenta_Type with private;

   overriding function Crear_Cuenta
     (Saldo         : Cuentas.Saldo_Type;
      Estado        : Cuentas.Estado_Type)
      return Cuenta_Corriente_Type;

   function Crear_Cuenta_Corriente
     (Saldo             : Cuentas.Saldo_Type;
      Estado            : Cuentas.Estado_Type)
      return Cuenta_Corriente_Type
   with
      Pre =>
         Saldo >= -Cuentas.Saldo_Type (Length.DEFAULT_LIMITE_SOBREGIRO);

   function Get_Limite_Sobregiro (C : Cuenta_Corriente_Type) return Limite_Sobregiro_Type;
   function Get_Interes_Sobregiro (C : Cuenta_Corriente_Type) return Interes_Sobregiro_Type;

   overriding procedure Set_Saldo (C : in out Cuenta_Corriente_Type; Saldo : Cuentas.Saldo_Type)
     with Pre => Saldo >= -Cuentas.Saldo_Type (Get_Limite_Sobregiro (C));

private

   type Cuenta_Corriente_Type is new Cuentas.Cuenta_Type with record
      Limite_Sobregiro  : Limite_Sobregiro_Type;
      Interes_Sobregiro : Interes_Sobregiro_Type;
   end record;

end Cuenta_Corriente;
