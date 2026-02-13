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

   subtype Numero_Cuenta_Type is String (1 .. Length.MAX_NUMERO_CUENTA);


   package Nombres_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => MAX_NOMBRE);
   package Direccion_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => MAX_DIRECCION);
   package Telefono_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => MAX_TELEFONO);
   package Numero_Tarjeta_Str is new Ada.Strings.Bounded.Generic_Bounded_Length (Max => Length.MAX_NUMERO_TARJETA);

   type Cliente_Type is private;

   function Crear_Cliente
     (Cedula        : String;
      Nombre        : String;
      Apellido      : String;
      Direccion     : String;
      Correo        : String;
      Telefono      : String;
      Numero_Cuenta : Numero_Cuenta_Type)
      return Cliente_Type
   with
      Pre =>
         Cedula'Length = MAX_CEDULA and
         Nombre'Length <= MAX_NOMBRE and
         Apellido'Length <= MAX_APELLIDO and
         Direccion'Length <= MAX_DIRECCION and
         Correo'Length <= MAX_CORREO and
         Telefono'Length <= MAX_TELEFONO;

   function Get_Cedula (C : Cliente_Type) return String;
   function Get_Nombre (C : Cliente_Type) return String;
   function Get_Apellido (C : Cliente_Type) return String;
   function Get_Direccion (C : Cliente_Type) return String;
   function Get_Correo (C : Cliente_Type) return String;
   function Get_Telefono (C : Cliente_Type) return String;
   function Get_Numero_Cuenta (C : Cliente_Type) return Numero_Cuenta_Type;
   function Get_Numero_Tarjeta (C : Cliente_Type) return String;
   function Tiene_Tarjeta (C : Cliente_Type) return Boolean;

   procedure Set_Numero_Tarjeta (C : in out Cliente_Type; Numero_Tarjeta : String);

private

   type Cliente_Type is record
      Cedula        : String (1 .. MAX_CEDULA);
      Nombre        : Nombres_Str.Bounded_String;
      Apellido      : Nombres_Str.Bounded_String;
      Direccion     : Direccion_Str.Bounded_String;
      Correo        : Nombres_Str.Bounded_String;
      Telefono      : Telefono_Str.Bounded_String;
      Numero_Cuenta : Numero_Cuenta_Type;
      Numero_Tarjeta : Numero_Tarjeta_Str.Bounded_String;  -- Vacío = sin tarjeta
   end record;

end Clientes;
