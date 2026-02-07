package Length is
   pragma Pure;

   MAX_ID : constant := 10;
   MAX_TEXTO_CORTO   : constant := 50;
   MAX_TEXTO_LARGO : constant := 150;
   MAX_TELEFONO    : constant := 15;
   MAX_NUMERO_CUENTA : constant := 10;
   MAX_DINERO      : constant := 10;

   MIN_SALDO         : constant := -2000.00;
   MAX_SALDO         : constant := 1_000_000.00;
   MAX_TASA_INTERES  : constant := 100.00;
   MAX_LIMITE_SOBREGIRO : constant := 2000.00;
   MAX_TRANSACCION : constant := 5000.00;

   -- Valores por defecto
   DEFAULT_LIMITE_SOBREGIRO : constant := 2000.00;
   DEFAULT_INTERES_SOBREGIRO : constant := 2.00;

end Length;
