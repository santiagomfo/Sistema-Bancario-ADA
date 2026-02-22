with Ada.Calendar;
with Ada.Strings.Bounded;
with Length;

package Tarjeta_Credito is

   -- Tipos de datos
   type Saldo_Type is delta 0.01 digits 18;
   type Tasa_Interes_Type is new Float;
   subtype Tasa_Interes_Fija_Type is Tasa_Interes_Type
      with Static_Predicate =>
         Tasa_Interes_Fija_Type = Tasa_Interes_Type (Length.DEFAULT_TASA_INTERES_TARJETA);
   type Limite_Credito_Type is delta 0.01 range 0.0 .. Length.MAX_LIMITE_CREDITO;

   package Numero_Tarjeta_Str is new Ada.Strings.Bounded.Generic_Bounded_Length
     (Max => Length.MAX_NUMERO_TARJETA);

   -- Tipo tagged independiente (NO hereda de Cuenta_Type)
   type Tarjeta_Credito_Type is tagged private;
   type Tarjeta_Credito_Access is access all Tarjeta_Credito_Type'Class;

   -- Constructor
   function Crear_Tarjeta_Credito
      return Tarjeta_Credito_Type;

   -- Getters
   function Get_Numero_Tarjeta (T : Tarjeta_Credito_Type) return String;
   function Get_Limite_Credito (T : Tarjeta_Credito_Type) return Limite_Credito_Type;
   function Get_Saldo_Utilizado (T : Tarjeta_Credito_Type) return Saldo_Type;
   function Get_Fecha_Emision (T : Tarjeta_Credito_Type) return Ada.Calendar.Time;
   function Get_Fecha_Vencimiento (T : Tarjeta_Credito_Type) return Ada.Calendar.Time;
   function Get_Tasa_Interes_Mensual (T : Tarjeta_Credito_Type) return Tasa_Interes_Type;

   -- Operaciones de consulta
   function Get_Credito_Disponible (T : Tarjeta_Credito_Type) return Saldo_Type
   with
      Post => Get_Credito_Disponible'Result =
              Saldo_Type (Get_Limite_Credito (T)) - Get_Saldo_Utilizado (T);

   function Esta_Al_Limite (T : Tarjeta_Credito_Type) return Boolean
   with
      Post => Esta_Al_Limite'Result = (Get_Saldo_Utilizado (T) >= Saldo_Type (Get_Limite_Credito (T)));


   function Esta_Vencida (T : Tarjeta_Credito_Type) return Boolean;

   -- Operaciones de modificación
   procedure Incrementar_Deuda (T : in out Tarjeta_Credito_Type; Monto : Saldo_Type)
   with
      Pre => Monto > 0.0 and then Get_Saldo_Utilizado (T) + Monto <= Saldo_Type (Get_Limite_Credito (T)),
      Post => Get_Saldo_Utilizado (T) = Get_Saldo_Utilizado (T)'Old + Monto;

   procedure Reducir_Deuda (T : in out Tarjeta_Credito_Type; Monto : Saldo_Type)
   with
      Pre => Monto > 0.0 and then Monto <= Get_Saldo_Utilizado (T),
      Post => Get_Saldo_Utilizado (T) = Get_Saldo_Utilizado (T)'Old - Monto;

   procedure Aplicar_Interes (T : in out Tarjeta_Credito_Type)
   with
      Pre => Get_Saldo_Utilizado (T) > 0.0;

   procedure Set_Limite_Credito (T : in out Tarjeta_Credito_Type; Nuevo_Limite : Limite_Credito_Type)
   with
      Pre => Nuevo_Limite >= Limite_Credito_Type (Get_Saldo_Utilizado (T));

private

   type Tarjeta_Credito_Type is tagged record
      Numero_Tarjeta        : Numero_Tarjeta_Str.Bounded_String;
      Limite_Credito        : Limite_Credito_Type := 0.0;
      Saldo_Utilizado       : Saldo_Type := 0.0;
      Fecha_Emision         : Ada.Calendar.Time;
      Fecha_Vencimiento     : Ada.Calendar.Time;
      Tasa_Interes_Mensual  : Tasa_Interes_Fija_Type;
   end record;

end Tarjeta_Credito;
