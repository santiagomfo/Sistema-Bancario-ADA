with Cuentas;
with Length;

package Cuenta_Ahorros with SPARK_Mode => On is
   pragma Elaborate_Body;  --  Requerido por SPARK (early call region, E0003)
   use type Cuentas.Saldo_Type;

   type Tasa_Interes_Type is new Float;
   subtype Tasa_Interes_Fija_Type is Tasa_Interes_Type
      with Static_Predicate =>
         Tasa_Interes_Fija_Type = Tasa_Interes_Type (Length.DEFAULT_TASA_INTERES_AHORROS);

   type Cuenta_Ahorros_Type is new Cuentas.Cuenta_Type with private;

   subtype Saldo_Ahorros_Type is Cuentas.Saldo_Type with
      Dynamic_Predicate => Saldo_Ahorros_Type >= 0.0;

   --  Constructores: heredan el uso de Ada.Calendar.Clock del tipo base
   --  (Cuentas.Crear_Cuenta) -> fuera del subconjunto SPARK.
   overriding function Crear_Cuenta
     (Saldo         : Cuentas.Saldo_Type;
      Estado        : Cuentas.Estado_Type)
      return Cuenta_Ahorros_Type
   with SPARK_Mode => Off, Pre => Saldo >= 0.0;

   function Crear_Cuenta_Ahorros
     (Saldo         : Saldo_Ahorros_Type;
      Estado        : Cuentas.Estado_Type)
      return Cuenta_Ahorros_Type
   with SPARK_Mode => Off;

   function Get_Tasa_Interes (C : Cuenta_Ahorros_Type) return Tasa_Interes_Type;

   --  El invariante estricto (Saldo >= 0) NO puede fortalecer la Pre'Class del
   --  padre sin violar LSP; se garantiza en construccion via Saldo_Ahorros_Type.
   --  Este override hereda la Pre'Class del padre (Saldo >= MIN_SALDO).
   overriding procedure Set_Saldo (C : in out Cuenta_Ahorros_Type; Saldo : Cuentas.Saldo_Type);

private

   type Cuenta_Ahorros_Type is new Cuentas.Cuenta_Type with record
      Tasa_Interes : Tasa_Interes_Fija_Type;
   end record;

   function Get_Tasa_Interes (C : Cuenta_Ahorros_Type) return Tasa_Interes_Type
   is (C.Tasa_Interes);

end Cuenta_Ahorros;
