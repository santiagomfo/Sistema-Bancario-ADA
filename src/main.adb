with Ada.Text_IO; use Ada.Text_IO;
with Clientes;
with Clientes_Service;
with Cliente_Resultado;
with Cuentas;
with Cuenta_Ahorros;
with Cuenta_Corriente;
with Cuentas_Service;
with Transaccion_Service;
with Transaccion;
with Transaccion_Tarjeta;
with Movimientos;
with Tarjeta_Credito;
with Tarjeta_Credito_Service;
with Tarjeta_Resultado;
with Resultado_Operacion; use Resultado_Operacion;

procedure Main is
   Cliente_1, Cliente_2, Cliente_3  : Clientes.Cliente_Type;
   Cuenta_1, Cuenta_2, Cuenta_3     : Cuentas.Cuenta_Access;
   Tarjeta_1                        : Tarjeta_Credito.Tarjeta_Credito_Access;

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
begin
   Put_Line ("--- Sistema Bancario - Inicio ---");

   -------------------------------------------------------
   -- 1. Crear Cliente 1 con Cuenta de Ahorros
   -------------------------------------------------------
   Clientes_Service.Crear_Cliente
     (Status        => Status_Cliente,
      Resultado     => Cliente_1,
      Cuenta_Nueva  => Cuenta_1,
      Cedula        => "0102030405",
      Nombre        => "Juan",
      Apellido      => "Perez",
      Direccion     => "Calle 1",
      Correo        => "juan@mail.com",
      Telefono      => "0999999999",
      Tipo_Cuenta   => Clientes_Service.Ahorros,
      Saldo_Inicial => 1000.00);

   if Status_Cliente.Estado = Resultado_Operacion.Exito then
      Put_Line ("Cliente 1 creado: " & Clientes.Get_Nombre (Cliente_1) &
                " (Cuenta Ahorros - Saldo: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)) &
                ")");
   else
      Put_Line ("Error creando Cliente 1: " & Status_Cliente.Mensaje);
      return;
   end if;

   -------------------------------------------------------
   -- 2. Crear Cliente 2 con Cuenta Corriente
   -------------------------------------------------------
   Clientes_Service.Crear_Cliente
     (Status        => Status_Cliente,
      Resultado     => Cliente_2,
      Cuenta_Nueva  => Cuenta_2,
      Cedula        => "0203040506",
      Nombre        => "Maria",
      Apellido      => "Lopez",
      Direccion     => "Calle 2",
      Correo        => "maria@mail.com",
      Telefono      => "0988888888",
      Tipo_Cuenta   => Clientes_Service.Corriente,
      Saldo_Inicial => 500.00);

   if Status_Cliente.Estado = Resultado_Operacion.Exito then
      Put_Line ("Cliente 2 creado: " & Clientes.Get_Nombre (Cliente_2) &
                " (Cuenta Corriente - Saldo: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)) &
                ")");
   else
      Put_Line ("Error creando Cliente 2: " & Status_Cliente.Mensaje);
      return;
   end if;
   Put_Line ("");

   -------------------------------------------------------
   -- 3. Depósito en Cuenta 1
   -------------------------------------------------------
   Put_Line ("--- Realizando Deposito en Cuenta 1 (+100.00) ---");
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Deposito,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_1.all,
      Monto         => 100.00,
      Descripcion   => "Deposito inicial",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("Nuevo Saldo Cliente 1: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   else
      Put_Line ("Error: Operacion no permitida por estado de cuenta");
   end if;

   -------------------------------------------------------
   -- 4. Retiro en Cuenta 1
   -------------------------------------------------------
   Put_Line ("");
   Put_Line ("--- Realizando Retiro en Cuenta 1 (-50.00) ---");
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Retiro,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_1.all,
      Monto         => 50.00,
      Descripcion   => "Retiro para gastos",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("Nuevo Saldo Cliente 1: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   else
      Put_Line ("Error: Operacion no permitida por estado de cuenta");
   end if;

   -------------------------------------------------------
   -- 5. Transferencia de Cuenta 1 a Cuenta 2
   -------------------------------------------------------
   Put_Line ("");
   Put_Line ("--- Transferencia de Cliente 1 a Cliente 2 (200.00) ---");
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Transferencia,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_2.all,
      Monto         => 200.00,
      Descripcion   => "Pago de deuda",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("Saldo Final Cliente 1: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
      Put_Line ("Saldo Final Cliente 2: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)));
   else
      Put_Line ("Error: Operacion no permitida por estado de cuenta");
   end if;

   -------------------------------------------------------
   -- 6. PRUEBAS DEL PATRON STATE
   -------------------------------------------------------
   Put_Line ("");
   Put_Line ("========================================");
   Put_Line ("=== PRUEBAS DEL PATRON STATE ===");
   Put_Line ("========================================");

   -- 6.1. Bloquear Cuenta 1 (usando Service)
   Put_Line ("");
   Put_Line ("--- Bloqueando Cuenta 1 (Ahorros) ---");
   Cuentas_Service.Bloquear_Cuenta (Cuenta_1.all);
   Put_Line ("Estado Cuenta 1: " &
             (if Cuentas_Service.Esta_Bloqueada (Cuenta_1.all) then "BLOQUEADA" else "ACTIVA"));

   -- 6.2. Intentar Retiro en Cuenta Bloqueada (debe fallar)
   Put_Line ("");
   Put_Line ("--- Intentando Retiro en Cuenta BLOQUEADA (debe fallar) ---");
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Retiro,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_1.all,
      Monto         => 10.00,
      Descripcion   => "Intento de retiro",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("ERROR: No deberia permitir retiro en cuenta bloqueada!");
   else
      Put_Line ("OK: Retiro rechazado correctamente (cuenta bloqueada)");
   end if;
   Put_Line ("Saldo sin cambios: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));

   -- 6.3. Depósito en Cuenta Bloqueada (debe funcionar)
   Put_Line ("");
   Put_Line ("--- Deposito en Cuenta BLOQUEADA (debe funcionar) ---");
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Deposito,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_1.all,
      Monto         => 75.00,
      Descripcion   => "Deposito en cuenta bloqueada",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("OK: Deposito aceptado correctamente");
      Put_Line ("Nuevo Saldo: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   else
      Put_Line ("ERROR: Deberia permitir deposito en cuenta bloqueada!");
   end if;

   -- 6.4. Desbloquear Cuenta 1 (usando Service)
   Put_Line ("");
   Put_Line ("--- Desbloqueando Cuenta 1 (Ahorros) ---");
   Cuentas_Service.Activar_Cuenta (Cuenta_1.all);
   Put_Line ("Estado Cuenta 1: " &
             (if Cuentas_Service.Esta_Activa (Cuenta_1.all) then "ACTIVA" else "BLOQUEADA"));

   -- 6.5. Retiro en Cuenta Activa (debe funcionar)
   Put_Line ("");
   Put_Line ("--- Retiro en Cuenta ACTIVA (debe funcionar) ---");
   Resultado := Transaccion_Service.Ejecutar_Transaccion
     (Estrategia    => Estrategia_Retiro,
      C_Origen      => Cuenta_1.all,
      C_Destino     => Cuenta_1.all,
      Monto         => 25.00,
      Descripcion   => "Retiro exitoso",
      Id_Movimiento => Id_Mov);

   if Resultado then
      Put_Line ("OK: Retiro aceptado correctamente");
      Put_Line ("Nuevo Saldo: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   else
      Put_Line ("ERROR: Deberia permitir retiro en cuenta activa!");
   end if;
-------------------------------------------------------
   -- 7. PRUEBAS DE TARJETA DE CREDITO
   -------------------------------------------------------
   Put_Line ("");
   Put_Line ("========================================");
   Put_Line ("=== PRUEBAS DE TARJETA DE CREDITO ===");
   Put_Line ("========================================");

   -- 7.1. Crear Cliente 3 con Tarjeta de Crédito
   Put_Line ("");
   Put_Line ("--- Creando Cliente 3 con Tarjeta de Credito ---");
   Clientes_Service.Crear_Cliente_Con_Tarjeta
     (Status            => Status_Cliente,
      Resultado         => Cliente_3,
      Cuenta_Nueva      => Cuenta_3,
      Tarjeta_Nueva     => Tarjeta_1,
      Cedula            => "0304050607",
      Nombre            => "Carlos",
      Apellido          => "Gomez",
      Direccion         => "Calle 3",
      Correo            => "carlos@mail.com",
      Telefono          => "0977777777",
      Tipo_Cuenta       => Clientes_Service.Ahorros,
      Saldo_Inicial     => 2000.00);

   if Status_Cliente.Estado = Resultado_Operacion.Exito then
      Put_Line ("Cliente 3 creado: " & Clientes.Get_Nombre (Cliente_3));
      Put_Line ("  Cuenta Ahorros - Saldo: " &
                Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_3.all)));
      Put_Line ("  Tarjeta Numero: " &
                Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all));
      Put_Line ("  Limite Credito: " &
                Tarjeta_Credito.Limite_Credito_Type'Image
                  (Tarjeta_Credito.Get_Limite_Credito (Tarjeta_1.all)));
   else
      Put_Line ("Error creando Cliente 3 con tarjeta: " &
                Status_Cliente.Mensaje);
   end if;
   -- 7.2. Consultar Estado de Tarjeta
   Put_Line ("");
   Put_Line ("--- Estado Inicial de Tarjeta ---");
   Put_Line (Tarjeta_Credito_Service.Consultar_Estado_Tarjeta
             (Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all)));

   -- 7.3. Realizar Compra Exitosa
   Put_Line ("");
   Put_Line ("--- Realizando Compra: Laptop $1,200.00 ---");
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
         Put_Line ("Compra realizada: Compra de Laptop - Monto:  1200.00");
         Put_Line ("Compra exitosa!");
         Put_Line ("  Saldo Utilizado: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));
         Put_Line ("  Credito Disponible: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Credito_Disponible (Tarjeta_1.all)));
      else
         Put_Line ("Compra rechazada: " & Status_Tarjeta.Mensaje);
      end if;
   end;

   -- 7.4. Realizar Otra Compra
   Put_Line ("");
   Put_Line ("--- Realizando Compra: Celular $800.00 ---");
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
         Put_Line ("Compra realizada: Compra de Celular - Monto:  800.00");
         Put_Line ("Compra exitosa!");
         Put_Line ("  Saldo Utilizado: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));
         Put_Line ("  Credito Disponible: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Credito_Disponible (Tarjeta_1.all)));
      else
         Put_Line ("Compra rechazada: " & Status_Tarjeta.Mensaje);
      end if;
   end;

   -- 7.5. Intentar Compra que Excede el Límite
   Put_Line ("");
   Put_Line ("--- Intentando Compra que Excede Limite: $4,000.00 ---");
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
         Put_Line ("ERROR: No deberia permitir compra que excede limite!");
      else
         Put_Line ("OK: Compra rechazada - " & Status_Tarjeta.Mensaje);
      end if;
   end;

   -- 7.6. Realizar Pago Parcial
   Put_Line ("");
   Put_Line ("--- Realizando Pago de $500.00 ---");
   declare
      Estrategia : constant Transaccion_Tarjeta.Pago_Tarjeta_Strategy :=
        Transaccion_Tarjeta.Pago_Tarjeta_Strategy'(null record);
   begin
      Status_Tarjeta := Tarjeta_Credito_Service.Ejecutar_Operacion
        (Estrategia     => Estrategia,
         Numero_Tarjeta => Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all),
         Monto          => 500.00);

      if Status_Tarjeta.Estado = Resultado_Operacion.Exito then
         Put_Line ("Pago realizado - Monto:  500.00");
         Put_Line ("Pago exitoso!");
         Put_Line ("  Saldo Utilizado: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));
         Put_Line ("  Credito Disponible: " &
                   Tarjeta_Credito.Saldo_Type'Image
                     (Tarjeta_Credito.Get_Credito_Disponible (Tarjeta_1.all)));
      else
         Put_Line ("Pago rechazado: " & Status_Tarjeta.Mensaje);
      end if;
   end;

   -- 7.7. Calcular y Aplicar Intereses
   Put_Line ("");
   Put_Line ("--- Aplicando Intereses Mensuales (3.50%) ---");
   Tarjeta_Credito_Service.Aplicar_Interes
     (Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all));

   Put_Line ("Intereses aplicados a tarjeta " &
             Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all));
   Put_Line ("  Nuevo Saldo Utilizado: " &
             Tarjeta_Credito.Saldo_Type'Image
               (Tarjeta_Credito.Get_Saldo_Utilizado (Tarjeta_1.all)));
   Put_Line ("  Pago Minimo: " &
             Tarjeta_Credito.Saldo_Type'Image
               (Tarjeta_Credito.Get_Pago_Minimo (Tarjeta_1.all)));

   -- 7.8. Consultar Estado Final
   Put_Line ("");
   Put_Line ("--- Estado Final de Tarjeta ---");
   Put_Line (Tarjeta_Credito_Service.Consultar_Estado_Tarjeta
             (Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_1.all)));

   -------------------------------------------------------
   -- 8. PRUEBAS DE OPERACIONES UPDATE EN CLIENTES
   -------------------------------------------------------
   Put_Line ("");
   Put_Line ("========================================");
   Put_Line ("=== PRUEBAS DE OPERACIONES UPDATE ===");
   Put_Line ("========================================");

   -- 8.1. Mostrar datos originales del Cliente 1
   Put_Line ("");
   Put_Line ("--- Datos Originales del Cliente 1 ---");
   Put_Line ("  Cedula:    " & Clientes.Get_Cedula (Cliente_1));
   Put_Line ("  Nombre:    " & Clientes.Get_Nombre (Cliente_1));
   Put_Line ("  Apellido:  " & Clientes.Get_Apellido (Cliente_1));
   Put_Line ("  Direccion: " & Clientes.Get_Direccion (Cliente_1));
   Put_Line ("  Correo:    " & Clientes.Get_Correo (Cliente_1));
   Put_Line ("  Telefono:  " & Clientes.Get_Telefono (Cliente_1));
   Put_Line ("  Cuenta #:  " & Clientes.Get_Numero_Cuenta (Cliente_1));

   -- 8.2. Actualizar Nombre del Cliente 1
   Put_Line ("");
   Put_Line ("--- Actualizando Nombre (Juan -> Juan Carlos) ---");
   Clientes.Set_Nombre (Cliente_1, "Juan Carlos");
   Put_Line ("  Nuevo Nombre: " & Clientes.Get_Nombre (Cliente_1));

   -- 8.3. Actualizar Correo del Cliente 1
   Put_Line ("");
   Put_Line ("--- Actualizando Correo ---");
   Clientes.Set_Correo (Cliente_1, "juancarlos.perez@empresa.com");
   Put_Line ("  Nuevo Correo: " & Clientes.Get_Correo (Cliente_1));

   -- 8.4. Actualizar Telefono del Cliente 1
   Put_Line ("");
   Put_Line ("--- Actualizando Telefono ---");
   Clientes.Set_Telefono (Cliente_1, "0991234567");
   Put_Line ("  Nuevo Telefono: " & Clientes.Get_Telefono (Cliente_1));

   -- 8.5. Actualizar datos del Cliente 2
   Put_Line ("");
   Put_Line ("--- Datos Originales del Cliente 2 ---");
   Put_Line ("  Nombre:    " & Clientes.Get_Nombre (Cliente_2));
   Put_Line ("  Apellido:  " & Clientes.Get_Apellido (Cliente_2));
   Put_Line ("  Direccion: " & Clientes.Get_Direccion (Cliente_2));

   Put_Line ("");
   Put_Line ("--- Actualizando Cliente 2 ---");
   Clientes.Set_Apellido (Cliente_2, "Lopez Martinez");
   Clientes.Set_Direccion (Cliente_2, "Avenida Principal 456, Piso 3");
   Put_Line ("  Nuevo Apellido:  " & Clientes.Get_Apellido (Cliente_2));
   Put_Line ("  Nueva Direccion: " & Clientes.Get_Direccion (Cliente_2));

   -- 8.6. Actualizar datos del Cliente 3
   Put_Line ("");
   Put_Line ("--- Actualizando Cliente 3 (con tarjeta) ---");
   Put_Line ("  Nombre Original: " & Clientes.Get_Nombre (Cliente_3));
   Clientes.Set_Nombre (Cliente_3, "Carlos Alberto");
   Put_Line ("  Nombre Actualizado: " & Clientes.Get_Nombre (Cliente_3));

   -- 8.7. Verificar que campos inmutables NO cambiaron
   Put_Line ("");
   Put_Line ("--- Verificando Campos INMUTABLES ---");
   Put_Line ("(Cedula, Numero Cuenta y Numero Tarjeta NO deben cambiar)");
   Put_Line ("");
   Put_Line ("Cliente 1:");
   Put_Line ("  Cedula: " & Clientes.Get_Cedula (Cliente_1) &
             " (original: 0102030405)");
   Put_Line ("  Cuenta: " & Clientes.Get_Numero_Cuenta (Cliente_1) &
             " (debe mantenerse)");
   Put_Line ("");
   Put_Line ("Cliente 3:");
   Put_Line ("  Cedula: " & Clientes.Get_Cedula (Cliente_3) &
             " (original: 0304050607)");
   Put_Line ("  Tarjeta: " & Clientes.Get_Numero_Tarjeta (Cliente_3) &
             " (debe mantenerse)");

   -- 8.8. Resumen final de todos los clientes actualizados
   Put_Line ("");
   Put_Line ("========================================");
   Put_Line ("=== ESTADO FINAL DE TODOS LOS CLIENTES ===");
   Put_Line ("========================================");
   Put_Line ("");
   Put_Line ("CLIENTE 1:");
   Put_Line ("  Nombre Completo: " & Clientes.Get_Nombre (Cliente_1) &
             " " & Clientes.Get_Apellido (Cliente_1));
   Put_Line ("  Correo:  " & Clientes.Get_Correo (Cliente_1));
   Put_Line ("  Telefono: " & Clientes.Get_Telefono (Cliente_1));
   Put_Line ("  Saldo Cuenta: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_1.all)));
   Put_Line ("");
   Put_Line ("CLIENTE 2:");
   Put_Line ("  Nombre Completo: " & Clientes.Get_Nombre (Cliente_2) &
             " " & Clientes.Get_Apellido (Cliente_2));
   Put_Line ("  Direccion: " & Clientes.Get_Direccion (Cliente_2));
   Put_Line ("  Saldo Cuenta: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_2.all)));
   Put_Line ("");
   Put_Line ("CLIENTE 3:");
   Put_Line ("  Nombre Completo: " & Clientes.Get_Nombre (Cliente_3) &
             " " & Clientes.Get_Apellido (Cliente_3));
   Put_Line ("  Saldo Cuenta: " &
             Cuentas.Saldo_Type'Image (Cuentas.Get_Saldo (Cuenta_3.all)));
   Put_Line ("  Credito Disponible Tarjeta: " &
             Tarjeta_Credito.Saldo_Type'Image
               (Tarjeta_Credito.Get_Credito_Disponible (Tarjeta_1.all)));

   Put_Line ("");
   Put_Line ("--- Fin de operaciones ---");
end Main;
