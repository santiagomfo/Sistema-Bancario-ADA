package Length is
   pragma Pure;

   MAX_ID : constant := 10;
   MAX_TEXTO_CORTO   : constant := 50;
   MAX_TEXTO_LARGO : constant := 150;
   MAX_TELEFONO    : constant := 15;
   MAX_NUMERO_CUENTA : constant := 10;
   MAX_NUMERO_TARJETA : constant := 10;
   MAX_DINERO      : constant := 10;

   MIN_SALDO         : constant := -2000.00;
   MAX_LIMITE_SOBREGIRO : constant := 2000.00;
   MAX_LIMITE_CREDITO : constant := 8000.00;
   MAX_TRANSACCION : constant := 5000.00;

   -- Valores por defecto
   DEFAULT_INTERES_SOBREGIRO : constant := 22.00;
   DEFAULT_TASA_INTERES_AHORROS : constant := 3.00;
   DEFAULT_TASA_INTERES_TARJETA : constant := 3.50;
   MIN_PAGO_MENSUAL_PORCENTAJE : constant := 5.0;
   DEFAULT_VIGENCIA_TARJETA : constant := 3.0;

end Length;
