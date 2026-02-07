package body Cuenta_Corriente is

   function Crear_Cuenta_Corriente
     (Numero_Cuenta     : String;
      Saldo             : Cuentas.Saldo_Type;
      Estado            : Cuentas.Estado_Type)
      return Cuenta_Corriente_Type
   is
      Base : constant Cuentas.Cuenta_Type :=
         Cuentas.Crear_Cuenta (Numero_Cuenta, Saldo, Estado);
   begin
      return (Base with
         Limite_Sobregiro  => Length.DEFAULT_LIMITE_SOBREGIRO,
         Interes_Sobregiro => Length.DEFAULT_INTERES_SOBREGIRO);
   end Crear_Cuenta_Corriente;

   function Get_Limite_Sobregiro (C : Cuenta_Corriente_Type) return Limite_Sobregiro_Type is
   begin
      return C.Limite_Sobregiro;
   end Get_Limite_Sobregiro;

   function Get_Interes_Sobregiro (C : Cuenta_Corriente_Type) return Interes_Sobregiro_Type is
   begin
      return C.Interes_Sobregiro;
   end Get_Interes_Sobregiro;

   overriding procedure Set_Saldo (C : in out Cuenta_Corriente_Type; Saldo : Cuentas.Saldo_Type) is
   begin
      -- La validación del límite de sobregiro se realiza en la precondición o aquí
      if Saldo < -Cuentas.Saldo_Type (C.Limite_Sobregiro) then
         raise Program_Error with "El saldo excede el límite de sobregiro autorizado";
      end if;

      Cuentas.Set_Saldo (Cuentas.Cuenta_Type (C), Saldo);
   end Set_Saldo;

end Cuenta_Corriente;
