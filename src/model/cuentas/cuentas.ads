with Ada.Calendar;
with Ada.Strings.Bounded;
with Length;

package Cuentas with SPARK_Mode => On is

   -- Paquete Bounded para Numero_Cuenta
   package Numero_Cuenta_Str is new Ada.Strings.Bounded.Generic_Bounded_Length
     (Max => Length.MAX_NUMERO_CUENTA);

   subtype Numero_Cuenta_Type is Numero_Cuenta_Str.Bounded_String;

   type Saldo_Type is delta 0.01 digits 18;
   type Estado_Type is (Activa, Bloqueada);

   type Cuenta_Type is tagged private;
   type Cuenta_Access is access all Cuenta_Type'Class;

   --  Constructor: usa Ada.Calendar.Clock (volatil) y un contador global
   --  mutable -> fuera del subconjunto SPARK. Frontera de corte documentada.
   function Crear_Cuenta
     (Saldo         : Saldo_Type;
      Estado        : Estado_Type)
      return Cuenta_Type
   with SPARK_Mode => Off;

   --  Getter de string: manipula Bounded_String -> fuera de SPARK.
   function Get_Numero_Cuenta (C : Cuenta_Type) return String
   with SPARK_Mode => Off;

   function Get_Saldo (C : Cuenta_Type) return Saldo_Type;

   --  Getter de fecha (Ada.Calendar.Time) -> fuera de SPARK.
   function Get_Fecha_Apertura (C : Cuenta_Type) return Ada.Calendar.Time
   with SPARK_Mode => Off;

   function Get_Estado (C : Cuenta_Type) return Estado_Type;

   --  Contrato despachante LSP-safe: el piso universal es MIN_SALDO (-2000).
   --  Las cotas mas estrictas por subclase (ahorros >= 0, corriente >= -limite)
   --  NO pueden fortalecerse aqui por despacho (violaria LSP); se demuestran en
   --  la frontera de construccion via subtipos con predicado.
   procedure Set_Saldo (C : in out Cuenta_Type; Saldo : Saldo_Type)
     with Pre'Class  => Saldo >= Length.MIN_SALDO,
          Post'Class => Get_Saldo (C) = Saldo;
   procedure Set_Estado (C : in out Cuenta_Type; Estado : Estado_Type)
     with Post'Class => Get_Estado (C) = Estado;

   procedure Acreditar (C : in out Cuenta_Type; Monto : Saldo_Type)
     with Pre'Class  => Monto >= 0.0 and Get_Saldo (C) <= Saldo_Type'Last - Monto,
          Post'Class => Get_Saldo (C) = Get_Saldo (C)'Old + Monto;

   procedure Debitar (C : in out Cuenta_Type; Monto : Saldo_Type)
     with Pre'Class  => Monto >= 0.0 and Get_Saldo (C) >= Monto
                        and Get_Saldo (C) - Monto >= Length.MIN_SALDO,
          Post'Class => Get_Saldo (C) = Get_Saldo (C)'Old - Monto;

private

   type Cuenta_Type is tagged record
      Numero_Cuenta  : Numero_Cuenta_Str.Bounded_String;
      Saldo          : Saldo_Type;
      Fecha_Apertura : Ada.Calendar.Time;
      Estado         : Estado_Type;
   end record;

   --  Getters como expression functions: hacen visible el valor al prover
   --  para poder cerrar las postcondiciones y range checks de Acreditar/Debitar.
   function Get_Saldo (C : Cuenta_Type) return Saldo_Type is (C.Saldo);
   function Get_Estado (C : Cuenta_Type) return Estado_Type is (C.Estado);

end Cuentas;
