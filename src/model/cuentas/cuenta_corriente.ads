with Cuentas;
with Length;

package Cuenta_Corriente with SPARK_Mode => On is
   pragma Elaborate_Body;  --  Requerido por SPARK (early call region, E0003)
   use type Cuentas.Saldo_Type;

   type Interes_Sobregiro_Type is new Float;
   subtype Interes_Sobregiro_Fijo_Type is Interes_Sobregiro_Type
      with Static_Predicate =>
         Interes_Sobregiro_Fijo_Type = Interes_Sobregiro_Type (Length.DEFAULT_INTERES_SOBREGIRO);
   type Limite_Sobregiro_Type is delta 0.01 range 0.0 .. Length.MAX_LIMITE_SOBREGIRO;

   type Cuenta_Corriente_Type is new Cuentas.Cuenta_Type with private;

   --  Constructores: heredan el uso de Ada.Calendar.Clock del tipo base -> fuera de SPARK.
   overriding function Crear_Cuenta
     (Saldo         : Cuentas.Saldo_Type;
      Estado        : Cuentas.Estado_Type)
      return Cuenta_Corriente_Type
   with SPARK_Mode => Off;

   function Crear_Cuenta_Corriente
     (Saldo             : Cuentas.Saldo_Type;
      Estado            : Cuentas.Estado_Type)
      return Cuenta_Corriente_Type
   with
      SPARK_Mode => Off,
      Pre =>
         Saldo >= -Cuentas.Saldo_Type (Length.MAX_LIMITE_SOBREGIRO);

   function Get_Limite_Sobregiro (C : Cuenta_Corriente_Type) return Limite_Sobregiro_Type;
   function Get_Interes_Sobregiro (C : Cuenta_Corriente_Type) return Interes_Sobregiro_Type;

   --  La cota estricta (Saldo >= -Limite_Sobregiro) NO puede fortalecer la
   --  Pre'Class del padre sin violar LSP; se garantiza en construccion. Este
   --  override hereda la Pre'Class del padre (Saldo >= MIN_SALDO = -2000).
   overriding procedure Set_Saldo (C : in out Cuenta_Corriente_Type; Saldo : Cuentas.Saldo_Type);

private

   type Cuenta_Corriente_Type is new Cuentas.Cuenta_Type with record
      Limite_Sobregiro  : Limite_Sobregiro_Type;
      Interes_Sobregiro : Interes_Sobregiro_Fijo_Type;
   end record;

   function Get_Limite_Sobregiro (C : Cuenta_Corriente_Type) return Limite_Sobregiro_Type
   is (C.Limite_Sobregiro);
   function Get_Interes_Sobregiro (C : Cuenta_Corriente_Type) return Interes_Sobregiro_Type
   is (C.Interes_Sobregiro);

end Cuenta_Corriente;
