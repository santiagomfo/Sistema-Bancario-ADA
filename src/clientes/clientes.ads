package Clientes is
   --  Trazabilidad Diccionario de Datos
   MAX_CEDULA    : constant := 10;   --  CHAR(10)
   MAX_NOMBRE    : constant := 52;   --  VARCHAR(52)
   MAX_APELLIDO  : constant := 52;   --  VARCHAR(52)
   MAX_DIRECCION : constant := 152;  --  VARCHAR(152)
   MAX_CORREO    : constant := 52;   --  VARCHAR(52)
   MAX_TELEFONO  : constant := 15;   --  VARCHAR(15)

   --  Información completa de un cliente del sistema bancario
   --  Todos los campos tienen longitud fija según el diccionario de datos
   type Cliente is record
      Cedula    : String (1 .. MAX_CEDULA);
      Nombre    : String (1 .. MAX_NOMBRE);
      Apellido  : String (1 .. MAX_APELLIDO);
      Direccion : String (1 .. MAX_DIRECCION);
      Correo    : String (1 .. MAX_CORREO);
      Telefono  : String (1 .. MAX_TELEFONO);
   end record;

   --  Crea un nuevo cliente validando todos los campos
   --  contra sus longitudes máximas
   --  Retorna False si algún campo excede su longitud o está vacío
   function Crear_Cliente (
      Nuevo_Cliente : out Cliente;
      Cedula    : String;
      Nombre    : String;
      Apellido  : String;
      Direccion : String;
      Correo    : String;
      Telefono  : String
   ) return Boolean;

   --  Actualiza los datos de un cliente existente (excepto la cédula)
   --  Retorna False si algún campo excede su longitud o está vacío
   function Actualizar_Cliente (
      Cliente_Actual : in out Cliente;
      Nombre    : String;
      Apellido  : String;
      Direccion : String;
      Correo    : String;
      Telefono  : String
   ) return Boolean;

end Clientes;
