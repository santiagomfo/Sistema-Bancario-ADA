package body Clientes is

   function Crear_Cliente
     (Cedula    : String;
      Nombre    : String;
      Apellido  : String;
      Direccion : String;
      Correo    : String;
      Telefono  : String;
      Id_Cuenta : Id_Cuenta_Type)
      return Cliente_Type
   is
   begin
      return Cliente_Type'(
         Cedula    => Cedula,
         Nombre    => Nombres_Str.To_Bounded_String (Nombre),
         Apellido  => Nombres_Str.To_Bounded_String (Apellido),
         Direccion => Direccion_Str.To_Bounded_String (Direccion),
         Correo    => Nombres_Str.To_Bounded_String (Correo),
         Telefono  => Telefono_Str.To_Bounded_String (Telefono),
         Id_Cuenta => Id_Cuenta
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

   function Get_Id_Cuenta (C : Cliente_Type) return Id_Cuenta_Type is
   begin
      return C.Id_Cuenta;
   end Get_Id_Cuenta;

end Clientes;
