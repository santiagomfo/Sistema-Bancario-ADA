with Ada.Strings.Fixed;
with Ada.Strings;

package body Cuentas is
   use Numero_Cuenta_Str;

   Ultimo_Numero : Natural := 0;

   function Generar_Numero_Cuenta return Numero_Cuenta_Str.Bounded_String is
      Num_Str : String := Natural'Image (Ultimo_Numero);
      -- 'Image retorna con un espacio al inicio para números positivos
      Trimmed : constant String := Ada.Strings.Fixed.Trim (Num_Str, Ada.Strings.Left);
      Result  : String (1 .. Length.MAX_NUMERO_CUENTA) := (others => '0');
   begin
      if Trimmed'Length <= Length.MAX_NUMERO_CUENTA then
         Result (Length.MAX_NUMERO_CUENTA - Trimmed'Length + 1 .. Length.MAX_NUMERO_CUENTA) := Trimmed;
      else
         -- Si excede, tomamos los ultimos digitos (o podria lanzarse excepcion)
         Result := Trimmed (Trimmed'Last - Length.MAX_NUMERO_CUENTA + 1 .. Trimmed'Last);
      end if;
      return To_Bounded_String (Result);
   end Generar_Numero_Cuenta;

   function Crear_Cuenta
     (Saldo         : Saldo_Type;
      Estado        : Estado_Type)
      return Cuenta_Type
   is
   begin
      Ultimo_Numero := Ultimo_Numero + 1;
      return Cuenta_Type'(
         Numero_Cuenta  => Generar_Numero_Cuenta,
         Saldo          => Saldo,
         Fecha_Apertura => Ada.Calendar.Clock,
         Estado         => Estado
      );
   end Crear_Cuenta;

   function Get_Numero_Cuenta (C : Cuenta_Type) return String is
   begin
      return To_String (C.Numero_Cuenta);
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
      C.Saldo := C.Saldo - Monto;
   end Debitar;

end Cuentas;
