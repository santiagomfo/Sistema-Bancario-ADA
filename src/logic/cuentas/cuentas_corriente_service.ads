with Cuenta_Corriente;
with Cuentas;

--  FRONTERA SPARK: capa de servicios con access/despacho dinamico. Fuera de SPARK.
package Cuentas_Corriente_Service with SPARK_Mode => Off is

   procedure Aplicar_Interes (Cuenta : in out Cuenta_Corriente.Cuenta_Corriente_Type);

end Cuentas_Corriente_Service;
