with Tarjeta_Credito;
with Transaccion_Tarjeta;
with Length;

package Tarjeta_Credito_Service is

   use Tarjeta_Credito;
   use Length;

   -- Excepciones
   Limite_Credito_Excedido : exception;
   Pago_Invalido : exception;
   Tarjeta_Vencida : exception;
   Tarjeta_No_Encontrada : exception;
   Tarjeta_Con_Deuda : exception;

   -- === OPERACIONES CRUD ===

   function Crear_Tarjeta
     (Tasa_Interes_Mensual  : Tasa_Interes_Type := Length.DEFAULT_TASA_INTERES_TARJETA)
      return Tarjeta_Credito_Access;

   function Obtener_Tarjeta (Numero_Tarjeta : String) return Tarjeta_Credito_Access
   with
      Pre => Numero_Tarjeta'Length > 0;

   procedure Actualizar_Limite_Credito
     (Numero_Tarjeta : String;
      Nuevo_Limite   : Limite_Credito_Type)
   with
      Pre => Numero_Tarjeta'Length > 0 and Nuevo_Limite > 0.0;

   procedure Eliminar_Tarjeta (Numero_Tarjeta : String)
   with
      Pre => Numero_Tarjeta'Length > 0;

   -- === OPERACIONES DE NEGOCIO ===

   procedure Comprar
     (Numero_Tarjeta : String;
      Monto          : Saldo_Type;
      Descripcion    : String)
   with
      Pre => Numero_Tarjeta'Length > 0 and Monto > 0.0;

   procedure Pagar
     (Numero_Tarjeta : String;
      Monto          : Saldo_Type)
   with
      Pre => Numero_Tarjeta'Length > 0 and Monto > 0.0;

   procedure Calcular_Aplicar_Interes (Numero_Tarjeta : String)
   with
      Pre => Numero_Tarjeta'Length > 0;

   function Consultar_Estado_Tarjeta (Numero_Tarjeta : String) return String
   with
      Pre => Numero_Tarjeta'Length > 0;

end Tarjeta_Credito_Service;
