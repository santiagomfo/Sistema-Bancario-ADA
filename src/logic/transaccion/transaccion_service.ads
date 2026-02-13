with Cuentas; use Cuentas;
with Strategies; use Strategies;
with Movimientos; use Movimientos;
with Length;

package Transaccion_Service is

   procedure Ejecutar_Transaccion
     (Estrategia       : I_Transaccion_Strategy'Class;
      Tipo_Transaccion : Strategies.Tipo_Estrategia;
      C_Origen         : in out Cuenta_Type;
      C_Destino        : in out Cuenta_Type;
      Monto            : Saldo_Type;
      Descripcion      : String;
      Id_Movimiento    : out Id_Movimiento_Type)
     with Pre => (Monto > 0.0 and Monto <= Length.MAX_TRANSACCION) and
                 (Descripcion'Length <= Length.MAX_TEXTO_LARGO);

end Transaccion_Service;
