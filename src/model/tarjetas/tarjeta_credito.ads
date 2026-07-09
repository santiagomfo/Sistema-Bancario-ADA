with Ada.Calendar;
with Ada.Strings.Bounded;
with Length;

package Tarjeta_Credito with SPARK_Mode => On is
   pragma Elaborate_Body;  --  Requerido por SPARK (early call region, E0003)

   -- Tipos de datos
   type Saldo_Type is delta 0.01 digits 18;
   --  La deuda utilizada nunca es negativa: subtipo del campo para que el
   --  prover conozca la cota inferior en cada lectura (invariante de dominio
   --  sin Type_Invariant, que SPARK no admite en tipos tagged).
   subtype Deuda_Type is Saldo_Type range 0.0 .. Saldo_Type'Last;
   type Tasa_Interes_Type is new Float;
   subtype Tasa_Interes_Fija_Type is Tasa_Interes_Type
      with Static_Predicate =>
         Tasa_Interes_Fija_Type = Tasa_Interes_Type (Length.DEFAULT_TASA_INTERES_TARJETA);
   --  Subtipo de Saldo_Type (no un tipo fixed-point distinto) para que SPARK
   --  no rechace las conversiones entre limite y saldo (no soporta conversion
   --  entre tipos fixed-point incompatibles).
   subtype Limite_Credito_Type is Saldo_Type range 0.0 .. Length.MAX_LIMITE_CREDITO;

   package Numero_Tarjeta_Str is new Ada.Strings.Bounded.Generic_Bounded_Length
     (Max => Length.MAX_NUMERO_TARJETA);

   -- Tipo tagged independiente (NO hereda de Cuenta_Type)
   type Tarjeta_Credito_Type is tagged private;
   type Tarjeta_Credito_Access is access all Tarjeta_Credito_Type'Class;

   -- Constructor: usa Ada.Calendar.Clock y contador global -> fuera de SPARK.
   function Crear_Tarjeta_Credito
      return Tarjeta_Credito_Type
   with SPARK_Mode => Off;

   -- Getters
   --  Getter de string (Bounded_String) -> fuera de SPARK.
   function Get_Numero_Tarjeta (T : Tarjeta_Credito_Type) return String
   with SPARK_Mode => Off;
   function Get_Limite_Credito (T : Tarjeta_Credito_Type) return Limite_Credito_Type;
   function Get_Saldo_Utilizado (T : Tarjeta_Credito_Type) return Saldo_Type;
   --  Getters de fecha (Ada.Calendar.Time) -> fuera de SPARK.
   function Get_Fecha_Emision (T : Tarjeta_Credito_Type) return Ada.Calendar.Time
   with SPARK_Mode => Off;
   function Get_Fecha_Vencimiento (T : Tarjeta_Credito_Type) return Ada.Calendar.Time
   with SPARK_Mode => Off;
   function Get_Tasa_Interes_Anual (T : Tarjeta_Credito_Type) return Tasa_Interes_Type;

   -- Operaciones de consulta
   function Get_Credito_Disponible (T : Tarjeta_Credito_Type) return Saldo_Type
   with
      Post'Class => Get_Credito_Disponible'Result =
              Saldo_Type (Get_Limite_Credito (T)) - Get_Saldo_Utilizado (T);

   function Esta_Al_Limite (T : Tarjeta_Credito_Type) return Boolean
   with
      Post'Class => Esta_Al_Limite'Result = (Get_Saldo_Utilizado (T) >= Saldo_Type (Get_Limite_Credito (T)));

   --  Usa Ada.Calendar.Clock -> fuera de SPARK.
   function Esta_Vencida (T : Tarjeta_Credito_Type) return Boolean
   with SPARK_Mode => Off;

   -- Operaciones de modificación
   procedure Incrementar_Deuda (T : in out Tarjeta_Credito_Type; Monto : Saldo_Type)
   with
      Pre'Class  => Monto > 0.0 and then Get_Saldo_Utilizado (T) + Monto <= Saldo_Type (Get_Limite_Credito (T)),
      Post'Class => Get_Saldo_Utilizado (T) = Get_Saldo_Utilizado (T)'Old + Monto;

   procedure Reducir_Deuda (T : in out Tarjeta_Credito_Type; Monto : Saldo_Type)
   with
      Pre'Class  => Monto > 0.0 and then Monto <= Get_Saldo_Utilizado (T),
      Post'Class => Get_Saldo_Utilizado (T) = Get_Saldo_Utilizado (T)'Old - Monto;

   --  Interes mensual = deuda * tasa_anual / 1200 (22% anual prorrateado).
   --  Usa aritmetica Float intermedia: no se prueba el valor EXACTO, sino la
   --  COTA verificable de que la deuda no disminuye. La Pre acota la deuda al
   --  limite de credito para garantizar ausencia de overflow.
   procedure Aplicar_Interes (T : in out Tarjeta_Credito_Type)
   with
      Pre'Class  => Get_Saldo_Utilizado (T) > 0.0
                    and then Get_Saldo_Utilizado (T) <= Saldo_Type (Get_Limite_Credito (T)),
      Post'Class => Get_Saldo_Utilizado (T) >= Get_Saldo_Utilizado (T)'Old;

   procedure Set_Limite_Credito (T : in out Tarjeta_Credito_Type; Nuevo_Limite : Limite_Credito_Type)
   with
      Pre'Class  => Saldo_Type (Nuevo_Limite) >= Get_Saldo_Utilizado (T),
      Post'Class => Get_Limite_Credito (T) = Nuevo_Limite;

private

   type Tarjeta_Credito_Type is tagged record
      Numero_Tarjeta        : Numero_Tarjeta_Str.Bounded_String;
      Limite_Credito        : Limite_Credito_Type := 0.0;
      Saldo_Utilizado       : Deuda_Type := 0.0;
      Fecha_Emision         : Ada.Calendar.Time;
      Fecha_Vencimiento     : Ada.Calendar.Time;
      Tasa_Interes_Anual    : Tasa_Interes_Fija_Type;
   end record;

   --  Getters numericos como expression functions: hacen visible el valor al
   --  prover para cerrar postcondiciones y range checks.
   function Get_Limite_Credito (T : Tarjeta_Credito_Type) return Limite_Credito_Type
   is (T.Limite_Credito);
   function Get_Saldo_Utilizado (T : Tarjeta_Credito_Type) return Saldo_Type
   is (T.Saldo_Utilizado);
   function Get_Tasa_Interes_Anual (T : Tarjeta_Credito_Type) return Tasa_Interes_Type
   is (T.Tasa_Interes_Anual);

end Tarjeta_Credito;
