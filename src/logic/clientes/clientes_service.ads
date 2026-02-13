with Clientes;
with Length;
with Cuentas;
with Tarjeta_Credito;

package Clientes_Service is

   use Tarjeta_Credito;

   Datos_Invalidos : exception;

   type Tipo_Cuenta_Enum is (Ahorros, Corriente);

   procedure Crear_Cliente
     (Resultado     : out Clientes.Cliente_Type;
      Cuenta_Nueva  : out Cuentas.Cuenta_Access;
      Cedula        : String;
      Nombre        : String;
      Apellido      : String;
      Direccion     : String;
      Correo        : String;
      Telefono      : String;
      Tipo_Cuenta   : Tipo_Cuenta_Enum;
      Saldo_Inicial : Cuentas.Saldo_Type)
   with
      Pre =>
         Cedula'Length > 0 and Cedula'Length <= Clientes.MAX_CEDULA and
         Nombre'Length > 0 and Nombre'Length <= Clientes.MAX_NOMBRE and
         Apellido'Length > 0 and Apellido'Length <= Clientes.MAX_APELLIDO and
         Direccion'Length > 0 and Direccion'Length <= Clientes.MAX_DIRECCION and
         Correo'Length > 0 and Correo'Length <= Clientes.MAX_CORREO and
         Telefono'Length > 0 and Telefono'Length <= Clientes.MAX_TELEFONO;

   procedure Actualizar_Cliente
     (Cliente    : in out Clientes.Cliente_Type;
      Nombre     : String;
      Apellido   : String;
      Direccion  : String;
      Correo     : String;
      Telefono   : String)
   with
      Pre =>
         Nombre'Length > 0 and Nombre'Length <= Clientes.MAX_NOMBRE and
         Apellido'Length > 0 and Apellido'Length <= Clientes.MAX_APELLIDO and
         Direccion'Length > 0 and Direccion'Length <= Clientes.MAX_DIRECCION and
         Correo'Length > 0 and Correo'Length <= Clientes.MAX_CORREO and
         Telefono'Length > 0 and Telefono'Length <= Clientes.MAX_TELEFONO;

   -- Procedimientos para gestión de tarjetas de crédito
   procedure Asociar_Tarjeta_Credito
     (Cliente           : in out Clientes.Cliente_Type;
      Tarjeta_Nueva     : out Tarjeta_Credito.Tarjeta_Credito_Access)
   with
      Pre => not Clientes.Tiene_Tarjeta (Cliente),
      Post => Clientes.Tiene_Tarjeta (Cliente);

   procedure Crear_Cliente_Con_Tarjeta
     (Resultado         : out Clientes.Cliente_Type;
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
   with
      Pre =>
         Cedula'Length > 0 and Cedula'Length <= Clientes.MAX_CEDULA and
         Nombre'Length > 0 and Nombre'Length <= Clientes.MAX_NOMBRE and
         Apellido'Length > 0 and Apellido'Length <= Clientes.MAX_APELLIDO and
         Direccion'Length > 0 and Direccion'Length <= Clientes.MAX_DIRECCION and
         Correo'Length > 0 and Correo'Length <= Clientes.MAX_CORREO and
         Telefono'Length > 0 and Telefono'Length <= Clientes.MAX_TELEFONO;

end Clientes_Service;
