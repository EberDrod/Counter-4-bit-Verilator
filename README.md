# VerilatorLab

### Digital Logic Design & RTL Verification

Laboratorio de diseño digital, simulación RTL y verificación de hardware utilizando **SystemVerilog, Verilator y herramientas de análisis de señales digitales**.

El proyecto está desarrollado inicialmente en macOS con arquitectura Apple Silicon y está orientado al aprendizaje práctico de electrónica digital, diseño de FPGA y arquitectura de computadoras.

---

## 1. Descripción

VerilatorLab es un entorno de experimentación para diseñar, simular y verificar circuitos digitales mediante lenguajes de descripción de hardware (HDL).

Cada ejercicio incluye:

- Implementación RTL en SystemVerilog.
- Testbench de verificación.
- Compilación y simulación con Verilator.
- Generación de archivos VCD.
- Análisis de señales digitales.
- Validación funcional del circuito.

El objetivo es avanzar progresivamente desde compuertas lógicas y circuitos combinacionales hasta sistemas digitales complejos.

## 2. Tecnologías

| Tecnología | Propósito |
|---|---|
| SystemVerilog | Descripción de hardware |
| Verilator 5.052 | Compilación y simulación RTL |
| C++20 | Ejecución del simulador generado |
| GTKWave | Visualización de señales |
| Surfer | Visualizador alternativo de ondas |
| Visual Studio Code | Editor de desarrollo |
| Homebrew | Administración de dependencias |
| macOS | Entorno de desarrollo inicial |

### Entorno de referencia

- Plataforma: Apple Silicon (M1 Pro).
- Sistema operativo: macOS.
- Simulador: Verilator 5.052.
- Lenguaje HDL: SystemVerilog.
- Formato de trazas: VCD.

## 3. Arquitectura del proyecto

Estructura actual:

```text
VerilatorLab/
│
├── README.md
│
├── counter.sv
├── tb_counter.sv
│
├── mux2x1.sv
├── tb_mux2x1.sv
│
├── obj_dir/
│   ├── Vtb_counter
│   └── ...
│
├── counter.vcd
└── mux2x1.vcd
```

Los archivos `.vcd` se generan al ejecutar sus respectivos testbenches.

El directorio `obj_dir` contiene archivos de compilación y ejecutables generados por Verilator.

**Nota:** cuando se compilan diferentes testbenches utilizando el mismo directorio de salida, Verilator conserva artefactos de las distintas compilaciones. Se recomienda utilizar directorios independientes para cada ejercicio.

## 4. Instalación

### Requisitos

Instalar las herramientas de desarrollo de Apple:

```bash
xcode-select --install
```

Instalar Verilator:

```bash
brew install verilator
```

Verificar la instalación:

```bash
verilator --version
```

Instalar herramientas adicionales:

```bash
brew install icarus-verilog
brew install yosys
brew install graphviz
```

Para visualizar ondas digitales, instalar GTKWave o Surfer mediante un paquete compatible con la versión de macOS.

## 5. Flujo de desarrollo

El proceso de simulación está organizado en seis etapas:

```text
RTL Design
    |
    v
SystemVerilog
    |
    v
Testbench
    |
    v
Verilator
    |
    v
C++ Simulation
    |
    v
VCD Waveforms
    |
    v
Verification
```

### Verificación estática

```bash
verilator --lint-only \
  --timing \
  -Wall \
  --top-module tb_counter \
  counter.sv tb_counter.sv
```

### Compilación

```bash
verilator --binary \
  --timing \
  --trace \
  -Wall \
  --top-module tb_counter \
  --Mdir obj_dir/counter \
  counter.sv tb_counter.sv
```

### Ejecución

```bash
./obj_dir/counter/Vtb_counter
```

### Visualización

```bash
gtkwave counter.vcd
```

O:

```bash
surfer counter.vcd
```

---

# 6. Ejercicio 01 — Binary Counter

## Descripción

Implementación de un contador binario de cuatro bits.

El circuito incrementa su valor en cada flanco positivo del reloj y dispone de una entrada de reinicio asíncrono activo en alto.

