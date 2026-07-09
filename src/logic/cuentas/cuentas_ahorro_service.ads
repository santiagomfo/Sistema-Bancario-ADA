with Cuenta_Ahorros;
with Cuentas;

--  FRONTERA SPARK: capa de servicios con access/despacho dinamico. Fuera de SPARK.
package Cuentas_Ahorro_Service with SPARK_Mode => Off is

   procedure Aplicar_Interes (Cuenta : in out Cuenta_Ahorros.Cuenta_Ahorros_Type);

end Cuentas_Ahorro_Service;
