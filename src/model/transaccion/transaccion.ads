with Cuentas; use Cuentas;
with Length;

package Transaccion is

   type I_Transaccion_Strategy is interface;

   type Tipo_Estrategia is (Deposito, Transferencia, Retiro);

   function Get_Tipo (Self : I_Transaccion_Strategy) return Tipo_Estrategia is abstract;

   procedure Ejecutar (Self    : I_Transaccion_Strategy;
                       Origen  : in out Cuenta_Type'Class;
                       Destino : in out Cuenta_Type'Class;
                       Monto   : Saldo_Type) is abstract
     with
       Pre'Class => Monto > 0.0 and Monto <= Length.MAX_TRANSACCION;

   type Deposito_Strategy is new I_Transaccion_Strategy with null record;

   overriding
   function Get_Tipo (Self : Deposito_Strategy) return Tipo_Estrategia;

   overriding
   procedure Ejecutar (Self    : Deposito_Strategy;
                       Origen  : in out Cuenta_Type'Class;
                       Destino : in out Cuenta_Type'Class;
                       Monto   : Saldo_Type);

   type Transferencia_Strategy is new I_Transaccion_Strategy with null record;

   overriding
   function Get_Tipo (Self : Transferencia_Strategy) return Tipo_Estrategia;

   overriding
   procedure Ejecutar (Self    : Transferencia_Strategy;
                       Origen  : in out Cuenta_Type'Class;
                       Destino : in out Cuenta_Type'Class;
                       Monto   : Saldo_Type);

   type Retiro_Strategy is new I_Transaccion_Strategy with null record;

   overriding
   function Get_Tipo (Self : Retiro_Strategy) return Tipo_Estrategia;

   overriding
   procedure Ejecutar (Self    : Retiro_Strategy;
                       Origen  : in out Cuenta_Type'Class;
                       Destino : in out Cuenta_Type'Class;
                       Monto   : Saldo_Type);

end Transaccion;
