# Verificación Formal con Ada/SPARK — Sistema Bancario

Este documento describe la verificación formal del núcleo del sistema bancario
mediante **SPARK** y **GNATprove**, siguiendo la estrategia estándar de
verificación por niveles (*stone → bronze → silver → gold*).

El objetivo NO fue convertir todo el proyecto a SPARK, sino **aislar un núcleo
verificable** (los tipos de dominio y su aritmética monetaria) y demostrar sobre
él la ausencia de errores en tiempo de ejecución y la corrección de sus
contratos, dejando fuera —de forma explícita y documentada— la capa de servicios
con punteros y despacho dinámico (patrones State/Strategy).

---

## 1. Resultado global

Verificación ejecutada con `gnatprove --level=2` (FSF 16.1.0, prover CVC5 + Alt-Ergo):

| Categoría de VC            | Total | Probadas | Sin probar |
|----------------------------|:-----:|:--------:|:----------:|
| Run-time Checks (AoRTE)    |  329  |   329    |     0      |
| Functional Contracts       |  152  |   152    |     0      |
| Termination (flow)         |   14  |    14    |     0      |
| **Total**                  | **495** | **495** |   **0**    |

- **495 condiciones de verificación (VCs), 495 probadas, 0 sin probar, 0 justificadas.**
- 14 VCs resueltas por análisis de flujo, 481 por los provers automáticos.
- Sin advertencias en las cuatro categorías objetivo: **precondiciones,
  postcondiciones, invariantes y desbordamientos aritméticos (overflow / range checks).**

Los checks *medium* residuales de instanciaciones de `Ada.Strings.Bounded`
(`initial condition`) que aparecían en iteraciones previas fueron eliminados al
excluir de SPARK los getters/constructores que manipulan `Bounded_String`.

---

## 2. Paquetes verificados formalmente (núcleo SPARK)

Todos alcanzan **nivel gold**: análisis de flujo sin errores + todos los checks
de runtime y todos los contratos funcionales probados.

| Paquete             | Ubicación                              | Subprogramas SPARK | Nivel |
|---------------------|----------------------------------------|:------------------:|:-----:|
| `Length`            | `src/shared/length.ads`                | 1/1                | gold  |
| `Cuentas`           | `src/model/cuentas/cuentas.*`          | 12                 | gold  |
| `Cuenta_Ahorros`    | `src/model/cuentas/cuenta_ahorros.*`   | 6/6                | gold  |
| `Cuenta_Corriente`  | `src/model/cuentas/cuenta_corriente.*` | 6/6                | gold  |
| `Tarjeta_Credito`   | `src/model/tarjetas/tarjeta_credito.*` | 16                 | gold  |
| `Movimientos`       | `src/model/movimientos/movimientos.*`  | 13                 | gold  |
| `Transaccion` (spec)| `src/model/transaccion/transaccion.ads`| tipos expuestos    | gold  |
| `Resultado_Operacion`| `src/shared/resultado_operacion.*`    | 2/2                | gold  |

> Correspondencia con la escala SPARK:
> **stone** = compila · **bronze** = flujo sin errores · **silver** = sin
> errores de runtime (AoRTE) · **gold** = contratos funcionales probados.
> El núcleo llega a **gold** porque, además del silver (0 overflow/range),
> se prueban todas las pre/postcondiciones y predicados.

---

## 3. Invariantes y contratos añadidos

### 3.1 `Cuentas` (tipo base `Cuenta_Type`, tagged)
- `Acreditar`: `Pre'Class` (monto ≥ 0 y sin overflow) + `Post'Class`
  (`saldo = saldo'Old + monto`).
- `Debitar`: `Pre'Class` (monto ≥ 0, fondos suficientes, `saldo - monto ≥ MIN_SALDO`)
  + `Post'Class` (`saldo = saldo'Old - monto`).
- `Set_Saldo`: `Pre'Class => Saldo ≥ MIN_SALDO` (piso universal −2000) +
  `Post'Class`. `Set_Estado`: `Post'Class`.
- Getters `Get_Saldo`/`Get_Estado` implementados como **expression functions** en
  la parte privada para que el prover vea su valor y cierre las postcondiciones.

### 3.2 `Cuenta_Ahorros` (deriva de `Cuenta_Type`)
- Subtipo `Saldo_Ahorros_Type` con `Dynamic_Predicate => ≥ 0.0`: garantiza la
  no-negatividad del saldo **en la frontera de construcción**.

### 3.3 `Cuenta_Corriente` (deriva de `Cuenta_Type`)
- Cota de sobregiro `saldo ≥ −Límite_Sobregiro` garantizada en construcción
  (`Crear_Cuenta_Corriente` con `Pre => Saldo ≥ −MAX_LIMITE_SOBREGIRO`).

### 3.4 `Tarjeta_Credito`
- Invariante de dominio **`Saldo_Utilizado ≥ 0`** expresado como **subtipo del
  campo** (`Deuda_Type is Saldo_Type range 0.0 .. Saldo_Type'Last`).
- `Limite_Credito_Type` redefinido como **subtipo** de `Saldo_Type` (evita la
  conversión entre tipos fixed-point incompatibles, no soportada por SPARK).
- `Incrementar_Deuda`/`Reducir_Deuda`: `Pre'Class`/`Post'Class` exactas sobre la deuda.
- `Aplicar_Interes`: `Pre'Class` (deuda en `(0, Límite]`) + `Post'Class` de **cota**
  (`Saldo_Utilizado ≥ Saldo_Utilizado'Old`: el interés nunca reduce la deuda).
  El cálculo se reescribió a **aritmética fixed-point pura** (`deuda * 22 / 1200`,
  22 % anual prorrateado mensual) para que sea verificable.
