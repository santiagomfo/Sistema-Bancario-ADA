with Ada.Calendar;
with Ada.Strings.Bounded;
with Length;
with Cuentas; use Cuentas;
with Transaccion;

package Movimientos with SPARK_Mode => On is
   pragma Elaborate_Body;  --  Requerido por SPARK (early call region, E0003)

   MAX_DESCRIPCION : constant := Length.MAX_TEXTO_LARGO;

   subtype Id_Movimiento_Type is Natural range 1 .. Natural'Last;
   subtype Dinero_Type is Cuentas.Saldo_Type;

   --  Invariante de dominio del monto: (0, MAX_MONTO_TRANSACCION]. Como
   --  Dinero_Type tiene delta 0.01, el minimo positivo representable es 0.01,
   --  por lo que el rango [0.01, MAX] equivale a (0, MAX]. Se expresa como
   --  subtipo del campo (SPARK lo prueba estructuralmente). Nota: SPARK RM
   --  7.3.2 restringe Type_Invariant (prohibe llamar getters "boundary" y exige
   --  probar el valor por defecto), por lo que el subtipo es el mecanismo
   --  practico y verificable para esta garantia.
   subtype Monto_Valido_Type is Dinero_Type
     range 0.01 .. Dinero_Type (Length.MAX_MONTO_TRANSACCION);

   package Numero_Cuenta_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => Length.MAX_ID);
   subtype Numero_Cuenta_Type is Numero_Cuenta_Str.Bounded_String;

   package Descripcion_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => Length.MAX_TEXTO_LARGO);
   use Descripcion_Str;

   type Movimiento_Type is private;

   --  Constructor: usa Ada.Calendar.Clock y Bounded_String -> fuera de SPARK.
   function Crear_Movimiento
     (Id           : Id_Movimiento_Type;
      Monto        : Dinero_Type;
      Descripcion  : String;
      Tipo_Transaccion : Transaccion.Estrategia_Transaccion;
      Cuenta_Origen : String;
      Cuenta_Destino : String)
      return Movimiento_Type
   with
      SPARK_Mode => Off,
      Pre =>
        (Monto > 0.0 and Monto <= Length.MAX_MONTO_TRANSACCION) and
        (Descripcion'Length <= Length.MAX_TEXTO_LARGO) and
        (Cuenta_Origen'Length > 0 and Cuenta_Origen'Length <= Length.MAX_ID) and
        (Cuenta_Destino'Length > 0 and Cuenta_Destino'Length <= Length.MAX_ID);

   function Get_Id (M : Movimiento_Type) return Id_Movimiento_Type;
   function Get_Monto (M : Movimiento_Type) return Dinero_Type;
   --  Getter de fecha (Ada.Calendar.Time) -> fuera de SPARK.
   function Get_Fecha (M : Movimiento_Type) return Ada.Calendar.Time
   with SPARK_Mode => Off;
   --  Getters de string (Bounded_String) -> fuera de SPARK.
   function Get_Descripcion (M : Movimiento_Type) return String
   with SPARK_Mode => Off;

   function Get_Origen (M : Movimiento_Type) return String
   with SPARK_Mode => Off;
   function Get_Destino (M : Movimiento_Type) return String
   with SPARK_Mode => Off;
   function Get_Tipo_Transaccion (M : Movimiento_Type) return Transaccion.Estrategia_Transaccion;

private

   type Movimiento_Type is record
      Id           : Id_Movimiento_Type;
      Monto        : Monto_Valido_Type;
      Fecha        : Ada.Calendar.Time;
      Descripcion  : Bounded_String;
      Tipo_Transaccion : Transaccion.Estrategia_Transaccion;
      Cuenta_Origen  : Numero_Cuenta_Type;
      Cuenta_Destino : Numero_Cuenta_Type;
   end record;

   --  Getters numericos/enum como expression functions: hacen visible el valor
   --  al prover. Get_Monto devuelve un valor del subtipo Monto_Valido_Type.
   function Get_Id (M : Movimiento_Type) return Id_Movimiento_Type is (M.Id);
   function Get_Monto (M : Movimiento_Type) return Dinero_Type is (M.Monto);
   function Get_Tipo_Transaccion (M : Movimiento_Type) return Transaccion.Estrategia_Transaccion
   is (M.Tipo_Transaccion);

end Movimientos;
