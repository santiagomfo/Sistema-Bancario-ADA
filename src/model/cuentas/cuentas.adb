package body Cuentas is

   function Crear_Cuenta
     (Numero_Cuenta : String;
      Saldo         : Saldo_Type;
      Estado        : Estado_Type;
      Cliente       : Id_Cliente_Type)
      return Cuenta_Type
   is
   begin
      return Cuenta_Type'(
         Numero_Cuenta  => Numero_Cuenta,
         Saldo          => Saldo,
         Fecha_Apertura => Ada.Calendar.Clock,
         Estado         => Estado,
         Cliente        => Cliente
      );
   end Crear_Cuenta;

   function Get_Numero_Cuenta (C : Cuenta_Type) return String is
   begin
      return C.Numero_Cuenta;
   end Get_Numero_Cuenta;

   function Get_Saldo (C : Cuenta_Type) return Saldo_Type is
   begin
      return C.Saldo;
   end Get_Saldo;

   function Get_Fecha_Apertura (C : Cuenta_Type) return Ada.Calendar.Time is
   begin
      return C.Fecha_Apertura;
   end Get_Fecha_Apertura;

   function Get_Estado (C : Cuenta_Type) return Estado_Type is
   begin
      return C.Estado;
   end Get_Estado;

   function Get_Cliente (C : Cuenta_Type) return Id_Cliente_Type is
   begin
      return C.Cliente;
   end Get_Cliente;

   procedure Set_Saldo (C : in out Cuenta_Type; Saldo : Saldo_Type) is
   begin
      C.Saldo := Saldo;
   end Set_Saldo;

   procedure Set_Estado (C : in out Cuenta_Type; Estado : Estado_Type) is
   begin
      C.Estado := Estado;
   end Set_Estado;

end Cuentas;
