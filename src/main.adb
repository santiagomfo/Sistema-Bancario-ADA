with Ada.Text_IO; use Ada.Text_IO;
with Clientes;
with Clientes_Service;
with Cliente_Resultado;
with Cuentas;
with Cuenta_Ahorros;
with Cuenta_Corriente;
with Cuentas_Service;
with Cuentas_Ahorro_Service;
with Cuentas_Corriente_Service;
with Transaccion_Service;
with Transaccion;
with Transaccion_Tarjeta;
with Movimientos;
with Tarjeta_Credito; use Tarjeta_Credito;
with Tarjeta_Credito_Service;
with Tarjeta_Resultado;
with Resultado_Operacion; use Resultado_Operacion;

procedure Main is
   Cliente_1, Cliente_2, Cliente_3, Cliente_4  : Clientes.Cliente_Type;
   Cuenta_1, Cuenta_2, Cuenta_3, Cuenta_4      : Cuentas.Cuenta_Access;
   Tarjeta_1, Tarjeta_2                        : Tarjeta_Credito.Tarjeta_Credito_Access;

   -- Variables para resultados
   Status_Cliente : Cliente_Resultado.Cliente_Resultado_Type;
   Status_Tarjeta : Tarjeta_Resultado.Tarjeta_Resultado_Type;

   -- Variables para IDs de movimientos
   Id_Mov : Movimientos.Id_Movimiento_Type;

   -- Estrategias para transacciones
   Estrategia_Deposito      : Transaccion.Deposito_Strategy;
   Estrategia_Retiro        : Transaccion.Retiro_Strategy;
   Estrategia_Transferencia : Transaccion.Transferencia_Strategy;

   -- Variable para capturar resultado de transacciones
   Resultado : Boolean;

   procedure Imprimir_Separador is
   begin
      Put_Line ("");
      Put_Line ("========================================");
   end Imprimir_Separador;

   procedure Imprimir_Seccion (Titulo : String) is
   begin
      Imprimir_Separador;
      Put_Line ("=== " & Titulo & " ===");
      Imprimir_Separador;
   end Imprimir_Seccion;

   procedure Imprimir_Subseccion (Titulo : String) is
   begin
      Put_Line ("");
      Put_Line ("--- " & Titulo & " ---");
   end Imprimir_Subseccion;