### Características

| Parámetro | Valor |
|---|---|
| Arquitectura | Contador binario |
| Resolución | 4 bits |
| Estados | 16 |
| Rango | 0–15 |
| Reloj de prueba | 100 MHz |
| Período | 10 ns |
| Reset | Asíncrono, activo en alto |

### Implementación RTL

Archivo: `counter.sv`

```systemverilog
`timescale 1ns/1ps

module counter (
    input  logic       clk,
    input  logic       rst,
    output logic [3:0] count
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            count <= 4'b0000;
        else
            count <= count + 1'b1;
    end

endmodule
```

### Funcionamiento

El contador sigue la secuencia:

```text
0000
0001
0010
0011
0100
0101
0110
0111
1000
1001
1010
1011
1100
1101
1110
1111
0000
```

La frecuencia del reloj se calcula mediante:

\[
f = \frac{1}{T}
\]

Para un período de 10 ns:

\[
f = 100\ MHz
\]

### Verificación

El testbench genera un reloj, aplica una señal de reset y observa veinte ciclos de conteo.

Archivo de pruebas:

`tb_counter.sv`

Resultado verificado:

- Compilación exitosa con Verilator 5.052.
- Simulación funcional de 210 ns.
- Conteo de 0 a 15.
- Reinicio del conteo después de 15.
- Generación del archivo `counter.vcd`.

---

# 7. Ejercicio 02 — Multiplexor 2:1

## Descripción

Implementación de un multiplexor de dos entradas de un bit.

El circuito selecciona una de dos señales de entrada utilizando una señal de control.

### Entradas y salidas

| Señal | Dirección | Descripción |
|---|---|---|
| A0 | Input | Entrada de datos 0 |
| A1 | Input | Entrada de datos 1 |
| S | Input | Selector |
| Y | Output | Salida |

### Ecuación booleana

\[
Y = \overline{S}A0 + SA1
\]

Cuando:

- S = 0, entonces Y = A0.
- S = 1, entonces Y = A1.

### Tabla de verdad

| S | A0 | A1 | Y |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

### Implementación RTL

Archivo: `mux2x1.sv`

```systemverilog
`timescale 1ns/1ps

module mux2x1 (
    input  logic A0,
    input  logic A1,
    input  logic S,
    output logic Y
);

    assign Y = S ? A1 : A0;

endmodule
```

### Compilación

```bash
verilator --binary \
  --timing \
  --trace \
  -Wall \
  --top-module tb_mux2x1 \
  --Mdir obj_dir/mux2x1 \
  mux2x1.sv tb_mux2x1.sv
```

### Ejecución

```bash
./obj_dir/mux2x1/Vtb_mux2x1
```

### Resultado esperado

El testbench verifica las ocho combinaciones posibles de las entradas.

```text
=== MUX 2:1 TEST ===

S=0 A0=0 A1=0 Y=0
S=0 A0=0 A1=1 Y=0
S=0 A0=1 A1=0 Y=1
S=0 A0=1 A1=1 Y=1

S=1 A0=0 A1=0 Y=0
S=1 A0=0 A1=1 Y=1
S=1 A0=1 A1=0 Y=0
S=1 A0=1 A1=1 Y=1

ALL 8 TESTS PASSED
```

Estado: implementación preparada; ejecución y resultados pendientes de confirmar.

### Archivo VCD

Después de ejecutar correctamente el testbench:

```bash
ls -lh mux2x1.vcd
```

Para visualizarlo:

```bash
surfer mux2x1.vcd
```

---

# 8. Análisis de señales digitales

Los archivos VCD (Value Change Dump) almacenan los cambios de estado de las señales durante la simulación.

Permiten analizar:

- Flancos positivos y negativos.
- Períodos de reloj.
- Frecuencia de señales.
- Transiciones de buses.
- Cambios de estado.
- Relaciones temporales entre señales.
- Comportamiento de circuitos combinacionales y secuenciales.

### Ejemplo

```systemverilog
initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb_counter);

    #200;
    $finish;
end
```

La opción `--trace` de Verilator habilita la generación de trazas.

El archivo VCD se escribe cuando se ejecuta el simulador, no durante la compilación.

---

# 9. Solución de problemas

## TIMESCALEMOD

Ocurre cuando algunos módulos tienen una escala de tiempo declarada y otros no.

Solución:

```systemverilog
`timescale 1ns/1ps
```

Agregar al inicio de los módulos correspondientes.

## PROCASSINIT

Puede aparecer cuando una variable se inicializa en su declaración y también se modifica desde un proceso.

En un generador de reloj de testbench puede utilizarse:

```systemverilog
logic clk;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
```

## EOFNEWLINE

Indica que falta un salto de línea al final del archivo.

Verificación:

```bash
tail -c 1 counter.sv | od -An -t x1
```

El resultado correcto es:

```text
0a
```

## No se genera el archivo VCD

Verificar que el testbench contenga:

```systemverilog
$dumpfile("counter.vcd");
$dumpvars(0, tb_counter);
```

Compilar con:

```bash
verilator --binary --timing --trace \
  --top-module tb_counter \
  counter.sv tb_counter.sv
```

Ejecutar:

```bash
./obj_dir/Vtb_counter
```

Buscar el archivo:

```bash
find . -type f -name "*.vcd"
```

---

# 10. Roadmap

El proyecto crecerá progresivamente mediante ejercicios de complejidad incremental.

| Fase | Módulo | Objetivo |
|---|---|---|
| 01 | Binary Counter | Lógica secuencial |
| 02 | MUX 2:1 | Selección de datos |
| 03 | Decoder | Decodificación binaria |
| 04 | Encoder | Codificación digital |
| 05 | Flip-Flops | Almacenamiento de estados |
| 06 | Shift Register | Registros de desplazamiento |
| 07 | ALU 8-bit | Operaciones aritméticas y lógicas |
| 08 | FSM Controller | Máquinas de estados |
| 09 | UART | Comunicación serial |
| 10 | SPI Controller | Comunicación síncrona |
| 11 | I2C Controller | Comunicación entre dispositivos |
| 12 | Memory Controller | Arquitectura de memoria |
| 13 | RISC-V Core | Arquitectura de procesadores |

## 11. Objetivos de aprendizaje

Al completar los ejercicios se espera desarrollar competencias en:

1. Diseño de circuitos combinacionales.
2. Diseño de circuitos secuenciales.
3. Descripción de hardware mediante SystemVerilog.
4. Construcción de testbenches.
5. Simulación RTL.
6. Verificación funcional.
7. Análisis temporal de señales.
8. Diseño modular de hardware.
9. Fundamentos de FPGA.
10. Arquitectura de computadoras.

## 12. Buenas prácticas

Para mantener la calidad del proyecto:

- Utilizar `-Wall` durante la compilación.
- Corregir las advertencias del compilador.
- Separar el diseño RTL de los testbenches.
- Utilizar nombres descriptivos.
- Documentar las entradas y salidas.
- Automatizar las verificaciones cuando sea posible.
- Mantener las simulaciones reproducibles.
- Utilizar directorios de compilación independientes.
- Evitar incluir archivos generados en el repositorio.

### Archivo .gitignore recomendado

```gitignore
# Verilator
obj_dir/
*.vcd
*.fst

# macOS
.DS_Store

# Editors
.vscode/
.idea/

# Compiled objects
*.o
*.a
*.d
```

Los archivos VCD pueden conservarse como evidencia de pruebas cuando sea necesario, pero normalmente no se versionan.

---

## 13. Estado del proyecto

| Componente | Estado |
|---|---|
| Entorno macOS | Configurado |
| Verilator 5.052 | Instalado |
| Compilación RTL | Funcionando |
| Counter 4-bit | Simulado |
| Generación VCD | Verificada |
| MUX 2:1 | Preparado para verificación |
| Visualización de ondas | Pendiente de confirmar |
| Automatización de pruebas | Planeada |

## 14. Licencia

Pendiente de definir.

---

**VerilatorLab — Digital Logic Design & RTL Verification**

*From logic gates to processor architecture.*
