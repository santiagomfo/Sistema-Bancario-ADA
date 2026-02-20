with Ada.Numerics.Discrete_Random;

package body Tarjeta_Credito is

   -- Generador de números aleatorios para el número de tarjeta
   subtype Digito_Range is Natural range 0 .. 9;
   package Random_Digito is new Ada.Numerics.Discrete_Random (Digito_Range);
   Gen : Random_Digito.Generator;

   -- Constructor
   function Crear_Tarjeta_Credito
     (Tasa_Interes_Mensual  : Tasa_Interes_Type := Length.DEFAULT_TASA_INTERES_TARJETA)
      return Tarjeta_Credito_Type
   is
      use Ada.Calendar;
      use Numero_Tarjeta_Str;

      Tarjeta      : Tarjeta_Credito_Type;
      Numero       : String (1 .. Length.MAX_NUMERO_TARJETA);
      Ahora        : constant Ada.Calendar.Time := Clock;
      Vigencia     : constant Duration := 365.0 * Length.DEFAULT_VIGENCIA_ANIOS * 86_400.0;
   begin
      -- Generar número de tarjeta aleatorio de 10 dígitos (identificador único)
      Random_Digito.Reset (Gen);
      for I in Numero'Range loop
         Numero (I) := Character'Val (Character'Pos ('0') + Random_Digito.Random (Gen));
      end loop;
      Tarjeta.Numero_Tarjeta := To_Bounded_String (Numero);

      -- Asignar valores
      Tarjeta.Limite_Credito := Length.DEFAULT_LIMITE_CREDITO;
      Tarjeta.Saldo_Utilizado := 0.0;
      Tarjeta.Fecha_Emision := Ahora;
      Tarjeta.Fecha_Vencimiento := Ahora + Vigencia;
      Tarjeta.Tasa_Interes_Mensual := Tasa_Interes_Mensual;

      return Tarjeta;
   end Crear_Tarjeta_Credito;

   -- Getters
   function Get_Numero_Tarjeta (T : Tarjeta_Credito_Type) return String is
   begin
      return Numero_Tarjeta_Str.To_String (T.Numero_Tarjeta);
   end Get_Numero_Tarjeta;

   function Get_Limite_Credito (T : Tarjeta_Credito_Type) return Limite_Credito_Type is
   begin
      return T.Limite_Credito;
   end Get_Limite_Credito;

   function Get_Saldo_Utilizado (T : Tarjeta_Credito_Type) return Saldo_Type is
   begin
      return T.Saldo_Utilizado;
   end Get_Saldo_Utilizado;

   function Get_Fecha_Emision (T : Tarjeta_Credito_Type) return Ada.Calendar.Time is
   begin
      return T.Fecha_Emision;
   end Get_Fecha_Emision;

   function Get_Fecha_Vencimiento (T : Tarjeta_Credito_Type) return Ada.Calendar.Time is
   begin
      return T.Fecha_Vencimiento;
   end Get_Fecha_Vencimiento;

   function Get_Tasa_Interes_Mensual (T : Tarjeta_Credito_Type) return Tasa_Interes_Type is
   begin
      return T.Tasa_Interes_Mensual;
   end Get_Tasa_Interes_Mensual;

   -- Operaciones de consulta
   function Get_Credito_Disponible (T : Tarjeta_Credito_Type) return Saldo_Type is
   begin
      return Saldo_Type (T.Limite_Credito) - T.Saldo_Utilizado;
   end Get_Credito_Disponible;

   function Esta_Al_Limite (T : Tarjeta_Credito_Type) return Boolean is
   begin
      return T.Saldo_Utilizado >= Saldo_Type (T.Limite_Credito);
   end Esta_Al_Limite;

   function Get_Pago_Minimo (T : Tarjeta_Credito_Type) return Saldo_Type is
   begin
      return Saldo_Type (Float (T.Saldo_Utilizado) * Float (Length.MIN_PAGO_MENSUAL_PORCENTAJE) / 100.0);
   end Get_Pago_Minimo;

   function Esta_Vencida (T : Tarjeta_Credito_Type) return Boolean is
      use Ada.Calendar;
   begin
      return Clock > T.Fecha_Vencimiento;
   end Esta_Vencida;

   -- Operaciones de modificación
   procedure Incrementar_Deuda (T : in out Tarjeta_Credito_Type; Monto : Saldo_Type) is
   begin
      T.Saldo_Utilizado := T.Saldo_Utilizado + Monto;
   end Incrementar_Deuda;

   procedure Reducir_Deuda (T : in out Tarjeta_Credito_Type; Monto : Saldo_Type) is
   begin
      T.Saldo_Utilizado := T.Saldo_Utilizado - Monto;
   end Reducir_Deuda;

   procedure Aplicar_Interes (T : in out Tarjeta_Credito_Type) is
      Interes : constant Saldo_Type :=
        Saldo_Type (Float (T.Saldo_Utilizado) * Float (T.Tasa_Interes_Mensual) / 100.0);
   begin
      T.Saldo_Utilizado := T.Saldo_Utilizado + Interes;
   end Aplicar_Interes;

   procedure Set_Limite_Credito (T : in out Tarjeta_Credito_Type; Nuevo_Limite : Limite_Credito_Type) is
   begin
      T.Limite_Credito := Nuevo_Limite;
   end Set_Limite_Credito;

end Tarjeta_Credito;