begin
   Put_Line ("============================================================");
   Put_Line ("     SISTEMA BANCARIO - PRUEBAS COMPLETAS      ");
   Put_Line ("============================================================");
   Put_Line ("");

   Imprimir_Seccion ("1. CREACION DE CLIENTES Y CUENTAS");

   -------------------------------------------------------
   -- 1.1. Crear Cliente 1 con Cuenta de Ahorros
   -------------------------------------------------------
   Imprimir_Subseccion ("Creando Cliente 1 con Cuenta de Ahorros");
   Clientes_Service.Crear_Cliente
     (Status        => Status_Cliente,
      Resultado     => Cliente_1,
      Cuenta_Nueva  => Cuenta_1,
      Cedula        => "0102030405",
      Nombre        => "Juan",
      Apellido      => "Perez",
      Direccion     => "Calle Principal 123",
      Correo        => "juan.perez@mail.com",
      Telefono      => "0999999999",
      Tipo_Cuenta   => Clientes_Service.Ahorros,
      Saldo_Inicial => 1000.00);

   if Status_Cliente.Estado = Resultado_Operacion.Exito then
      Put_Line ("[OK] Cliente creado exitosamente");
      Put_Line ("  Nombre:   " & Clientes.Get_Nombre (Cliente_1) & " " &
                Clientes.Get_Apellido (Cliente_1));
      Put_Line ("  Cedula:   " & Clientes.Get_Cedula (Cliente_1));
      Put_Line ("  Cuenta:   " & Clientes.Get_Numero_Cuenta (Cliente_1));
      Put_Line ("  Tipo:     Ahorros");
      Put_Line ("  Saldo:    " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   else
      Put_Line ("[X] Error: " & Status_Cliente.Mensaje);
      return;
   end if;

   -------------------------------------------------------
   -- 1.2. Crear Cliente 2 con Cuenta Corriente
   -------------------------------------------------------
   Imprimir_Subseccion ("Creando Cliente 2 con Cuenta Corriente");
   Clientes_Service.Crear_Cliente
     (Status        => Status_Cliente,
      Resultado     => Cliente_2,
      Cuenta_Nueva  => Cuenta_2,
      Cedula        => "0203040506",
      Nombre        => "Maria",
      Apellido      => "Lopez",
      Direccion     => "Avenida Central 456",
      Correo        => "maria.lopez@mail.com",
      Telefono      => "0988888888",
      Tipo_Cuenta   => Clientes_Service.Corriente,
      Saldo_Inicial => 500.00);

   if Status_Cliente.Estado = Resultado_Operacion.Exito then
      Put_Line ("[OK] Cliente creado exitosamente");
      Put_Line ("  Nombre:   " & Clientes.Get_Nombre (Cliente_2) & " " &
                Clientes.Get_Apellido (Cliente_2));
      Put_Line ("  Cedula:   " & Clientes.Get_Cedula (Cliente_2));
      Put_Line ("  Cuenta:   " & Clientes.Get_Numero_Cuenta (Cliente_2));
      Put_Line ("  Tipo:     Corriente");
      Put_Line ("  Saldo:    " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)));
   else
      Put_Line ("[X] Error: " & Status_Cliente.Mensaje);
      return;
   end if;

   -------------------------------------------------------
   -- 1.3. Crear Cliente 3 con Cuenta y Tarjeta de Crédito
   -------------------------------------------------------
   Imprimir_Subseccion ("Creando Cliente 3 con Cuenta y Tarjeta de Credito");
   Clientes_Service.Crear_Cliente_Con_Tarjeta
     (Status            => Status_Cliente,
      Resultado         => Cliente_3,
      Cuenta_Nueva      => Cuenta_3,
      Tarjeta_Nueva     => Tarjeta_1,
      Cedula            => "0304050607",
      Nombre            => "Carlos",
      Apellido          => "Gomez",
      Direccion         => "Boulevard Norte 789",
      Correo            => "carlos.gomez@mail.com",
      Telefono          => "0977777777",
      Tipo_Cuenta       => Clientes_Service.Ahorros,
      Saldo_Inicial     => 2000.00);

   if Status_Cliente.Estado = Resultado_Operacion.Exito then
      Put_Line ("[OK] Cliente creado exitosamente con tarjeta");
      Put_Line ("  Nombre:        " & Clientes.Get_Nombre (Cliente_3) & " " &
                Clientes.Get_Apellido (Cliente_3));
      Put_Line ("  Cedula:        " & Clientes.Get_Cedula (Cliente_3));
      Put_Line ("  Cuenta:        " & Clientes.Get_Numero_Cuenta (Cliente_3));
      Put_Line ("  Saldo Cuenta:  " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_3.all)));
      Put_Line ("  Tarjeta:       " & Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all));
      Put_Line ("  Limite:        " & Tarjeta_Credito.Limite_Credito_Type'Image
                (Tarjeta_Credito.Get_Limite_Credito (Tarjeta_1.all)));
   else
      Put_Line ("[X] Error: " & Status_Cliente.Mensaje);
      return;
   end if;

   -------------------------------------------------------
   -- 2. TRANSACCIONES BASICAS
   -------------------------------------------------------
   Imprimir_Seccion ("2. TRANSACCIONES BASICAS EN CUENTAS");
   -------------------------------------------------------
   -- 2. TRANSACCIONES BASICAS
   -------------------------------------------------------
   Imprimir_Seccion ("2. TRANSACCIONES BASICAS EN CUENTAS");

   -- 2.1. Depósito en Cuenta 1
   Imprimir_Subseccion ("Deposito en Cuenta de Ahorros (+100.00)");
   Put_Line ("  Saldo Anterior: " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Deposito,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_1.all,
      Monto         => 100.00,
      Descripcion   => "Deposito inicial",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("[OK] Deposito exitoso");
      Put_Line ("  Saldo Nuevo:    " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
      Put_Line ("  ID Movimiento:  " & Movimientos.Id_Movimiento_Type'Image (Id_Mov));
   else
      Put_Line ("[X] Error: Operacion no permitida");
   end if;

   -- 2.2. Retiro en Cuenta 1
   Imprimir_Subseccion ("Retiro en Cuenta de Ahorros (-50.00)");
   Put_Line ("  Saldo Anterior: " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Retiro,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_1.all,
      Monto         => 50.00,
      Descripcion   => "Retiro para gastos",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("[OK] Retiro exitoso");
      Put_Line ("  Saldo Nuevo:    " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   else
      Put_Line ("[X] Error: Operacion no permitida");
   end if;

   -- 2.3. Transferencia de Cuenta 1 a Cuenta 2
   Imprimir_Subseccion ("Transferencia entre Cuentas (200.00)");
   Put_Line ("  Origen  (Cuenta 1): " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   Put_Line ("  Destino (Cuenta 2): " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)));
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Transferencia,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_2.all,
      Monto         => 200.00,
      Descripcion   => "Pago de deuda",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("[OK] Transferencia exitosa");
      Put_Line ("  Origen  (Cuenta 1): " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
      Put_Line ("  Destino (Cuenta 2): " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)));
   else
      Put_Line ("[X] Error: Operacion no permitida");
   end if;

   -------------------------------------------------------
   -- 6. PRUEBAS DEL PATRON STATE
   -------------------------------------------------------
   Imprimir_Seccion ("3. PATRON STATE - ESTADOS DE CUENTA");

   -- 3.1. Bloquear Cuenta 1
   Imprimir_Subseccion ("Bloqueando Cuenta 1 (Ahorros)");
   Cuentas_Service.Bloquear_Cuenta (Cuenta_1.all);
   Put_Line ("[OK] Cuenta bloqueada");
   Put_Line ("  Estado: " &
             (if Cuentas_Service.Esta_Bloqueada (Cuenta_1.all) then "BLOQUEADA" else "ACTIVA"));

   -- 3.2. Intentar Retiro en Cuenta Bloqueada (debe fallar)
   Imprimir_Subseccion ("Intentando Retiro en Cuenta BLOQUEADA (debe fallar)");
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Retiro,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_1.all,
      Monto         => 10.00,
      Descripcion   => "Intento de retiro",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("[X] ERROR: No deberia permitir retiro en cuenta bloqueada!");
   else
      Put_Line ("[OK] OK: Retiro rechazado correctamente");
      Put_Line ("  Razon: Cuenta bloqueada");
   end if;
   Put_Line ("  Saldo sin cambios: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));

   -- 3.3. Depósito en Cuenta Bloqueada (debe funcionar)
   Imprimir_Subseccion ("Deposito en Cuenta BLOQUEADA (debe funcionar)");
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Deposito,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_1.all,
      Monto         => 75.00,
      Descripcion   => "Deposito en cuenta bloqueada",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("[OK] OK: Deposito aceptado correctamente");
      Put_Line ("  Nuevo Saldo: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   else
      Put_Line ("[X] ERROR: Deberia permitir deposito en cuenta bloqueada!");
   end if;

   -- 3.4. Desbloquear Cuenta 1
   Imprimir_Subseccion ("Desbloqueando Cuenta 1 (Ahorros)");
   Cuentas_Service.Activar_Cuenta (Cuenta_1.all);
   Put_Line ("[OK] Cuenta activada");
   Put_Line ("  Estado: " &
             (if Cuentas_Service.Esta_Activa (Cuenta_1.all) then "ACTIVA" else "BLOQUEADA"));

   -- 3.5. Retiro en Cuenta Activa (debe funcionar)
   Imprimir_Subseccion ("Retiro en Cuenta ACTIVA (debe funcionar)");
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Retiro,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_1.all,
      Monto         => 25.00,
      Descripcion   => "Retiro exitoso",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("[OK] OK: Retiro aceptado correctamente");
      Put_Line ("  Nuevo Saldo: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   else
      Put_Line ("[X] ERROR: Deberia permitir retiro en cuenta activa!");
   end if;
-------------------------------------------------------
   -- 7. PRUEBAS DE TARJETA DE CREDITO
   -------------------------------------------------------
   Imprimir_Seccion ("4. OPERACIONES CON TARJETA DE CREDITO");

   -- 4.1. Consultar Estado de Tarjeta
   Imprimir_Subseccion ("Estado Inicial de Tarjeta");
   Put_Line (Tarjeta_Credito_Service.Consultar_Estado_Tarjeta
             (Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all)));

   -- 4.2. Realizar Compra Exitosa
   Imprimir_Subseccion ("Realizando Compra: Laptop $1,200.00");
   declare
      Estrategia : constant Transaccion_Tarjeta.Compra_Strategy :=
        Transaccion_Tarjeta.Compra_Strategy'(null record);
   begin
      Status_Tarjeta := Tarjeta_Credito_Service.Ejecutar_Operacion
        (Estrategia     => Estrategia,
         Numero_Tarjeta => Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all),
         Monto          => 1200.00,
         Descripcion    => "Compra de Laptop");

      if Status_Tarjeta.Estado = Resultado_Operacion.Exito then
         Put_Line ("[OK] Compra exitosa!");
         Put_Line ("  Descripcion:        Compra de Laptop");
         Put_Line ("  Monto:              $1,200.00");
         Put_Line ("  Saldo Utilizado:    " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));
         Put_Line ("  Credito Disponible: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Credito_Disponible (Tarjeta_1.all)));
      else
         Put_Line ("[X] Compra rechazada: " & Status_Tarjeta.Mensaje);
      end if;
   end;

   -- 4.3. Realizar Otra Compra
   Imprimir_Subseccion ("Realizando Compra: Celular $800.00");
   declare
      Estrategia : constant Transaccion_Tarjeta.Compra_Strategy :=
        Transaccion_Tarjeta.Compra_Strategy'(null record);
   begin
      Status_Tarjeta := Tarjeta_Credito_Service.Ejecutar_Operacion
        (Estrategia     => Estrategia,
         Numero_Tarjeta => Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all),
         Monto          => 800.00,
         Descripcion    => "Compra de Celular");

      if Status_Tarjeta.Estado = Resultado_Operacion.Exito then
         Put_Line ("[OK] Compra exitosa!");
         Put_Line ("  Descripcion:        Compra de Celular");
         Put_Line ("  Monto:              $800.00");
         Put_Line ("  Saldo Utilizado:    " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));
         Put_Line ("  Credito Disponible: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Credito_Disponible (Tarjeta_1.all)));
      else
         Put_Line ("[X] Compra rechazada: " & Status_Tarjeta.Mensaje);
      end if;
   end;

   -- 4.4. Intentar Compra que Excede el Límite
   Imprimir_Subseccion ("Intentando Compra que Excede Limite: $4,000.00 (debe fallar)");
   declare
      Estrategia : constant Transaccion_Tarjeta.Compra_Strategy :=
        Transaccion_Tarjeta.Compra_Strategy'(null record);
   begin
      Status_Tarjeta := Tarjeta_Credito_Service.Ejecutar_Operacion
        (Estrategia     => Estrategia,
         Numero_Tarjeta => Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all),
         Monto          => 4000.00,
         Descripcion    => "Compra grande");

      if Status_Tarjeta.Estado = Resultado_Operacion.Exito then
         Put_Line ("[X] ERROR: No deberia permitir compra que excede limite!");
      else
         Put_Line ("[OK] OK: Compra rechazada - " & Status_Tarjeta.Mensaje);
      end if;
   end;

   -- 4.5. Realizar Pago Parcial
   Imprimir_Subseccion ("Realizando Pago de $500.00");
   declare
      Estrategia : constant Transaccion_Tarjeta.Pago_Tarjeta_Strategy :=
        Transaccion_Tarjeta.Pago_Tarjeta_Strategy'(null record);
   begin
      Status_Tarjeta := Tarjeta_Credito_Service.Ejecutar_Operacion
        (Estrategia     => Estrategia,
         Numero_Tarjeta => Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all),
         Monto          => 500.00);

      if Status_Tarjeta.Estado = Resultado_Operacion.Exito then
         Put_Line ("[OK] Pago exitoso!");
         Put_Line ("  Monto:              $500.00");
         Put_Line ("  Saldo Utilizado:    " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));
         Put_Line ("  Credito Disponible: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Credito_Disponible (Tarjeta_1.all)));
      else
         Put_Line ("[X] Pago rechazado: " & Status_Tarjeta.Mensaje);
      end if;
   end;

   -- 4.6. Calcular y Aplicar Intereses
   Imprimir_Subseccion ("Aplicando Intereses Mensuales (3.50%)");
   Tarjeta_Credito_Service.Aplicar_Interes
     (Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all));

   Put_Line ("[OK] Intereses aplicados");
   Put_Line ("  Saldo Utilizado: " &
             Tarjeta_Credito.Saldo_Type'Image
               (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));
   Put_Line ("  Pago Minimo:     " &
             Tarjeta_Credito.Saldo_Type'Image
               (Tarjeta_Credito.Get_Pago_Minimo (Tarjeta_1.all)));

   -- 4.7. Consultar Estado Final
   Imprimir_Subseccion ("Estado Final de Tarjeta");
   Put_Line (Tarjeta_Credito_Service.Consultar_Estado_Tarjeta
             (Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all)));

   -------------------------------------------------------
   -- 8. PRUEBAS DE OPERACIONES UPDATE EN CLIENTES
   -------------------------------------------------------
   Imprimir_Seccion ("5. ACTUALIZACION DE DATOS DE CLIENTES");

   -- 5.1. Mostrar datos originales del Cliente 1
   Imprimir_Subseccion ("Datos Originales del Cliente 1");
   Put_Line ("  Cedula:    " & Clientes.Get_Cedula (Cliente_1));
   Put_Line ("  Nombre:    " & Clientes.Get_Nombre (Cliente_1));
   Put_Line ("  Apellido:  " & Clientes.Get_Apellido (Cliente_1));
   Put_Line ("  Direccion: " & Clientes.Get_Direccion (Cliente_1));
   Put_Line ("  Correo:    " & Clientes.Get_Correo (Cliente_1));
   Put_Line ("  Telefono:  " & Clientes.Get_Telefono (Cliente_1));

   -- 5.2. Actualizar mediante Service (método que faltaba)
   Imprimir_Subseccion ("Actualizando Cliente 1 mediante Service");
   Clientes_Service.Actualizar_Cliente
     (Status    => Status_Cliente,
      Cliente   => Cliente_1,
      Nombre    => "Juan Carlos",
      Apellido  => "Perez Gonzalez",
      Direccion => "Calle Nueva 789, Sector Norte",
      Correo    => "juan.carlos@empresa.com",
      Telefono  => "0991234567");

   if Status_Cliente.Estado = Resultado_Operacion.Exito then
      Put_Line ("[OK] Actualizacion exitosa via Service!");
      Put_Line ("  Nuevo Nombre:    " & Clientes.Get_Nombre (Cliente_1));
      Put_Line ("  Nuevo Apellido:  " & Clientes.Get_Apellido (Cliente_1));
      Put_Line ("  Nueva Direccion: " & Clientes.Get_Direccion (Cliente_1));
      Put_Line ("  Nuevo Correo:    " & Clientes.Get_Correo (Cliente_1));
      Put_Line ("  Nuevo Telefono:  " & Clientes.Get_Telefono (Cliente_1));
   else
      Put_Line ("[X] Error: " & Status_Cliente.Mensaje);
   end if;

   -- 5.3. Actualizar datos del Cliente 2 mediante setters individuales
   Imprimir_Subseccion ("Actualizando Cliente 2 con Setters Individuales");
   Put_Line ("  Datos Originales:");
   Put_Line ("    Nombre:    " & Clientes.Get_Nombre (Cliente_2));
   Put_Line ("    Apellido:  " & Clientes.Get_Apellido (Cliente_2));
   Put_Line ("    Direccion: " & Clientes.Get_Direccion (Cliente_2));

   Clientes.Set_Apellido (Cliente_2, "Lopez Martinez");
   Clientes.Set_Direccion (Cliente_2, "Avenida Principal 456, Piso 3");
   Clientes.Set_Correo (Cliente_2, "maria.lopez.m@mail.com");

   Put_Line ("  Datos Actualizados:");
   Put_Line ("    Apellido:  " & Clientes.Get_Apellido (Cliente_2));
   Put_Line ("    Direccion: " & Clientes.Get_Direccion (Cliente_2));
   Put_Line ("    Correo:    " & Clientes.Get_Correo (Cliente_2));

   -- 5.4. Verificar que campos inmutables NO cambiaron
   Imprimir_Subseccion ("Verificando Campos INMUTABLES");
   Put_Line ("  (Cedula y Numero de Cuenta NO deben cambiar)");
   Put_Line ("");
   Put_Line ("  Cliente 1:");
   Put_Line ("    Cedula:         " & Clientes.Get_Cedula (Cliente_1) &
             " (debe ser 0102030405)");
   Put_Line ("    Numero Cuenta:  " & Clientes.Get_Numero_Cuenta (Cliente_1));
   Put_Line ("");
   Put_Line ("  Cliente 3:");
   Put_Line ("    Cedula:         " & Clientes.Get_Cedula (Cliente_3) &
             " (debe ser 0304050607)");
   Put_Line ("    Numero Tarjeta: " & Clientes.Get_Numero_Tarjeta (Cliente_3));

   -------------------------------------------------------
   -- 9. PRUEBAS DE ACTUALIZAR LIMITE DE CREDITO
   -------------------------------------------------------
   Imprimir_Seccion ("6. ACTUALIZACION DE LIMITE DE CREDITO");

   -- 6.1. Consultar límite actual
   Imprimir_Subseccion ("Limite Actual de Tarjeta");
   Put_Line ("  Numero Tarjeta:  " & Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all));
   Put_Line ("  Limite Credito:  " &
             Tarjeta_Credito.Limite_Credito_Type'Image
               (Tarjeta_Credito.Get_Limite_Credito (Tarjeta_1.all)));
   Put_Line ("  Saldo Utilizado: " &
             Tarjeta_Credito.Saldo_Type'Image
               (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));

   -- 6.2. Actualizar límite de crédito (método que faltaba)
   Imprimir_Subseccion ("Actualizando Limite a $7,000.00");
   Tarjeta_Credito_Service.Actualizar_Limite_Credito
     (Status         => Status_Tarjeta,
      Numero_Tarjeta => Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all),
      Nuevo_Limite   => 7000.00);

   if Status_Tarjeta.Estado = Resultado_Operacion.Exito then
      Put_Line ("[OK] Limite actualizado exitosamente!");
      Put_Line ("  Nuevo Limite:    " &
                Tarjeta_Credito.Limite_Credito_Type'Image
                  (Tarjeta_Credito.Get_Limite_Credito (Tarjeta_1.all)));
      Put_Line ("  Saldo Utilizado: " &
                Tarjeta_Credito.Saldo_Type'Image
                  (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));
      Put_Line ("  Credito Disponible: " &
                Tarjeta_Credito.Saldo_Type'Image
                  (Tarjeta_Credito.Get_Credito_Disponible (Tarjeta_1.all)));
   else
      Put_Line ("[X] Error: " & Status_Tarjeta.Mensaje);
   end if;

   -- 6.3. Intentar actualizar con límite menor al saldo utilizado (debe fallar)
   Imprimir_Subseccion ("Intentando Actualizar con Limite Insuficiente (debe fallar)");
   Put_Line ("  Saldo Utilizado: " &
             Tarjeta_Credito.Saldo_Type'Image
               (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));
   Put_Line ("  Intentando Limite: $500.00");

   Tarjeta_Credito_Service.Actualizar_Limite_Credito
     (Status         => Status_Tarjeta,
      Numero_Tarjeta => Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all),
      Nuevo_Limite   => 500.00);

   if Status_Tarjeta.Estado /= Resultado_Operacion.Exito then
      Put_Line ("[OK] OK: Validacion correcta - " & Status_Tarjeta.Mensaje);
   else
      Put_Line ("[X] ERROR: No deberia permitir limite menor al saldo!");
   end if;

   -------------------------------------------------------
   -- 10. PRUEBAS DE OBTENER TARJETA
   -------------------------------------------------------
   Imprimir_Seccion ("7. BUSQUEDA DE TARJETAS (OBTENER_TARJETA)");

   -- 10.1. Obtener tarjeta existente (método que faltaba)
   Imprimir_Subseccion ("Obteniendo Tarjeta Existente");
   declare
      Numero_Buscar : constant String := Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all);
      Tarjeta_Obtenida : constant Tarjeta_Credito.Tarjeta_Credito_Access :=
        Tarjeta_Credito_Service.Obtener_Tarjeta (Numero_Buscar);
   begin
      if Tarjeta_Obtenida /= null then
         Put_Line ("[OK] Tarjeta encontrada!");
         Put_Line ("  Numero:          " &
                   Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_Obtenida.all));
         Put_Line ("  Limite:          " &
                   Tarjeta_Credito.Limite_Credito_Type'Image
                     (Tarjeta_Credito.Get_Limite_Credito (Tarjeta_Obtenida.all)));
         Put_Line ("  Saldo Utilizado: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_Obtenida.all)));
      else
         Put_Line ("[X] ERROR: Tarjeta no encontrada!");
      end if;
   end;

   -- 10.2. Intentar obtener tarjeta inexistente
   Imprimir_Subseccion ("Intentando Obtener Tarjeta Inexistente");
   declare
      Tarjeta_Inexistente : constant Tarjeta_Credito.Tarjeta_Credito_Access :=
        Tarjeta_Credito_Service.Obtener_Tarjeta ("9999999999999999");
   begin
      if Tarjeta_Inexistente = null then
         Put_Line ("[OK] OK: Tarjeta no encontrada (comportamiento esperado)");
      else
         Put_Line ("[X] ERROR: No deberia encontrar tarjeta inexistente!");
      end if;
   end;

   -------------------------------------------------------
   -- 11. PRUEBAS DE APLICAR INTERES A CUENTAS
   -------------------------------------------------------
   Imprimir_Seccion ("8. APLICACION DE INTERESES EN CUENTAS");

   -- 11.1. Aplicar interés a Cuenta de Ahorros (método que faltaba)
   Imprimir_Subseccion ("Aplicando Interes a Cuenta Ahorros (1.00% mensual)");
   Put_Line ("  Saldo Actual: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));

   declare
      Cuenta_Ahorros_Ptr : Cuenta_Ahorros.Cuenta_Ahorros_Type renames
        Cuenta_Ahorros.Cuenta_Ahorros_Type (Cuenta_1.all);
   begin
      Cuentas_Ahorro_Service.Aplicar_Interes (Cuenta_Ahorros_Ptr);
      Put_Line ("[OK] Interes aplicado exitosamente");
      Put_Line ("  Nuevo Saldo:  " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   end;

   -- 11.2. Aplicar interés a Cuenta Corriente con sobregiro (método que faltaba)
   Imprimir_Subseccion ("Aplicando Interes a Cuenta Corriente");
   Put_Line ("  Creando sobregiro primero...");
   Put_Line ("  Saldo Actual: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)));

   -- Crear sobregiro
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Retiro,
      C_Origen      => Cuenta_2.all,
      C_Destino     => Cuenta_2.all,
      Monto         => 500.00,
      Descripcion   => "Retiro para crear sobregiro",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("  Saldo con Sobregiro: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)));
      Put_Line ("  Aplicando interes de sobregiro (22.00% mensual)...");

      declare
         Cuenta_Corriente_Ptr : Cuenta_Corriente.Cuenta_Corriente_Type renames
           Cuenta_Corriente.Cuenta_Corriente_Type (Cuenta_2.all);
      begin
         Cuentas_Corriente_Service.Aplicar_Interes (Cuenta_Corriente_Ptr);
         Put_Line ("[OK] Interes sobre sobregiro aplicado");
         Put_Line ("  Nuevo Saldo: " &
                   Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)));
      end;
   else
      Put_Line ("  Error al crear sobregiro");
   end if;

   -------------------------------------------------------
   -- 12. PRUEBAS DE ELIMINAR TARJETA
   -------------------------------------------------------
   Imprimir_Seccion ("9. ELIMINACION DE TARJETAS");

   -- 12.1. Crear nueva tarjeta para Cliente 4
   Imprimir_Subseccion ("Creando Cliente 4 con Nueva Tarjeta");
   Clientes_Service.Crear_Cliente_Con_Tarjeta
     (Status            => Status_Cliente,
      Resultado         => Cliente_4,
      Cuenta_Nueva      => Cuenta_4,
      Tarjeta_Nueva     => Tarjeta_2,
      Cedula            => "0405060708",
      Nombre            => "Ana",
      Apellido          => "Rodriguez",
      Direccion         => "Sector Sur 321",
      Correo            => "ana.rodriguez@mail.com",
      Telefono          => "0966666666",
      Tipo_Cuenta       => Clientes_Service.Ahorros,
      Saldo_Inicial     => 1500.00);

   if Status_Cliente.Estado = Resultado_Operacion.Exito then
      Put_Line ("[OK] Cliente y tarjeta creados");
      Put_Line ("  Tarjeta:         " & Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_2.all));
      Put_Line ("  Limite:          " &
                Tarjeta_Credito.Limite_Credito_Type'Image
                  (Tarjeta_Credito.Get_Limite_Credito (Tarjeta_2.all)));
      Put_Line ("  Saldo Utilizado: " &
                Tarjeta_Credito.Saldo_Type'Image
                  (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_2.all)));
   end if;

   -- 12.2. Realizar compra para crear deuda
   Imprimir_Subseccion ("Creando Deuda en Nueva Tarjeta");
   declare
      Estrategia : constant Transaccion_Tarjeta.Compra_Strategy :=
        Transaccion_Tarjeta.Compra_Strategy'(null record);
   begin
      Status_Tarjeta := Tarjeta_Credito_Service.Ejecutar_Operacion
        (Estrategia     => Estrategia,
         Numero_Tarjeta => Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_2.all),
         Monto          => 300.00,
         Descripcion    => "Compra de prueba");

      if Status_Tarjeta.Estado = Resultado_Operacion.Exito then
         Put_Line ("[OK] Compra realizada: $300.00");
         Put_Line ("  Saldo Utilizado: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_2.all)));
      end if;
   end;

   -- 12.3. Intentar eliminar tarjeta con deuda (debe fallar) - método que faltaba
   Imprimir_Subseccion ("Intentando Eliminar Tarjeta con Deuda (debe fallar)");
   Tarjeta_Credito_Service.Eliminar_Tarjeta
     (Status         => Status_Tarjeta,
      Numero_Tarjeta => Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_2.all));

   if Status_Tarjeta.Estado /= Resultado_Operacion.Exito then
      Put_Line ("[OK] OK: No se permite eliminar con deuda");
      Put_Line ("  Razon: " & Status_Tarjeta.Mensaje);
   else
      Put_Line ("[X] ERROR: No deberia eliminar tarjeta con deuda!");
   end if;

   -- 12.4. Pagar toda la deuda
   Imprimir_Subseccion ("Pagando Deuda Total para Poder Eliminar");
   declare
      Estrategia_Pago : constant Transaccion_Tarjeta.Pago_Tarjeta_Strategy :=
        Transaccion_Tarjeta.Pago_Tarjeta_Strategy'(null record);
      Deuda_Total : constant Tarjeta_Credito.Saldo_Type :=
        Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_2.all);
   begin
      Put_Line ("  Pagando: " & Deuda_Total'Image);
      Status_Tarjeta := Tarjeta_Credito_Service.Ejecutar_Operacion
        (Estrategia     => Estrategia_Pago,
         Numero_Tarjeta => Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_2.all),
         Monto          => Deuda_Total);

      if Status_Tarjeta.Estado = Resultado_Operacion.Exito then
         Put_Line ("[OK] Deuda pagada completamente");
         Put_Line ("  Saldo Utilizado: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_2.all)));
      end if;
   end;

   -- 12.5. Ahora eliminar la tarjeta sin deuda
   Imprimir_Subseccion ("Eliminando Tarjeta sin Deuda");
   declare
      Numero_Tarjeta_A_Eliminar : constant String :=
        Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_2.all);
   begin
      Tarjeta_Credito_Service.Eliminar_Tarjeta
        (Status         => Status_Tarjeta,
         Numero_Tarjeta => Numero_Tarjeta_A_Eliminar);

      if Status_Tarjeta.Estado = Resultado_Operacion.Exito then
         Put_Line ("[OK] Tarjeta eliminada exitosamente!");
         Put_Line ("  Numero eliminado: " & Numero_Tarjeta_A_Eliminar);

         -- Verificar que ya no existe
         declare
            Tarjeta_Verificacion : constant Tarjeta_Credito.Tarjeta_Credito_Access :=
              Tarjeta_Credito_Service.Obtener_Tarjeta (Numero_Tarjeta_A_Eliminar);
         begin
            if Tarjeta_Verificacion = null then
               Put_Line ("  Verificacion: Tarjeta no encontrada en el sistema [OK]");
            else
               Put_Line ("  [X] ERROR: La tarjeta todavia existe!");
            end if;
         end;
      else
         Put_Line ("[X] Error: " & Status_Tarjeta.Mensaje);
      end if;
   end;

   -------------------------------------------------------
   -- RESUMEN FINAL
   -------------------------------------------------------
   Imprimir_Seccion ("RESUMEN FINAL DEL SISTEMA");

   Put_Line ("");
   Put_Line ("CLIENTE 1 (Juan Carlos Perez Gonzalez):");
   Put_Line ("  Cuenta: " & Clientes.Get_Numero_Cuenta (Cliente_1));
   Put_Line ("  Tipo:   Ahorros");
   Put_Line ("  Saldo:  " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   Put_Line ("  Estado: " &
             (if Cuentas_Service.Esta_Activa (Cuenta_1.all) then "ACTIVA" else "BLOQUEADA"));

   Put_Line ("");
   Put_Line ("CLIENTE 2 (Maria Lopez Martinez):");
   Put_Line ("  Cuenta: " & Clientes.Get_Numero_Cuenta (Cliente_2));
   Put_Line ("  Tipo:   Corriente");
   Put_Line ("  Saldo:  " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)));
   Put_Line ("  Estado: " &
             (if Cuentas_Service.Esta_Activa (Cuenta_2.all) then "ACTIVA" else "BLOQUEADA"));

   Put_Line ("");
   Put_Line ("CLIENTE 3 (Carlos Gomez):");
   Put_Line ("  Cuenta:  " & Clientes.Get_Numero_Cuenta (Cliente_3));
   Put_Line ("  Saldo:   " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_3.all)));
   Put_Line ("  Tarjeta: " & Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all));
   Put_Line ("  Limite:  " &
             Tarjeta_Credito.Limite_Credito_Type'Image
               (Tarjeta_Credito.Get_Limite_Credito (Tarjeta_1.all)));
   Put_Line ("  Usado:   " &
             Tarjeta_Credito.Saldo_Type'Image
               (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));

   Put_Line ("");
   Put_Line ("CLIENTE 4 (Ana Rodriguez):");
   Put_Line ("  Cuenta:  " & Clientes.Get_Numero_Cuenta (Cliente_4));
   Put_Line ("  Saldo:   " & Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_4.all)));
   Put_Line ("  Tarjeta: ELIMINADA");

   Imprimir_Separador;
   Put_Line ("[OK] Todas las pruebas completadas exitosamente");
   Imprimir_Separador;
end Main;
