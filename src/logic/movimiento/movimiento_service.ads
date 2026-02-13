
with Movimientos;
with Cuentas;
with Length;

package Movimiento_Service is
   use type Movimientos.Dinero_Type;

   -- TODO: Definir excepciones específicas (también en el diccionario)
   Transaccion_Invalida : exception;

   procedure Deposito
     (Id_Mov          : Movimientos.Id_Movimiento_Type;
      Cuenta_Destino : in out Cuentas.Cuenta_Type'Class;
      Monto           : Movimientos.Dinero_Type;
      Descripcion     : String;
      Resultado       : out Movimientos.Movimiento_Type)
   with
      Pre =>
         Monto > 0.0 and
         Descripcion'Length <= Length.MAX_TEXTO_LARGO;

   procedure Retiro
     (Id_Mov       : Movimientos.Id_Movimiento_Type;
      Cuenta_Origen : in out Cuentas.Cuenta_Type'Class;
      Monto        : Movimientos.Dinero_Type;
      Descripcion  : String;
      Resultado    : out Movimientos.Movimiento_Type)
   with
      Pre =>
         Monto > 0.0 and
         Descripcion'Length <= Length.MAX_TEXTO_LARGO;
         -- Nota: La validación de saldo suficiente se delega al paquete Cuentas

   procedure Transferencia
     (Id_Mov        : Movimientos.Id_Movimiento_Type;
      Cuenta_Origen  : in out Cuentas.Cuenta_Type'Class;
      Cuenta_Destino : in out Cuentas.Cuenta_Type'Class;
      Monto          : Movimientos.Dinero_Type;
      Descripcion    : String;
      Resultado      : out Movimientos.Movimiento_Type)
   with
      Pre =>
         Monto > 0.0 and
         Cuentas.Get_Id(Cuenta_Origen) /= Cuentas.Get_Id(Cuenta_Destino);

end Movimiento_Service;
