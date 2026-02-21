with Cuenta_Ahorros;
with Cuenta_Corriente;
with Cuentas;
with Tarjeta_Credito_Service;
with Resultado_Operacion; use Resultado_Operacion;

package body Clientes_Service is
   use type Cuentas.Saldo_Type;

   package Cli renames Clientes;

   function Esta_En_Rango (Campo : String; Maximo : Integer) return Boolean is
   begin
      return Campo'Length > 0 and then Campo'Length <= Maximo;
   end Esta_En_Rango;

   procedure Crear_Cliente
     (Status        : out Cliente_Resultado_Type;
      Resultado     : out Cli.Cliente_Type;
      Cuenta_Nueva  : out Cuentas.Cuenta_Access;
      Cedula        : String;
      Nombre        : String;
      Apellido      : String;
      Direccion     : String;
      Correo        : String;
      Telefono      : String;
      Tipo_Cuenta   : Tipo_Cuenta_Enum;
      Saldo_Inicial : Cuentas.Saldo_Type)
   is
      Numero_Cuenta_Generada : String (1 .. Length.MAX_NUMERO_CUENTA);
   begin
      if not Esta_En_Rango (Cedula, Cli.MAX_CEDULA) then
         Status := Crear_Error (Cedula_Invalida, "Cedula fuera de rango");
         return;
      end if;

      if not Esta_En_Rango (Nombre, Cli.MAX_NOMBRE) then
         Status := Crear_Error (Nombre_Invalido, "Nombre fuera de rango");
         return;
      end if;

      if not Esta_En_Rango (Apellido, Cli.MAX_APELLIDO) then
         Status := Crear_Error (Apellido_Invalido, "Apellido fuera de rango");
         return;
      end if;

      if not Esta_En_Rango (Direccion, Cli.MAX_DIRECCION) then
         Status := Crear_Error (Direccion_Invalida, "Direccion fuera de rango");
         return;
      end if;

      if not Esta_En_Rango (Correo, Cli.MAX_CORREO) then
         Status := Crear_Error (Correo_Invalido, "Correo fuera de rango");
         return;
      end if;

      if not Esta_En_Rango (Telefono, Cli.MAX_TELEFONO) then
         Status := Crear_Error (Telefono_Invalido, "Telefono fuera de rango");
         return;
      end if;

      --  Crear la cuenta primero según la bandera (Tipo_Cuenta)
      case Tipo_Cuenta is
         when Ahorros =>
            --  Validación específica: saldo no negativo para cuenta ahorros
            if Saldo_Inicial < 0.0 then
               Status := Crear_Error (Saldo_Inicial_Invalido, "El saldo inicial para cuenta de ahorros no puede ser negativo");
               return;
            end if;

            Cuenta_Nueva := new Cuenta_Ahorros.Cuenta_Ahorros_Type'(
               Cuenta_Ahorros.Crear_Cuenta_Ahorros
                 (Saldo         => Cuenta_Ahorros.Saldo_Ahorros_Type (Saldo_Inicial),
                  Estado        => Cuentas.Activa));

         when Corriente =>
            Cuenta_Nueva := new Cuenta_Corriente.Cuenta_Corriente_Type'(
               Cuenta_Corriente.Crear_Cuenta_Corriente
                 (Saldo         => Saldo_Inicial,
                  Estado        => Cuentas.Activa));

      end case;

      Numero_Cuenta_Generada := Cuenta_Nueva.Get_Numero_Cuenta;

      Resultado := Cli.Crear_Cliente
        (Cedula        => Cedula,
         Nombre        => Nombre,
         Apellido      => Apellido,
         Direccion     => Direccion,
         Correo        => Correo,
         Telefono      => Telefono,
         Numero_Cuenta => Numero_Cuenta_Generada);

      Status := Crear_Exito;
   end Crear_Cliente;

   procedure Actualizar_Cliente
     (Status    : out Cliente_Resultado_Type;
      Cliente   : in out Cli.Cliente_Type;
      Nombre    : String;
      Apellido  : String;
      Direccion : String;
      Correo    : String;
      Telefono  : String)
   is
      Cedula_Actual        : constant String := Cli.Get_Cedula (Cliente);
      Numero_Cuenta_Actual : constant String := Cli.Get_Numero_Cuenta (Cliente);
   begin
      if not Esta_En_Rango (Nombre, Cli.MAX_NOMBRE) then
         Status := Crear_Error (Nombre_Invalido, "Nombre fuera de rango");
         return;
      end if;

      if not Esta_En_Rango (Apellido, Cli.MAX_APELLIDO) then
         Status := Crear_Error (Apellido_Invalido, "Apellido fuera de rango");
         return;
      end if;

      if not Esta_En_Rango (Direccion, Cli.MAX_DIRECCION) then
         Status := Crear_Error (Direccion_Invalida, "Direccion fuera de rango");
         return;
      end if;

      if not Esta_En_Rango (Correo, Cli.MAX_CORREO) then
         Status := Crear_Error (Correo_Invalido, "Correo fuera de rango");
         return;
      end if;

      if not Esta_En_Rango (Telefono, Cli.MAX_TELEFONO) then
         Status := Crear_Error (Telefono_Invalido, "Telefono fuera de rango");
         return;
      end if;

      --  Recrear el cliente con los nuevos datos
      Cliente := Cli.Crear_Cliente
        (Cedula        => Cedula_Actual,
         Nombre        => Nombre,
         Apellido      => Apellido,
         Direccion     => Direccion,
         Correo        => Correo,
         Telefono      => Telefono,
         Numero_Cuenta => Numero_Cuenta_Actual);

      Status := Crear_Exito;
   end Actualizar_Cliente;

   -- Procedimientos para gestión de tarjetas de crédito
   procedure Asociar_Tarjeta_Credito
     (Cliente           : in out Cli.Cliente_Type;
      Tarjeta_Nueva     : out Tarjeta_Credito.Tarjeta_Credito_Access)
   is
   begin
      --  Crear y asociar una tarjeta de crédito al cliente
      Tarjeta_Nueva := Tarjeta_Credito_Service.Crear_Tarjeta;

     --  Asociar el número de tarjeta al cliente
      Cli.Set_Numero_Tarjeta (Cliente, Tarjeta_Credito.Get_Numero_Tarjeta (Tarjeta_Nueva.all));
   end Asociar_Tarjeta_Credito;

   procedure Crear_Cliente_Con_Tarjeta
     (Status            : out Cliente_Resultado_Type;
      Resultado         : out Cli.Cliente_Type;
      Cuenta_Nueva      : out Cuentas.Cuenta_Access;
      Tarjeta_Nueva     : out Tarjeta_Credito.Tarjeta_Credito_Access;
      Cedula            : String;
      Nombre            : String;
      Apellido          : String;
      Direccion         : String;
      Correo            : String;
      Telefono          : String;
      Tipo_Cuenta       : Tipo_Cuenta_Enum;
      Saldo_Inicial     : Cuentas.Saldo_Type)
   is
   begin
      -- Primero crear el cliente con su cuenta
      Crear_Cliente
        (Status        => Status,
         Resultado     => Resultado,
         Cuenta_Nueva  => Cuenta_Nueva,
         Cedula        => Cedula,
         Nombre        => Nombre,
         Apellido      => Apellido,
         Direccion     => Direccion,
         Correo        => Correo,
         Telefono      => Telefono,
         Tipo_Cuenta   => Tipo_Cuenta,
         Saldo_Inicial => Saldo_Inicial);

      -- Solo continuar si la creación fue exitosa
      if Status.Estado /= Resultado_Operacion.Exito then
         return;
      end if;

      -- Luego asociar una tarjeta de crédito
      Asociar_Tarjeta_Credito
        (Cliente        => Resultado,
         Tarjeta_Nueva  => Tarjeta_Nueva);
   end Crear_Cliente_Con_Tarjeta;

end Clientes_Service;