- `Get_Credito_Disponible`, `Esta_Al_Limite`, `Set_Limite_Credito`: `Post'Class`/`Pre'Class`.

### 3.5 `Movimientos`
- Invariante de dominio del monto **`(0, MAX_MONTO_TRANSACCION]`** expresado como
  **subtipo del campo** `Monto` (`Monto_Valido_Type range 0.01 .. 5000.00`; como
  `delta = 0.01`, `[0.01, 5000]` equivale a `(0, 5000]`).

### 3.6 `Resultado_Operacion`
- Corregida la postcondición de `Crear_Mensaje` (afirmaba erróneamente ausencia de
  espacios) y eliminado un overflow de índice; ahora se prueba a `--level=2`.

---

## 4. Decisiones y limitaciones de SPARK encontradas (hallazgos)

Estos puntos son resultados relevantes para la sección de discusión de la tesis:

1. **`Type_Invariant` no es aplicable a los tipos de cuenta/tarjeta.** SPARK RM
   7.3.2 prohíbe `Type_Invariant` en tipos **tagged**, y en el tipo `private`
   no-tagged (`Movimiento_Type`) restringe llamar getters "boundary" (7.3.2(5)) y
   exige probar el valor por defecto. Por ello los invariantes de saldo/deuda/monto
   se expresan con **subtipos con predicado/rango** y con **pre/postcondiciones**,
   mecanismos equivalentes y verificables.

2. **LSP impide fortalecer precondiciones por despacho.** Las cuentas de ahorro y
   corriente no pueden imponer `saldo ≥ 0` / `saldo ≥ −límite` como `Pre'Class` más
   estricta que la del tipo base sin violar el Principio de Sustitución de Liskov
   (Ada lo rechaza: *"illegal class-wide precondition on overriding operation"*).
   La precondición despachante usa el **piso universal `MIN_SALDO`**; las cotas por
   subclase se garantizan en la **frontera de construcción**.

3. **SPARK no soporta mezcla fixed-point ↔ Float ni conversión entre tipos
   fixed-point distintos.** Se resolvió reescribiendo el interés en fixed-point puro
   y unificando `Limite_Credito_Type` como subtipo de `Saldo_Type`.

4. **`pragma Elaborate_Body`** fue necesario en los tipos tagged con expression
   functions primitivas (regla de *early call region*, error E0003).

---

## 5. Componentes fuera de SPARK (y por qué)

Marcados explícitamente con `SPARK_Mode => Off` y un comentario `-- FRONTERA SPARK`
en cada punto de corte:

| Componente | Motivo |
|---|---|
| `src/logic/**` (todos los `*_service`, `*_resultado`) | Punteros `access`, despacho dinámico, patrones State/Strategy |
| `main.adb` | Entrada con I/O (`Ada.Text_IO`), punteros y despacho |
| `Clientes` | Basado en `Ada.Strings.Bounded` y colecciones |
| `Cuenta_Estado` | Patrón State con despacho dinámico |
| `Cuenta_Resultado`, `Transaccion_Tarjeta` | Soporte de servicios / estrategias con despacho |
| `Transaccion` (**body**) | Ejecución de estrategias despachando sobre `Cuenta_Type'Class` |

**Cortes por subprograma** dentro de paquetes SPARK-On (frontera fina, comentada):
los **constructores** (usan `Ada.Calendar.Clock` y un contador global mutable), los
**getters de `String`/fecha** (manipulan `Bounded_String` / `Ada.Calendar.Time`) y
`Esta_Vencida` (usa `Clock`).

---

## 6. Cómo reproducir la verificación desde cero

### Requisitos
- [Alire](https://alire.ada.dev/) (`alr`) instalado.
- Toolchain: `gprbuild` + `gnat_native` (se seleccionan con `alr toolchain --select`).

### Paso 1 — Instalar GNATprove
```
alr with gnatprove          # añade gnatprove 16.1.0 (FSF) como dependencia
alr exec -- gnatprove --version
```

### Paso 2 — Compilar
```
alr build
```

### Paso 3 — Verificar
```
alr exec -- gnatprove -P sistema_bancario.gpr --level=1 --report=all   # iteración rápida
alr exec -- gnatprove -P sistema_bancario.gpr --level=2 --report=all   # objetivo final
```

El resumen de VCs queda en `obj/development/gnatprove/gnatprove.out`.

### ⚠️ Nota de entorno (Windows)
En este equipo `gprconfig` **crashea** (`ENCODING_ERROR`) por las variables de
entorno `OneDrive`/`OneDriveCommercial` (rutas con caracteres especiales). Antes de
compilar/verificar hay que limpiarlas. El repo incluye `alr_fix.bat` que lo hace
(`chcp 65001` + borra esas variables). Alternativamente, desde una shell POSIX:
```
OneDrive="" OneDriveCommercial="" alr build
OneDrive="" OneDriveCommercial="" alr exec -- gnatprove -P sistema_bancario.gpr --level=2 --report=all
```

---

## 7. Verificar solo un paquete del núcleo

```
alr exec -- gnatprove -P sistema_bancario.gpr --level=2 -u cuentas.adb --report=all
alr exec -- gnatprove -P sistema_bancario.gpr --level=2 -u tarjeta_credito.adb --report=all
```
