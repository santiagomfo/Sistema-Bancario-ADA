with Ada.Strings.Bounded;
with Length; -- Importamos la configuración centralizada

package Clientes is
   pragma Preelaborate;

   MAX_CEDULA    : constant := Length.MAX_ID;
   MAX_NOMBRE    : constant := Length.MAX_TEXTO_CORTO;
   MAX_APELLIDO  : constant := Length.MAX_TEXTO_CORTO;
   MAX_CORREO    : constant := Length.MAX_TEXTO_CORTO;
   MAX_DIRECCION : constant := Length.MAX_TEXTO_LARGO;
   MAX_TELEFONO  : constant := Length.MAX_TELEFONO;

   -- Paquetes Bounded_String
   package Cedula_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => MAX_CEDULA);
   package Nombres_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => MAX_NOMBRE);
   package Direccion_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => MAX_DIRECCION);
   package Telefono_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => MAX_TELEFONO);
   package Numero_Cuenta_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => Length.MAX_NUMERO_CUENTA);
   package Numero_Tarjeta_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => Length.MAX_NUMERO_TARJETA);

   subtype Numero_Cuenta_Type is Numero_Cuenta_Str.Bounded_String;

   type Cliente_Type is private;

   function Crear_Cliente
     (Cedula        : String;
      Nombre        : String;
      Apellido      : String;
      Direccion     : String;
      Correo        : String;
      Telefono      : String;
      Numero_Cuenta : String)
      return Cliente_Type
   with
      Pre =>
         Cedula'Length > 0 and Cedula'Length <= MAX_CEDULA and
         Nombre'Length > 0 and Nombre'Length <= MAX_NOMBRE and
         Apellido'Length > 0 and Apellido'Length <= MAX_APELLIDO and
         Direccion'Length > 0 and Direccion'Length <= MAX_DIRECCION and
         Correo'Length > 0 and Correo'Length <= MAX_CORREO and
         Telefono'Length > 0 and Telefono'Length <= MAX_TELEFONO and
         Numero_Cuenta'Length > 0 and Numero_Cuenta'Length <= Length.MAX_NUMERO_CUENTA;

   function Get_Cedula (C : Cliente_Type) return String;
   function Get_Nombre (C : Cliente_Type) return String;
   function Get_Apellido (C : Cliente_Type) return String;
   function Get_Direccion (C : Cliente_Type) return String;
   function Get_Correo (C : Cliente_Type) return String;
   function Get_Telefono (C : Cliente_Type) return String;
   function Get_Numero_Cuenta (C : Cliente_Type) return String;
   function Get_Numero_Tarjeta (C : Cliente_Type) return String;
   function Tiene_Tarjeta (C : Cliente_Type) return Boolean;

   procedure Set_Numero_Tarjeta (C : in out Cliente_Type; Numero_Tarjeta : String);

   -- Operaciones UPDATE para campos mutables
   procedure Set_Nombre (C : in out Cliente_Type; Nombre : String)
   with Pre => Nombre'Length > 0 and Nombre'Length <= MAX_NOMBRE;

   procedure Set_Apellido (C : in out Cliente_Type; Apellido : String)
   with Pre => Apellido'Length > 0 and Apellido'Length <= MAX_APELLIDO;

   procedure Set_Direccion (C : in out Cliente_Type; Direccion : String)
   with Pre => Direccion'Length > 0 and Direccion'Length <= MAX_DIRECCION;

   procedure Set_Correo (C : in out Cliente_Type; Correo : String)
   with Pre => Correo'Length > 0 and Correo'Length <= MAX_CORREO;

   procedure Set_Telefono (C : in out Cliente_Type; Telefono : String)
   with Pre => Telefono'Length > 0 and Telefono'Length <= MAX_TELEFONO;

private

   type Cliente_Type is record
      Cedula         : Cedula_Str.Bounded_String;
      Nombre         : Nombres_Str.Bounded_String;
      Apellido       : Nombres_Str.Bounded_String;
      Direccion      : Direccion_Str.Bounded_String;
      Correo         : Nombres_Str.Bounded_String;
      Telefono       : Telefono_Str.Bounded_String;
      Numero_Cuenta  : Numero_Cuenta_Str.Bounded_String;
      Numero_Tarjeta : Numero_Tarjeta_Str.Bounded_String;  -- Vacío = sin tarjeta
   end record;

end Clientes;
