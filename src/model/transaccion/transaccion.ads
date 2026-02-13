with Cuentas; use Cuentas;
with Length;

package Strategies is

   type I_Transaccion_Strategy is interface;

   type Tipo_Estrategia is (Deposito, Transferencia, Retiro);

   procedure Ejecutar (Self    : I_Transaccion_Strategy;
                       Origen  : in out Cuenta_Type;
                       Destino : in out Cuenta_Type;
                       Monto   : Saldo_Type) is abstract
     with
       Pre'Class => Monto > 0.0 and Monto <= Length.MAX_TRANSACCION;

   type Deposito_Strategy is new I_Transaccion_Strategy with null record;

   overriding
   procedure Ejecutar (Self    : Deposito_Strategy;
                       Origen  : in out Cuenta_Type;
                       Destino : in out Cuenta_Type;
                       Monto   : Saldo_Type);

   type Transferencia_Strategy is new I_Transaccion_Strategy with null record;

   overriding
   procedure Ejecutar (Self    : Transferencia_Strategy;
                       Origen  : in out Cuenta_Type;
                       Destino : in out Cuenta_Type;
                       Monto   : Saldo_Type);

   type Retiro_Strategy is new I_Transaccion_Strategy with null record;

   overriding
   procedure Ejecutar (Self    : Retiro_Strategy;
                       Origen  : in out Cuenta_Type;
                       Destino : in out Cuenta_Type;
                       Monto   : Saldo_Type);

end Strategies;
