with Ada.Calendar;
with Length;

package Cuentas is

   NUMERO_CUENTA_LEN : constant := Length.MAX_NUMERO_CUENTA;

   type Saldo_Type is delta 0.01 range Length.MIN_SALDO .. Length.MAX_SALDO;
   type Estado_Type is (Activa, Bloqueada);
   subtype Id_Cliente_Type is Natural range 1 .. Natural'Last;

   type Cuenta_Type is private;

   function Crear_Cuenta
     (Numero_Cuenta : String;
      Saldo         : Saldo_Type;
      Estado        : Estado_Type;
      Cliente       : Id_Cliente_Type)
      return Cuenta_Type
   with
      Pre => Numero_Cuenta'Length = NUMERO_CUENTA_LEN;

   function Get_Numero_Cuenta (C : Cuenta_Type) return String;
   function Get_Saldo (C : Cuenta_Type) return Saldo_Type;
   function Get_Fecha_Apertura (C : Cuenta_Type) return Ada.Calendar.Time;
   function Get_Estado (C : Cuenta_Type) return Estado_Type;
   function Get_Cliente (C : Cuenta_Type) return Id_Cliente_Type;

   procedure Set_Saldo (C : in out Cuenta_Type; Saldo : Saldo_Type);
   procedure Set_Estado (C : in out Cuenta_Type; Estado : Estado_Type);

private

   type Cuenta_Type is record
      Numero_Cuenta  : String (1 .. NUMERO_CUENTA_LEN);
      Saldo          : Saldo_Type;
      Fecha_Apertura : Ada.Calendar.Time;
      Estado         : Estado_Type;
      Cliente        : Id_Cliente_Type;
   end record;

end Cuentas;
