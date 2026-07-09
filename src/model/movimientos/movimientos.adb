package body Movimientos with SPARK_Mode => On is

   function Crear_Movimiento
     (Id            : Id_Movimiento_Type;
      Monto         : Dinero_Type;
      Descripcion   : String;
      Tipo_Transaccion : Transaccion.Estrategia_Transaccion;
      Cuenta_Origen : String;
      Cuenta_Destino : String)
      return Movimiento_Type
   with SPARK_Mode => Off
   is
      Desc_Bounded : constant Bounded_String := To_Bounded_String (Descripcion);
      Origen_Bounded : constant Numero_Cuenta_Str.Bounded_String := Numero_Cuenta_Str.To_Bounded_String (Cuenta_Origen);
      Destino_Bounded : constant Numero_Cuenta_Str.Bounded_String := Numero_Cuenta_Str.To_Bounded_String (Cuenta_Destino);
      Ahora        : constant Ada.Calendar.Time := Ada.Calendar.Clock;
   begin
      return (Id               => Id,
              Monto            => Monto,
              Fecha            => Ahora,
              Descripcion      => Desc_Bounded,
              Tipo_Transaccion => Tipo_Transaccion,
              Cuenta_Origen    => Origen_Bounded,
              Cuenta_Destino   => Destino_Bounded);
   end Crear_Movimiento;

   --  Get_Id, Get_Monto y Get_Tipo_Transaccion completados como expression
   --  functions en la parte privada del spec.

   function Get_Fecha (M : Movimiento_Type) return Ada.Calendar.Time
   with SPARK_Mode => Off is
   begin
      return M.Fecha;
   end Get_Fecha;

   function Get_Descripcion (M : Movimiento_Type) return String
   with SPARK_Mode => Off is
   begin
      return To_String (M.Descripcion);
   end Get_Descripcion;

   function Get_Origen (M : Movimiento_Type) return String
   with SPARK_Mode => Off is
   begin
      return Numero_Cuenta_Str.To_String (M.Cuenta_Origen);
   end Get_Origen;

   function Get_Destino (M : Movimiento_Type) return String
   with SPARK_Mode => Off is
   begin
      return Numero_Cuenta_Str.To_String (M.Cuenta_Destino);
   end Get_Destino;

end Movimientos;
