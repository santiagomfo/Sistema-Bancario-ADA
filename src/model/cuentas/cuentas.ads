with Ada.Calendar;
with Length;

package Cuentas is

   NUMERO_CUENTA_LEN : constant := Length.MAX_NUMERO_CUENTA;

   type Saldo_Type is delta 0.01 digits 18;
   type Estado_Type is (Activa, Bloqueada);

   Saldo_Insuficiente : exception;

   type Cuenta_Type is tagged private;
   type Cuenta_Access is access all Cuenta_Type'Class;

   function Crear_Cuenta
     (Saldo         : Saldo_Type;
      Estado        : Estado_Type)
      return Cuenta_Type;

   function Get_Id (C : Cuenta_Type) return Natural;
   function Get_Numero_Cuenta (C : Cuenta_Type) return String;
   function Get_Saldo (C : Cuenta_Type) return Saldo_Type;
   function Get_Fecha_Apertura (C : Cuenta_Type) return Ada.Calendar.Time;
   function Get_Estado (C : Cuenta_Type) return Estado_Type;
   --  function Get_Cliente (C : Cuenta_Type) return Id_Cliente_Type; -- Eliminado

   procedure Set_Saldo (C : in out Cuenta_Type; Saldo : Saldo_Type);
   procedure Set_Estado (C : in out Cuenta_Type; Estado : Estado_Type);

   procedure Acreditar (C : in out Cuenta_Type; Monto : Saldo_Type)
     with Pre => Monto >= 0.0 and Get_Saldo (C) <= Saldo_Type'Last - Monto,
          Post => Get_Saldo (C) = Get_Saldo (C)'Old + Monto;

   procedure Debitar (C : in out Cuenta_Type; Monto : Saldo_Type)
     with Pre => Monto >= 0.0 and Get_Saldo (C) >= Monto and Get_Saldo (C) - Monto >= Length.MIN_SALDO,
          Post => Get_Saldo (C) = Get_Saldo (C)'Old - Monto;

private

   type Cuenta_Type is tagged record
      Id             : Natural;
      Numero_Cuenta  : String (1 .. NUMERO_CUENTA_LEN);
      Saldo          : Saldo_Type;
      Fecha_Apertura : Ada.Calendar.Time;
      Estado         : Estado_Type;
   end record;

end Cuentas;
