with Cuentas;
with Length;

package Cuenta_Ahorros is

   type Tasa_Interes_Type is delta 0.01 range 0.0 .. Length.MAX_TASA_INTERES;

   type Cuenta_Ahorros_Type is new Cuentas.Cuenta_Type with private;

   subtype Saldo_Ahorros_Type is Cuentas.Saldo_Type with
      Dynamic_Predicate => Saldo_Ahorros_Type >= 0.0;

   function Crear_Cuenta_Ahorros
     (Numero_Cuenta : String;
      Saldo         : Saldo_Ahorros_Type;
      Estado        : Cuentas.Estado_Type)
      return Cuenta_Ahorros_Type
   with
      Pre => Numero_Cuenta'Length = Cuentas.NUMERO_CUENTA_LEN;

   function Get_Tasa_Interes (C : Cuenta_Ahorros_Type) return Tasa_Interes_Type;

   -- Sobreescribimos Set_Saldo para asegurar que no sea negativo en tiempo de ejecución si se usa polimorfismo,
   -- o simplemente confiamos en el tipo del parametro si se usa estáticamente.
   overriding procedure Set_Saldo (C : in out Cuenta_Ahorros_Type; Saldo : Cuentas.Saldo_Type)
     with Pre => Saldo >= 0.0;

private

   type Cuenta_Ahorros_Type is new Cuentas.Cuenta_Type with record
      Tasa_Interes : Tasa_Interes_Type;
   end record;

end Cuenta_Ahorros;
