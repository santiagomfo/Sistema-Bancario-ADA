package body Transaccion_Service is

   Ultimo_Id_Movimiento : Id_Movimiento_Type := 1;

   procedure Ejecutar_Transaccion
     (Estrategia       : I_Transaccion_Strategy'Class;
      Tipo_Transaccion : Strategies.Tipo_Estrategia;
      C_Origen         : in out Cuenta_Type;
      C_Destino        : in out Cuenta_Type;
      Monto            : Saldo_Type;
      Descripcion      : String;
      Id_Movimiento    : out Id_Movimiento_Type)
   is
      Movimiento : Movimiento_Type;
   begin
      Estrategia.Ejecutar(C_Origen, C_Destino, Monto);

      Movimiento := Crear_Movimiento
        (Id               => Ultimo_Id_Movimiento,
         Monto            => Monto,
         Descripcion      => Descripcion,
         Tipo_Transaccion => Tipo_Transaccion,
         Cuenta_Origen    => Get_Id(C_Origen),
         Cuenta_Destino   => Get_Id(C_Destino));

      Id_Movimiento := Ultimo_Id_Movimiento;
      Ultimo_Id_Movimiento := Ultimo_Id_Movimiento + 1;
   end Ejecutar_Transaccion;

end Transaccion_Service;
