package body Clientes is

   function Crear_Cliente
     (Cedula        : String;
      Nombre        : String;
      Apellido      : String;
      Direccion     : String;
      Correo        : String;
      Telefono      : String;
      Numero_Cuenta : Numero_Cuenta_Type)
      return Cliente_Type
   is
   begin
      return Cliente_Type'(
         Cedula        => Cedula,
         Nombre        => Nombres_Str.To_Bounded_String (Nombre),
         Apellido      => Nombres_Str.To_Bounded_String (Apellido),
         Direccion     => Direccion_Str.To_Bounded_String (Direccion),
         Correo        => Nombres_Str.To_Bounded_String (Correo),
         Telefono      => Telefono_Str.To_Bounded_String (Telefono),
         Numero_Cuenta => Numero_Cuenta,
         Numero_Tarjeta => Numero_Tarjeta_Str.Null_Bounded_String
      );
   end Crear_Cliente;

   function Get_Cedula (C : Cliente_Type) return String is
   begin
      return C.Cedula;
   end Get_Cedula;

   function Get_Nombre (C : Cliente_Type) return String is
   begin
      return Nombres_Str.To_String (C.Nombre);
   end Get_Nombre;

   function Get_Apellido (C : Cliente_Type) return String is
   begin
      return Nombres_Str.To_String (C.Apellido);
   end Get_Apellido;

   function Get_Direccion (C : Cliente_Type) return String is
   begin
      return Direccion_Str.To_String (C.Direccion);
   end Get_Direccion;

   function Get_Correo (C : Cliente_Type) return String is
   begin
      return Nombres_Str.To_String (C.Correo);
   end Get_Correo;

   function Get_Telefono (C : Cliente_Type) return String is
   begin
      return Telefono_Str.To_String (C.Telefono);
   end Get_Telefono;

   function Get_Numero_Cuenta (C : Cliente_Type) return Numero_Cuenta_Type is
   begin
      return C.Numero_Cuenta;
   end Get_Numero_Cuenta;

   function Get_Numero_Tarjeta (C : Cliente_Type) return String is
   begin
      return Numero_Tarjeta_Str.To_String (C.Numero_Tarjeta);
   end Get_Numero_Tarjeta;

   function Tiene_Tarjeta (C : Cliente_Type) return Boolean is
   begin
      return Numero_Tarjeta_Str.Length (C.Numero_Tarjeta) > 0;
   end Tiene_Tarjeta;

   procedure Set_Numero_Tarjeta (C : in out Cliente_Type; Numero_Tarjeta : String) is
   begin
      C.Numero_Tarjeta := Numero_Tarjeta_Str.To_Bounded_String (Numero_Tarjeta);
   end Set_Numero_Tarjeta;

end Clientes;
