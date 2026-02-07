with Cuenta_Ahorros;
with Cuenta_Corriente;
with Cuentas;

package body Clientes_Service is

   package Cli renames Clientes;

   function Esta_En_Rango (Campo : String; Maximo : Integer) return Boolean is
   begin
      return Campo'Length > 0 and then Campo'Length <= Maximo;
   end Esta_En_Rango;

   procedure Crear_Cliente
     (Resultado     : out Cli.Cliente_Type;
      Cedula        : String;
      Nombre        : String;
      Apellido      : String;
      Direccion     : String;
      Correo        : String;
      Telefono      : String;
      Tipo_Cuenta   : Tipo_Cuenta_Enum;
      Numero_Cuenta : String;
      Saldo_Inicial : Cuentas.Saldo_Type)
   is
      --  Para mantener el objeto creado
      C_Ahorro    : Cuenta_Ahorros.Cuenta_Ahorros_Type;
      C_Corriente : Cuenta_Corriente.Cuenta_Corriente_Type;

      --  Simulación de ID de cuenta (ya que las cuentas no tienen ID numérico en la definición actual,
      --  usamos 1 por defecto o podríamos derivarlo del número de cuenta si fuera entero)
      Id_Cuenta_Nueva : constant Cli.Id_Cuenta_Type := 1;
   begin
      if not Esta_En_Rango (Cedula, Cli.MAX_CEDULA) then
         raise Datos_Invalidos with "Cedula fuera de rango";
      end if;

      if not Esta_En_Rango (Nombre, Cli.MAX_NOMBRE) then
         raise Datos_Invalidos with "Nombre fuera de rango";
      end if;

      if not Esta_En_Rango (Apellido, Cli.MAX_APELLIDO) then
         raise Datos_Invalidos with "Apellido fuera de rango";
      end if;

      if not Esta_En_Rango (Direccion, Cli.MAX_DIRECCION) then
         raise Datos_Invalidos with "Direccion fuera de rango";
      end if;

      if not Esta_En_Rango (Correo, Cli.MAX_CORREO) then
         raise Datos_Invalidos with "Correo fuera de rango";
      end if;

      if not Esta_En_Rango (Telefono, Cli.MAX_TELEFONO) then
         raise Datos_Invalidos with "Telefono fuera de rango";
      end if;

      --  Crear la cuenta primero según la bandera (Tipo_Cuenta)
      case Tipo_Cuenta is
         when Ahorros =>
            --  Validación específica o dejar que falle la precondición
            --  El tipo Cuenta_Ahorros requiere Saldo >= 0.0
            if Saldo_Inicial < 0.0 then
               raise Datos_Invalidos with "El saldo inicial para cuenta de ahorros no puede ser negativo";
            end if;

            C_Ahorro := Cuenta_Ahorros.Crear_Cuenta_Ahorros
              (Numero_Cuenta => Numero_Cuenta,
               Saldo         => Cuenta_Ahorros.Saldo_Ahorros_Type (Saldo_Inicial),
               Estado        => Cuentas.Activa);

         when Corriente =>
            C_Corriente := Cuenta_Corriente.Crear_Cuenta_Corriente
              (Numero_Cuenta => Numero_Cuenta,
               Saldo         => Saldo_Inicial,
               Estado        => Cuentas.Activa);
      end case;

      --  Usar la función Crear_Cliente del modelo, asignando el ID de la cuenta creada
      Resultado := Cli.Crear_Cliente
        (Cedula    => Cedula,
         Nombre    => Nombre,
         Apellido  => Apellido,
         Direccion => Direccion,
         Correo    => Correo,
         Telefono  => Telefono,
         Id_Cuenta => Id_Cuenta_Nueva);
   end Crear_Cliente;

   procedure Actualizar_Cliente
     (Cliente   : in out Cli.Cliente_Type;
      Nombre    : String;
      Apellido  : String;
      Direccion : String;
      Correo    : String;
      Telefono  : String)
   is
      Cedula_Actual : constant String := Cli.Get_Cedula (Cliente);
      Id_Actual     : constant Cli.Id_Cuenta_Type := Cli.Get_Id_Cuenta (Cliente);
   begin
      if not Esta_En_Rango (Nombre, Cli.MAX_NOMBRE) then
         raise Datos_Invalidos with "Nombre fuera de rango";
      end if;

      if not Esta_En_Rango (Apellido, Cli.MAX_APELLIDO) then
         raise Datos_Invalidos with "Apellido fuera de rango";
      end if;

      if not Esta_En_Rango (Direccion, Cli.MAX_DIRECCION) then
         raise Datos_Invalidos with "Direccion fuera de rango";
      end if;

      if not Esta_En_Rango (Correo, Cli.MAX_CORREO) then
         raise Datos_Invalidos with "Correo fuera de rango";
      end if;

      if not Esta_En_Rango (Telefono, Cli.MAX_TELEFONO) then
         raise Datos_Invalidos with "Telefono fuera de rango";
      end if;

      --  Recrear el cliente con los nuevos datos
      Cliente := Cli.Crear_Cliente
        (Cedula    => Cedula_Actual,
         Nombre    => Nombre,
         Apellido  => Apellido,
         Direccion => Direccion,
         Correo    => Correo,
         Telefono  => Telefono,
         Id_Cuenta => Id_Actual);
   end Actualizar_Cliente;

end Clientes_Service;
