with Ada.Strings.Fixed;
with Ada.Strings;

package body Cuentas is

   Ultimo_Numero : Natural := 0;

   function Generar_Proximo_Numero return String is
      Num_Str : String := Natural'Image (Ultimo_Numero);
      -- 'Image retorna con un espacio al inicio para números positivos
      Trimmed : constant String := Ada.Strings.Fixed.Trim (Num_Str, Ada.Strings.Left);
      Result  : String (1 .. NUMERO_CUENTA_LEN) := (others => '0');
   begin
      if Trimmed'Length <= NUMERO_CUENTA_LEN then
         Result (NUMERO_CUENTA_LEN - Trimmed'Length + 1 .. NUMERO_CUENTA_LEN) := Trimmed;
      else
         -- Si excede, tomamos los ultimos digitos (o podria lanzarse excepcion)
         Result := Trimmed (Trimmed'Last - NUMERO_CUENTA_LEN + 1 .. Trimmed'Last);
      end if;
      return Result;
   end Generar_Proximo_Numero;

   function Crear_Cuenta
     (Saldo         : Saldo_Type;
      Estado        : Estado_Type)
      return Cuenta_Type
   is
   begin
      Ultimo_Numero := Ultimo_Numero + 1;
      return Cuenta_Type'(
         Id             => Ultimo_Numero,
         Numero_Cuenta  => Generar_Proximo_Numero,
         Saldo          => Saldo,
         Fecha_Apertura => Ada.Calendar.Clock,
         Estado         => Estado
      );
   end Crear_Cuenta;

   function Get_Id (C : Cuenta_Type) return Natural is
   begin
      return C.Id;
   end Get_Id;

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

   procedure Set_Saldo (C : in out Cuenta_Type; Saldo : Saldo_Type) is
   begin
      C.Saldo := Saldo;
   end Set_Saldo;

   procedure Set_Estado (C : in out Cuenta_Type; Estado : Estado_Type) is
   begin
      C.Estado := Estado;
   end Set_Estado;

   procedure Acreditar (C : in out Cuenta_Type; Monto : Saldo_Type) is
   begin
      C.Saldo := C.Saldo + Monto;
   end Acreditar;

   procedure Debitar (C : in out Cuenta_Type; Monto : Saldo_Type) is
   begin
      if C.Saldo < Monto then
         raise Saldo_Insuficiente;
      end if;
      C.Saldo := C.Saldo - Monto;
   end Debitar;

end Cuentas;
