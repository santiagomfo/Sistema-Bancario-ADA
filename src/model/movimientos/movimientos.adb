package body Movimiento is

   function Crear_Movimiento
     (Id           : Id_Movimiento_Type;
      Monto        : Dinero_Type;
      Descripcion  : String;
      Tipo         : Tipo_Movimiento_Enum;
      Monto_Maximo : Dinero_Type;
      Origen       : Natural := 0;
      Destino      : Natural := 0)
      return Movimiento_Type
   is
      Desc_Bounded : constant Bounded_String := To_Bounded_String (Descripcion);
      Ahora        : constant Ada.Calendar.Time := Ada.Calendar.Clock;
   begin
      case Tipo is
         when Deposito | Interes =>
            return (Tipo             => Tipo,
                    Id               => Id,
                    Monto            => Monto,
                    Fecha            => Ahora,
                    Descripcion      => Desc_Bounded,
                    Monto_Maximo     => Monto_Maximo,
                    Cta_Destino_Solo => Destino);

         when Retiro =>
            return (Tipo            => Tipo,
                    Id              => Id,
                    Monto           => Monto,
                    Fecha           => Ahora,
                    Descripcion     => Desc_Bounded,
                    Monto_Maximo    => Monto_Maximo,
                    Cta_Origen_Solo => Origen);

         when Transferencia =>
            return (Tipo               => Tipo,
                    Id                 => Id,
                    Monto              => Monto,
                    Fecha              => Ahora,
                    Descripcion        => Desc_Bounded,
                    Monto_Maximo       => Monto_Maximo,
                    Cta_Origen_Transf  => Origen,
                    Cta_Destino_Transf => Destino);
      end case;
   end Crear_Movimiento;

   function Get_Id (M : Movimiento_Type) return Id_Movimiento_Type is
   begin
      return M.Id;
   end Get_Id;

   function Get_Monto (M : Movimiento_Type) return Dinero_Type is
   begin
      return M.Monto;
   end Get_Monto;

   function Get_Fecha (M : Movimiento_Type) return Ada.Calendar.Time is
   begin
      return M.Fecha;
   end Get_Fecha;

   function Get_Descripcion (M : Movimiento_Type) return String is
   begin
      return To_String (M.Descripcion);
   end Get_Descripcion;

   function Get_Origen (M : Movimiento_Type) return Natural is
   begin
      case M.Tipo is
         when Retiro =>
            return M.Cta_Origen_Solo;
         when Transferencia =>
            return M.Cta_Origen_Transf;
         when Deposito | Interes =>
            return 0;
      end case;
   end Get_Origen;

   function Get_Destino (M : Movimiento_Type) return Natural is
   begin
      case M.Tipo is
         when Deposito | Interes =>
            return M.Cta_Destino_Solo;
         when Transferencia =>
            return M.Cta_Destino_Transf;
         when Retiro =>
            return 0;
      end case;
   end Get_Destino;

end Movimiento;
