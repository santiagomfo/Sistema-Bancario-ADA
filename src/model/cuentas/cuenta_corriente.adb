package body Cuenta_Corriente with SPARK_Mode => On is

   overriding function Crear_Cuenta
     (Saldo         : Cuentas.Saldo_Type;
      Estado        : Cuentas.Estado_Type)
      return Cuenta_Corriente_Type
   with SPARK_Mode => Off
   is
   begin
      return Crear_Cuenta_Corriente (Saldo, Estado);
   end Crear_Cuenta;

   function Crear_Cuenta_Corriente
     (Saldo             : Cuentas.Saldo_Type;
      Estado            : Cuentas.Estado_Type)
      return Cuenta_Corriente_Type
   with SPARK_Mode => Off
   is
      Base : constant Cuentas.Cuenta_Type :=
         Cuentas.Crear_Cuenta (Saldo, Estado);
   begin
      return (Base with
         Limite_Sobregiro  => Length.MAX_LIMITE_SOBREGIRO,
         Interes_Sobregiro => Interes_Sobregiro_Fijo_Type (Length.DEFAULT_INTERES_SOBREGIRO));
   end Crear_Cuenta_Corriente;

   --  Get_Limite_Sobregiro y Get_Interes_Sobregiro completados como
   --  expression functions en la parte privada del spec.

   overriding procedure Set_Saldo (C : in out Cuenta_Corriente_Type; Saldo : Cuentas.Saldo_Type) is
   begin
      -- La validación del límite de sobregiro se realiza en la precondición
      Cuentas.Set_Saldo (Cuentas.Cuenta_Type (C), Saldo);
   end Set_Saldo;

end Cuenta_Corriente;
