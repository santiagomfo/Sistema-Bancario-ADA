# Nomenclatura en Ada según Ada Style Guide

> Basado en: [Ada Style Guide - Wikibooks](https://en.wikibooks.org/wiki/Ada_Style_Guide/Readability)

## 1. VARIABLES Y OBJETOS

### Nombres Generales
- Usar **sustantivos singulares y específicos**
- Describir el valor del objeto durante la ejecución

```ada
Today           : Day;
Yesterday       : Day;
Retirement_Date : Date;
```

### Objetos Booleanos
- Usar **cláusulas predicado** o **adjetivos**

```ada
User_Is_Available : Boolean;  -- cláusula predicado
List_Is_Empty     : Boolean;  -- cláusula predicado
Empty             : Boolean;  -- adjetivo
Bright            : Boolean;  -- adjetivo
```

### Componentes de Registros
- Usar **sustantivos singulares y generales**

```ada
type Date is record
   Day   : Day_Of_Month;    -- sustantivo general
   Month : Month_Number;    -- sustantivo general
   Year  : Historical_Year; -- sustantivo general
end record;
```

## 2. PAQUETES (PACKAGES)

- Usar **sustantivos o frases nominales** que describan la abstracción
- Implican un nivel más alto de organización que los subprogramas

```ada
package Terminals is        -- sustantivo común
package Text_Routines is    -- frase nominal
package Abstract_Sets is    -- frase nominal con prefijo
```

### Para Paquetes con Tipos Tagged

**Opción 1 (Integrada):**
- Nombrar igual que otros tipos (sin sufijos especiales)
- Usar prefijo `Abstract_` para abstracciones con múltiples implementaciones
- Usar sufijo `_Mixin` para funcionalidad mixta

**Opción 2 (Explícita):**
- Nombrar paquetes según el objeto que representan
- Usar sufijo `_Facet` para paquetes mixin
- Nombrar el tipo principal como `Instance`
- Crear subtipo `Class` para el tipo class-wide

## 3. CONSTANTES

> **⚠️ NOTA DEL EQUIPO:** Por conveniencia y claridad, nuestro equipo usa **MAYÚSCULAS con guiones bajos** para constantes, desviándose del estándar Ada Style Guide que recomienda Mixed_Case.

### Convención del Ada Style Guide (Original)
El Ada Style Guide recomienda:
- Seguir las mismas reglas de capitalización que las variables (Mixed_Case)

```ada
-- Estilo oficial Ada Style Guide
Max_Entries : constant Integer := 400;
Avogadros_Number : constant := 6.022137 * 10**23;
```

### Convención de Nuestro Equipo (MAYÚSCULAS)
Por decisión del equipo, usamos:
- **MAYÚSCULAS con guiones bajos** para constantes
- Facilita la identificación visual inmediata de valores constantes

```ada
-- ✅ Estilo del equipo
MAX_ENTRIES : constant Integer := 400;
AVOGADROS_NUMBER : constant := 6.022137 * 10**23;
```

### Ventajas y Desventajas de MAYÚSCULAS

**Ventajas:**
- ✅ **Identificación inmediata**: Las constantes son visualmente distintas en el código
- ✅ **Familiaridad**: Convención común en C/C++ y otros lenguajes
- ✅ **Búsqueda**: Facilita buscar todas las constantes en el código
- ✅ **Convención histórica**: Usada en muchos proyectos Ada legacy

**Desventajas:**
- ⚠️ **No es idiomático Ada**: Se desvía del estilo recomendado oficialmente
- ⚠️ **Conflicto con acrónimos**: Los acrónimos también se escriben en MAYÚSCULAS
- ⚠️ **Inconsistencia con atributos**: Los atributos como `'First` usan Mixed_Case
- ⚠️ **Menos legible**: MAYÚSCULAS son más difíciles de leer en nombres largos

### Recomendación Técnica
Si el equipo decide usar MAYÚSCULAS para constantes:
1. **Ser 100% consistente** en todo el proyecto
2. **Documentar la decisión** en la guía de estilo del proyecto
3. **Aplicarlo solo a constantes**, no a números nombrados
4. **Evitar nombres muy largos** en MAYÚSCULAS (dificultan la lectura)

### Principios Importantes (Independientes de la Capitalización)
- ✅ Usar valores simbólicos en lugar de literales
- ✅ Usar `Ada.Numerics.Pi` y `Ada.Numerics.e` para constantes matemáticas
- ✅ Mostrar relaciones mediante expresiones estáticas
- ✅ Usar atributos como `'First` y `'Last` en lugar de literales

```ada
-- ✅ CORRECTO: Muestra relaciones (estilo del equipo)
BYTES_PER_PAGE   : constant := 512;
PAGES_PER_BUFFER : constant := 10;
BUFFER_SIZE      : constant := PAGES_PER_BUFFER * BYTES_PER_PAGE;

-- ❌ INCORRECTO: Valor mágico sin contexto
BUFFER_SIZE : constant := 5_120;  -- ¿Por qué 5120?
```

### Números Nombrados (Named Numbers)
- Usar cuando el contexto es verdaderamente universal
- Preferir sobre constantes cuando sea posible
- **Sugerencia:** Mantener Mixed_Case para números nombrados para diferenciarlos

```ada
-- Números nombrados (sin tipo específico)
Avogadros_Number : constant := 6.022137 * 10**23;

-- Constantes tipadas (con tipo específico)
MAX_ENTRIES : constant Integer := 400;
```

## 4. TIPOS Y SUBTIPOS

### Nombres de Tipos
- Usar **sustantivos singulares y generales**
- Describir uno de los valores del subtipo
- NO usar plural ni sufijos como `_Type`

```ada
-- ✅ CORRECTO
type Day is (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday);
type Day_Of_Month is range 0 .. 31;
type Historical_Year is range -6_000 .. 2_500;

-- ❌ INCORRECTO
type Days is ...        -- plural
type Day_Type is ...    -- sufijo innecesario
```

### Subtipos con Sufijos
- Considerar sufijos para tipos de acceso, subrangos o arrays **visibles**

```ada
type Sector_Range  is range 1 .. Number_Of_Sectors;
type Track_Range   is range 1 .. Number_Of_Tracks;
type Surface_Range is range 1 .. Number_Of_Surfaces;

type Track_Map   is array (Sector_Range)  of ...;
type Surface_Map is array (Track_Range)   of Track_Map;
type Disk_Map    is array (Surface_Range) of Surface_Map;
```

### Restricciones
- ❌ **NO reutilizar** nombres de subtipos del paquete `Standard`
- ❌ Para tipos privados, NO usar construcciones únicas de identificadores

## 5. CONVENCIONES DE ESCRITURA

### Capitalización
- **Palabras reservadas:** minúsculas

```ada
begin, end, if, then, else, loop, type, is, range
```

- **Identificadores:** Mixed_Case (cada palabra empieza con mayúscula)

```ada
type Second_Of_Day is range 0 .. 86_400;
Current_Time : Second_Of_Day;
```

- **Abreviaturas y acrónimos:** MAYÚSCULAS

```ada
DOD_STD_MSG_FMT  -- Department_Of_Defense_Standard_Message_Format
TCP_IP_Protocol
HTTP_Server
```

### Guiones Bajos
- Usar guiones bajos para **separar palabras** en nombres compuestos

```ada
Miles_Per_Hour
Entry_Value
Current_Column
User_Input_Buffer
```

### Números Literales

**Agrupación de dígitos:**
- Decimales y octales: grupos de **3 a la izquierda**, **5 a la derecha** del punto
- Hexadecimales: grupos de **4**

```ada
type Maximum_Samples     is range          1 ..  1_000_000;
type Legal_Hex_Address   is range   16#0000# ..   16#FFFF#;
type Legal_Octal_Address is range 8#000_000# .. 8#777_777#;

Avogadro_Number : constant := 6.02216_9E+23;
```

**Notación científica:**
- Hacer la `E` consistentemente mayúscula o minúscula (preferir mayúscula)

```ada
-- ✅ CORRECTO
Value : constant := 1.5E+10;

-- ❌ INCORRECTO: inconsistente
Value1 : constant := 1.5E+10;
Value2 : constant := 2.3e-5;
```

## 6. PROCEDIMIENTOS Y FUNCIONES

### Procedimientos y Entries
- Usar **verbos de acción**

```ada
procedure Get_Next_Token;
procedure Create;
procedure Initialize_System;
entry Read_Data;
```

### Funciones Booleanas
- Usar **cláusulas predicado**

```ada
function Is_Last_Item return Boolean;
function Is_Empty return Boolean;
function Has_More_Data return Boolean;
```

### Funciones No Booleanas
- Usar **sustantivos**

```ada
function Successor return Node;
function Length return Natural;
function Top return Element;
```

### Funciones Genéricas
- Nombrar como si fueran no genéricas
- Hacer el nombre genérico más general que el instanciado

## 7. TAREAS Y OBJETOS PROTEGIDOS

### Tareas
- Usar nombres que impliquen una **entidad activa**

```ada
task Terminal_Resource_Manager is
task Server_Handler is
```

### Objetos Protegidos
- Usar sustantivos descriptivos de los **datos siendo protegidos**

```ada
protected Current_Location is
protected type Guardian is
```

## 8. EXCEPCIONES

- Usar nombres que indiquen el **tipo de problema** que representan

```ada
Invalid_Name      : exception;
Stack_Overflow    : exception;
Node_Already_Defined : exception;
Node_Not_Defined     : exception;
```

## 9. CONSTRUCTORES

- Incluir prefijos como `New`, `Make` o `Create`

```ada
function Make_Square (Center : Cartesian_Coordinates;
                      Side   : Positive)
  return Square;

function Create_Node (Data : Element_Type) return Node_Pointer;

function New_Connection (Host : String; Port : Natural) return Connection;
```

### Paquetes Hijos con Constructores
- Usar nombres indicativos del contenido

```ada
package Shapes.Constructor is
   function Make_Circle (...) return Circle;
   function Make_Square (...) return Square;
end Shapes.Constructor;
```

## 10. TIPOS ENUMERADOS

- Usar tipos enumerados en lugar de códigos numéricos

```ada
-- ✅ CORRECTO
type Color is (Blue, Red, Green, Yellow);

-- ❌ INCORRECTO
Blue   : constant := 1;
Red    : constant := 2;
Green  : constant := 3;
Yellow : constant := 4;
```

- Solo si es absolutamente necesario, usar cláusulas de representación

```ada
type Color is (Blue, Red, Green, Yellow);

for Color use (Blue   => 1,
               Red    => 2,
               Green  => 3,
               Yellow => 4);
```

## 11. ABREVIATURAS

### Reglas Generales
- ✅ Usar sinónimos cortos en lugar de abreviaturas
- ✅ Mantener una lista de abreviaturas aceptadas del proyecto
- ✅ Usar abreviaturas bien aceptadas en el dominio de aplicación
- ✅ La abreviatura debe ahorrar **muchos caracteres**
- ❌ NO usar abreviaturas ambiguas

```ada
-- ✅ CORRECTO: sinónimo corto
Time_Of_Receipt

-- ❌ INCORRECTO: abreviatura ambigua
Recd_Time  -- ¿Received? ¿Recorded?
R_Time     -- ¿R de qué?
Temp       -- ¿Temperature? ¿Temporary?

-- ✅ ACEPTABLE: abreviatura del dominio, ahorra muchos caracteres
DOD_STD_MSG_FMT  -- Department_Of_Defense_Standard_Message_Format
```

## 12. PRINCIPIOS CLAVE

1. **Auto-documentación**: Los nombres deben ser auto-explicativos
2. **Dominio de aplicación**: Usar términos del dominio
3. **Evitar duplicación**: No usar el mismo nombre para diferentes tipos de identificadores
4. **Legibilidad sobre brevedad**: Claridad es más importante que nombres cortos
5. **Consistencia**: Mantener consistencia en todo el proyecto
6. **Rango restringido**: Limitar el rango de tipos escalares tanto como sea posible
7. **Expresiones estáticas**: Mostrar relaciones entre valores con expresiones

## Ejemplos de Código Bien Nombrado

```ada
package Text_Buffers is

   type Line_Count is range 1 .. 10_000;
   type Column_Count is range 1 .. 132;

   type Cursor_Position is record
      Line   : Line_Count;
      Column : Column_Count;
   end record;

   -- Objeto con nombre descriptivo
   Current_Position : Cursor_Position;

   -- Constantes con relaciones explícitas
   Max_Line_Length  : constant := 132;
   Tab_Size         : constant := 8;
   Indent_Size      : constant := Tab_Size / 2;

   -- Función booleana con cláusula predicado
   function Is_End_Of_Buffer return Boolean;

   -- Procedimiento con verbo de acción
   procedure Move_Cursor_To (New_Position : Cursor_Position);

   -- Excepción descriptiva
   Buffer_Overflow : exception;

end Text_Buffers;
```

## Referencias

- **Ada Style Guide (Wikibooks)**: https://en.wikibooks.org/wiki/Ada_Style_Guide/
- **Readability Chapter**: https://en.wikibooks.org/wiki/Ada_Style_Guide/Readability
- **Ada Reference Manual 2012**: http://www.ada-auth.org/standards/ada12.html
