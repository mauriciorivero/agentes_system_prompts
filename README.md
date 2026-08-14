# Equipo de Agentes de Ingeniería de Software — SWEBOK v4.0

Colección de system prompts para un equipo de agentes de IA especializados en las disciplinas de ingeniería de software definidas por el **SWEBOK Guide V4.0** (IEEE Computer Society). Cada agente actúa como un especialista senior en su área de conocimiento, con roles, metodologías y protocolos de interacción claramente definidos.

Este repositorio está listo para usarse como **subagentes de Claude Code**: clónalo, ejecuta un script, y tendrás siete especialistas disponibles en cualquier proyecto.

---

## Tabla de contenidos

- [El equipo](#el-equipo)
- [Instalación rápida](#instalación-rápida)
- [Instalación manual](#instalación-manual)
- [Configuración de cada agente (copiar y pegar)](#configuración-de-cada-agente-copiar-y-pegar)
- [Cómo invocar a los agentes](#cómo-invocar-a-los-agentes)
- [Ejemplos en proyectos reales](#ejemplos-en-proyectos-reales)
- [Reglas de trabajo del equipo](#reglas-de-trabajo-del-equipo)
- [Personalización](#personalización)
- [Base de conocimiento](#base-de-conocimiento)

---

## El equipo

| # | Agente instalado | Rol | System prompt fuente |
|---|---|---|---|
| 00 | `smith-gobernador` | Gobernador / orquestador y revisor supremo | [`agente-00-Smith.md`](system-prompts/agente-00-Smith.md) |
| 01 | `analista-requerimientos` | Especialista en Requerimientos | [`agente-01-especialista-requerimientos.md`](system-prompts/agente-01-especialista-requerimientos.md) |
| 02 | `arquitecto-software` | Arquitecto de Software | [`agente-02-arquitecto-software_v2.md`](system-prompts/agente-02-arquitecto-software_v2.md) |
| 03 | `disenador-software` | Especialista en Diseño de Software | [`agente-03-especialista-diseno-software.md`](system-prompts/agente-03-especialista-diseno-software.md) |
| 04 | `constructor-software` | Especialista en Construcción de Software | [`agente-04-especialista-construccion-software.md`](system-prompts/agente-04-especialista-construccion-software.md) |
| 05 | `tester-software` | Especialista en Pruebas de Software | [`agente-05-especialista-pruebas-software.md`](system-prompts/agente-05-especialista-pruebas-software.md) |
| 06 | `devops-operaciones` | Especialista en DevOps / Operaciones | [`agente-06-especialista-devops.md`](system-prompts/agente-06-especialista-devops.md) |

> **Nota sobre el Agente 02.** Existen dos versiones del system prompt del arquitecto. La instalación usa por defecto **`_v2`**, que suma los principios de *Clean Architecture* de Robert C. Martin a la base SWEBOK. Si prefieres la v1 (SWEBOK puro), instala con `./install.sh --arch-v1`.

### Descripción de los agentes

**Agente 00 — Gobernador (Smith).** El orquestador y revisor supremo. No ejecuta trabajo especializado: revisa, aprueba y coordina el trabajo de los demás. Emite decisiones formales (`APROBADO`, `APROBADO CON OBSERVACIONES`, `RECHAZADO`, `BLOQUEADO — CONFLICTO INTER-AGENTE`) y mantiene la trazabilidad end-to-end de los artefactos. Es el único que puede declarar un artefacto válido para continuar a la siguiente fase.

**Agente 01 — Requerimientos.** Elicitación, análisis, especificación, validación y gestión de requerimientos. Produce requerimientos funcionales y no funcionales no ambiguos, testeables y trazables. Aplica user story mapping, Given-When-Then (BDD/ATDD), modelos UML/SysML y análisis de conflictos entre stakeholders.

**Agente 02 — Arquitectura.** Decisiones estructurales de alto nivel que determinan la forma del sistema y sus atributos de calidad. Produce vistas arquitectónicas (C4, 4+1), Architecture Decision Records (ADRs) y análisis de trade-offs con métodos como ATAM. Domina estilos arquitectónicos (Microservices, Event-Driven, Hexagonal, CQRS, Serverless) y, en la v2, la separación política/detalle y la regla de dependencia de Clean Architecture.

**Agente 03 — Diseño.** Traduce la arquitectura en diseño detallado de módulos, interfaces y contratos. Aplica SOLID, patrones de diseño (GoF y arquitectónicos), alta cohesión y bajo acoplamiento. Produce diagramas de clases, secuencia e interacción, asegurando que el diseño sea testeable por construcción.

**Agente 04 — Construcción.** Transforma el diseño en código de alta calidad: gestión de complejidad, complejidad ciclomática, deuda técnica, gestión de dependencias, secure coding y estrategias de integración.

**Agente 05 — Pruebas.** Planifica y ejecuta la estrategia de pruebas. Distingue faults, failures y errors, y diseña suites funcionales y no funcionales (rendimiento, seguridad, usabilidad). Gestiona automatización de regresión, criterios de entrada/salida y trazabilidad caso de prueba ↔ requerimiento.

**Agente 06 — DevOps.** Cierra el ciclo entre desarrollo y producción: pipelines CI/CD, Infrastructure as Code, estrategias de despliegue (blue/green, canary, rolling), observabilidad, SLOs/SLIs/SLAs y gestión de incidentes.

---

## Instalación rápida

Requisitos: [Claude Code](https://claude.com/claude-code) instalado y `bash`.

```bash
git clone https://github.com/mauriciorivero/agentes_system_prompts.git
cd agentes_system_prompts
chmod +x install.sh
./install.sh
```

Esto genera los siete archivos de agente en `~/.claude/agents/`, disponibles en **todos** tus proyectos.

### Opciones del instalador

| Comando | Efecto |
|---|---|
| `./install.sh` | Instala en `~/.claude/agents/` — agentes **personales**, visibles en todos tus proyectos |
| `./install.sh --project` | Instala en `./.claude/agents/` del directorio actual — agentes **del proyecto**, versionables en git y compartidos con tu equipo |
| `./install.sh --dest DIR` | Instala en un directorio concreto |
| `./install.sh --arch-v1` | Usa la v1 del arquitecto (SWEBOK puro, sin Clean Architecture) |

Para instalar el equipo dentro de un proyecto de trabajo y que tus compañeros lo hereden al hacer `git pull`:

```bash
cd /ruta/a/tu/proyecto
/ruta/a/agentes_system_prompts/install.sh --project
git add .claude/agents && git commit -m "chore: agrega equipo de agentes SWEBOK"
```

### Verificar la instalación

Reinicia Claude Code (o abre una sesión nueva) y ejecuta:

```
/agents
```

Deberías ver los siete agentes listados. Si no aparecen, comprueba que los archivos existan y que el frontmatter YAML esté intacto:

```bash
ls ~/.claude/agents/
head -6 ~/.claude/agents/arquitecto-software.md
```

> **Precedencia:** si un agente con el mismo `name` existe en `.claude/agents/` del proyecto y en `~/.claude/agents/`, gana el del proyecto.

---

## Instalación manual

Si prefieres no ejecutar el script, o quieres entender exactamente qué hace, cada agente es un único archivo Markdown con esta estructura:

```markdown
---
name: <identificador-del-agente>
description: <cuándo usar este agente — Claude lo lee para delegar automáticamente>
tools: <lista de herramientas separadas por comas>
model: opus
---

<contenido completo del system prompt correspondiente>

---

## Alcance de Archivos y Permisos

<lista de artefactos que este agente sí crea o modifica>
```

El procedimiento manual para cada uno de los siete agentes:

1. Crea el directorio destino: `mkdir -p ~/.claude/agents`
2. Crea el archivo con el nombre indicado en la tabla de la sección siguiente.
3. Pega el bloque de frontmatter YAML de esa sección al principio del archivo.
4. Pega debajo el contenido completo del system prompt fuente correspondiente (`system-prompts/agente-XX-*.md`).
5. Opcionalmente añade al final la sección *Alcance de Archivos y Permisos* que se indica para ese agente.

También puedes crear agentes de forma interactiva desde Claude Code con el comando `/agents`, que te guía por el proceso y te deja pegar el system prompt.

---

## Configuración de cada agente (copiar y pegar)

Los siete bloques de frontmatter listos para usar. La lista de `tools` da a cada agente **lectura y escritura** sobre los archivos de su dominio, más ejecución de comandos y búsqueda web.

### 1. `smith-gobernador.md` — Agente 00

Cuerpo: [`system-prompts/agente-00-Smith.md`](system-prompts/agente-00-Smith.md)

```yaml
---
name: smith-gobernador
description: Gobernador de Ingenieria de Software (Agente 00, SWEBOK v4.0). Orquestador y revisor supremo del equipo: revisa, aprueba o rechaza artefactos de los agentes 01-06, valida coherencia y trazabilidad end-to-end, y decide que fase del ciclo de vida activar. USALO como punto de entrada de cualquier proyecto de ingenieria de software y siempre que un artefacto necesite quality gate final antes de pasar a la siguiente fase.
model: opus
---
```

> Smith **no lleva** campo `tools` a propósito: al omitirlo hereda todas las herramientas de la sesión, incluida la de delegación en otros subagentes. Es lo que necesita para orquestar al equipo.

Alcance de archivos sugerido: actas de revisión y dictámenes formales, matrices de trazabilidad entre fases, planes de gobernanza y quality gates, registros de conflictos inter-agente, documentos índice del proyecto.

### 2. `analista-requerimientos.md` — Agente 01

Cuerpo: [`system-prompts/agente-01-especialista-requerimientos.md`](system-prompts/agente-01-especialista-requerimientos.md)

```yaml
---
name: analista-requerimientos
description: Especialista Senior en Requerimientos de Software (Agente 01, SWEBOK v4.0 Cap. 1). Elicita, analiza, especifica, valida y gestiona requerimientos funcionales y no funcionales. Produce SRS, user stories, criterios de aceptacion Given-When-Then, modelos UML/SysML y matrices de trazabilidad. USALO al inicio de un proyecto, ante requerimientos ambiguos o no testeables, o para analizar conflictos entre stakeholders.
tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch, TodoWrite, NotebookEdit
model: opus
---
```

Alcance de archivos: SRS, backlogs y story maps; criterios de aceptación y escenarios BDD (`.feature`); modelos de dominio y diagramas UML/SysML; matrices de trazabilidad requerimiento → origen → stakeholder; glosarios y catálogos de stakeholders.

### 3. `arquitecto-software.md` — Agente 02

Cuerpo: [`system-prompts/agente-02-arquitecto-software_v2.md`](system-prompts/agente-02-arquitecto-software_v2.md) (o la v1 si lo prefieres)

```yaml
---
name: arquitecto-software
description: Arquitecto de Software Senior (Agente 02, SWEBOK v4.0 Cap. 2 + Clean Architecture de Robert C. Martin). Define estructura de alto nivel, limites de componentes, politicas vs. detalles, vistas C4/4+1, ADRs y analisis de trade-offs (ATAM) sobre atributos de calidad. USALO para decidir estilo arquitectonico, evaluar decisiones de alto costo de reversion, definir limites entre capas o revisar la arquitectura de un sistema existente.
tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch, TodoWrite, NotebookEdit
model: opus
---
```

Alcance de archivos: documentos de arquitectura y vistas C4 / 4+1; ADRs y registros de trade-offs; definición de límites de módulos, capas, puertos y adaptadores; configuración que hace cumplir límites arquitectónicos (linters de dependencias, module boundaries); escenarios de atributos de calidad y utility trees.

### 4. `disenador-software.md` — Agente 03

Cuerpo: [`system-prompts/agente-03-especialista-diseno-software.md`](system-prompts/agente-03-especialista-diseno-software.md)

```yaml
---
name: disenador-software
description: Especialista Senior en Diseno de Software (Agente 03, SWEBOK v4.0 Cap. 3). Traduce arquitectura y requerimientos en diseno detallado: modulos, interfaces, contratos, algoritmos y estructuras de datos, aplicando SOLID, patrones GoF, alta cohesion y bajo acoplamiento. USALO entre la arquitectura y la codificacion, para disenar un modulo o API nuevos, o para evaluar cohesion/acoplamiento de un diseno existente.
tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch, TodoWrite, NotebookEdit
model: opus
---
```

Alcance de archivos: documentos HLD y LLD por módulo; diagramas de clases, secuencia, estados e interacción; contratos de interfaces y APIs (OpenAPI, esquemas, pre/postcondiciones e invariantes); definiciones de tipos e interfaces en código; registro de patrones aplicados.

### 5. `constructor-software.md` — Agente 04

Cuerpo: [`system-prompts/agente-04-especialista-construccion-software.md`](system-prompts/agente-04-especialista-construccion-software.md)

```yaml
---
name: constructor-software
description: Especialista Senior en Construccion de Software (Agente 04, SWEBOK v4.0 Cap. 4). Convierte el diseno en codigo de alta calidad: gestion de complejidad, secure coding, manejo de errores, gestion de dependencias, refactoring y estrategias de integracion. USALO para implementar funcionalidad, refactorizar codigo, reducir deuda tecnica o complejidad ciclomatica, y revisar calidad de codigo.
tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch, TodoWrite, NotebookEdit
model: opus
---
```

Alcance de archivos: código fuente de la aplicación; pruebas unitarias que acompañan al código que escribe; manifiestos y lockfiles de dependencias; configuración de linters, formateadores y pre-commit hooks; docstrings y READMEs de módulo.

### 6. `tester-software.md` — Agente 05

Cuerpo: [`system-prompts/agente-05-especialista-pruebas-software.md`](system-prompts/agente-05-especialista-pruebas-software.md)

```yaml
---
name: tester-software
description: Especialista Senior en Pruebas de Software (Agente 05, SWEBOK v4.0 Cap. 5). Disena la estrategia y las suites de prueba: unitarias, integracion, sistema y aceptacion; funcionales y no funcionales (rendimiento, seguridad, usabilidad); automatizacion de regresion, criterios de entrada/salida y trazabilidad caso-requerimiento. USALO para planificar pruebas, escribir o revisar tests, analizar cobertura, o diagnosticar la distincion fault/failure/error de un defecto.
tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch, TodoWrite, NotebookEdit
model: opus
---
```

Alcance de archivos: planes y estrategias de prueba con criterios de entrada/salida; casos y código de prueba en todos los niveles (unit, integración, e2e, contract); fixtures, mocks, stubs y datos de prueba; configuración de frameworks, runners y cobertura; reportes de defectos y matrices de trazabilidad caso de prueba → requerimiento.

### 7. `devops-operaciones.md` — Agente 06

Cuerpo: [`system-prompts/agente-06-especialista-devops.md`](system-prompts/agente-06-especialista-devops.md)

```yaml
---
name: devops-operaciones
description: Especialista Senior en DevOps y Operaciones (Agente 06, SWEBOK v4.0 Cap. 6). Disena pipelines CI/CD, Infrastructure as Code, estrategias de despliegue (blue/green, canary, rolling), observabilidad (metricas, logs, trazas), SLOs/SLIs/SLAs y gestion de incidentes. USALO para automatizar builds y despliegues, definir infraestructura, instrumentar observabilidad o responder a incidentes de produccion.
tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch, TodoWrite, NotebookEdit
model: opus
---
```

Alcance de archivos: pipelines CI/CD (`.github/workflows`, `.gitlab-ci.yml`, `Jenkinsfile`); IaC (Terraform, CloudFormation, Pulumi, Ansible, Helm, manifiestos Kubernetes); Dockerfiles y configuración de contenedores; observabilidad (dashboards, alertas, reglas de SLO); runbooks, playbooks de incidentes y postmortems; configuración de entornos y gestión de secretos — nunca valores de secretos en claro.

---

## Cómo invocar a los agentes

Hay tres formas de poner a trabajar a un subagente en Claude Code.

### 1. Invocación explícita por lenguaje natural (la más fiable)

Nombra al agente en tu petición. Funciona siempre:

```
Usa el subagente arquitecto-software para evaluar si conviene separar
el módulo de facturación en un servicio independiente.
```

```
Pide al analista-requerimientos que convierta las notas de la reunión
en docs/notas-cliente.md a un SRS con criterios de aceptación testeables.
```

### 2. Mención directa con `@`

Escribe `@agent-` y el nombre para invocarlo al instante:

```
@agent-tester-software revisa la cobertura de src/payments/ y dime qué caminos quedan sin probar
```

### 3. Delegación automática

Si no nombras a nadie, Claude Code lee el campo `description` de cada agente y delega solo cuando la tarea encaja. Por eso las descripciones de este repo incluyen la palabra **USALO** seguida de los disparadores concretos: son la señal que orienta esa decisión.

Para forzar la delegación automática con más agresividad, añade a tu `CLAUDE.md`:

```markdown
## Equipo de agentes

Este proyecto usa el equipo de agentes SWEBOK v4.0. Antes de trabajar,
delega en el especialista correspondiente:

- Requerimientos ambiguos o nuevos → `analista-requerimientos`
- Decisiones estructurales o de límites entre módulos → `arquitecto-software`
- Diseño de módulos, interfaces y contratos → `disenador-software`
- Implementación y refactoring → `constructor-software`
- Estrategia de pruebas y tests → `tester-software`
- CI/CD, infraestructura y producción → `devops-operaciones`
- Revisión final de cualquier artefacto → `smith-gobernador`
```

### 4. Orquestación por Smith (proyectos completos)

Para trabajos que abarcan varias fases, empieza por el Gobernador y deja que él coordine. Smith hereda la herramienta de delegación, así que puede activar a los especialistas él mismo:

```
Usa smith-gobernador. Contexto: API REST de gestión de inventario para una
cadena de farmacias, greenfield, equipo de 4 personas, 3 meses de plazo.
Restricciones: debe integrarse con un ERP SAP existente y cumplir
trazabilidad regulatoria de lotes. Coordina al equipo desde requerimientos
hasta el plan de despliegue.
```

### Notas prácticas

- **Cada subagente arranca con contexto limpio.** No ve tu conversación: dale el contexto que necesite (rutas de archivos, restricciones, decisiones ya tomadas) en la petición.
- **Devuelve un informe, no su transcripción.** El trabajo intermedio del subagente no consume tu ventana de contexto.
- **Encadena explícitamente.** Al invocar al siguiente agente, indícale qué artefacto producido por el anterior debe leer: `...lee docs/arquitectura/ADR-003.md y diseña a partir de ahí`.
- **Puedes lanzar varios en paralelo** cuando las tareas son independientes (por ejemplo, `tester-software` sobre un módulo y `devops-operaciones` sobre el pipeline).

---

## Ejemplos en proyectos reales

### Ejemplo A — Proyecto nuevo, cadena completa

Sistema greenfield, recorriendo el ciclo de vida en orden. Cada paso indica qué leer del paso anterior.

**Paso 1 — Requerimientos**

```
Usa analista-requerimientos.

Contexto: plataforma de reserva de canchas deportivas. Usuarios: jugadores
(reservan), dueños de complejos (publican horarios), administrador.
Cobro con pasarela de pago local. Notas de las entrevistas en docs/entrevistas/.

Produce docs/requerimientos/SRS.md con requerimientos funcionales y no
funcionales numerados, cada uno con criterio de aceptación Given-When-Then,
y una matriz de trazabilidad a stakeholder. Marca explícitamente los
requerimientos ambiguos que necesiten volver al cliente.
```

**Paso 2 — Revisión del gate**

```
Usa smith-gobernador. Revisa docs/requerimientos/SRS.md y emite dictamen
formal. Verifica: no ambigüedad, testeabilidad, completitud y trazabilidad.
No apruebes si hay requerimientos no verificables.
```

**Paso 3 — Arquitectura**

```
Usa arquitecto-software. Lee docs/requerimientos/SRS.md (ya aprobado).

Define la arquitectura. Prioriza modificabilidad y bajo costo operativo:
es un equipo de 3 personas. Produce docs/arquitectura/ con vista de
contexto y contenedores C4, y un ADR por cada decisión significativa
(estilo arquitectónico, persistencia, integración con la pasarela de pago).
Justifica los trade-offs contra los atributos de calidad del SRS.
```

**Paso 4 — Diseño**

```
Usa disenador-software. Lee docs/arquitectura/ y el SRS.

Diseña en detalle el módulo de reservas: interfaces, contratos, invariantes
y la máquina de estados de una reserva (pendiente → confirmada → cancelada
→ completada). Respeta la regla de dependencia definida en ADR-001.
Entrega docs/diseno/reservas.md y las interfaces en código.
```

**Paso 5 — Construcción**

```
Usa constructor-software. Implementa el módulo de reservas siguiendo
docs/diseno/reservas.md. Respeta los contratos ya definidos, no los cambies:
si algo del diseño no es implementable, detente y repórtalo.
Incluye pruebas unitarias de la máquina de estados.
```

**Paso 6 — Pruebas**

```
Usa tester-software. Lee el SRS y el código de src/reservas/.

Diseña la estrategia de pruebas: qué se cubre en unitarias, integración y
aceptación, con criterios de entrada/salida. Implementa las pruebas de
aceptación derivadas de los Given-When-Then del SRS y entrega la matriz
de trazabilidad caso de prueba → requerimiento. Señala qué requerimientos
quedan sin cobertura.
```

**Paso 7 — DevOps**

```
Usa devops-operaciones. Monta el pipeline CI/CD en GitHub Actions:
lint, pruebas unitarias, pruebas de integración y quality gate de cobertura
según los criterios de salida definidos por tester-software.
Despliegue canary a producción con rollback automático.
Define los SLOs de disponibilidad y latencia del endpoint de reservas.
```

**Paso 8 — Cierre**

```
Usa smith-gobernador. Valida la coherencia end-to-end de todo lo producido:
que cada requerimiento del SRS tenga arquitectura, diseño, código, prueba y
cobertura de despliegue. Reporta huecos de trazabilidad.
```

### Ejemplo B — Proyecto existente (brownfield)

No empieces por requerimientos: empieza por entender lo que hay.

```
Usa arquitecto-software. Analiza este repositorio y documenta la
arquitectura *tal como está hoy* (no como debería ser): límites reales
entre módulos, dependencias que violan la dirección esperada y
acoplamientos problemáticos. Entrega docs/arquitectura/estado-actual.md
con un diagrama C4 de contenedores y una lista priorizada de deuda
arquitectónica por riesgo.
```

Después, sobre un hallazgo concreto:

```
Usa disenador-software. Según docs/arquitectura/estado-actual.md, el módulo
de notificaciones depende directamente del ORM. Diseña la refactorización
para invertir esa dependencia sin romper la API pública. Entrega el plan
por pasos, cada uno dejando el sistema en verde.
```

```
Usa constructor-software. Ejecuta el paso 1 del plan de refactorización
en docs/diseno/refactor-notificaciones.md. No avances al paso 2.
```

### Ejemplo C — Feature nueva en un sistema en producción

Cadena corta, sin recorrer todo el ciclo:

```
Usa analista-requerimientos. El cliente pide "que se pueda exportar el
reporte". Eso es ambiguo. Genera las preguntas de elicitación que hay que
hacerle, y con los supuestos más razonables redacta el requerimiento
formal con criterios de aceptación testeables.
```

```
Usa disenador-software. Diseña la exportación de reportes según
docs/requerimientos/RF-042.md. Considera que los reportes grandes no pueden
bloquear el request: propón el diseño asíncrono y sus contratos.
```

```
Usa constructor-software. Implementa RF-042 según el diseño. Después,
usa tester-software para las pruebas de aceptación de los tres criterios
Given-When-Then del requerimiento.
```

### Ejemplo D — Incidente en producción

```
Usa devops-operaciones. Incidente activo: latencia p99 del endpoint /checkout
subió de 200ms a 4s desde el despliegue de las 14:30. Logs en
observabilidad/logs/. Diagnostica, propón mitigación inmediata y redacta
el postmortem con acciones correctivas.
```

Y si el diagnóstico apunta al código:

```
Usa constructor-software. Según el postmortem en docs/ops/postmortem-2026-03-12.md,
la causa raíz es una consulta N+1 en el listado de carrito. Corrígela y
añade la prueba de regresión que la habría detectado.
```

### Ejemplo E — Auditoría de calidad sin escribir código

```
Usa tester-software. Audita la suite de pruebas de este repositorio:
qué niveles están cubiertos, qué requerimientos no tienen prueba asociada,
qué pruebas son frágiles o tautológicas. No escribas pruebas todavía:
entrega el diagnóstico priorizado por riesgo.
```

### Ejemplo F — Resolver un desacuerdo técnico

```
Usa smith-gobernador. El arquitecto propone event-driven con cola de
mensajes; el constructor argumenta que añade complejidad operativa
injustificada para el volumen actual. Ambos argumentos están en
docs/discusion-async.md. Arbitra la decisión con fundamento técnico
y déjala registrada como ADR.
```

---

## Reglas de trabajo del equipo

- **Respeta el orden de la cadena.** Requerimientos → Arquitectura → Diseño → Construcción → Pruebas → DevOps. Activar una fase posterior sin artefactos validados de las anteriores genera inconsistencias que se pagan más tarde.
- **No omitas el gate de Smith** en proyectos formales. Cada artefacto debería pasar por revisión del Gobernador antes de considerarse válido para la siguiente fase.
- **Da contexto de proyecto al inicio**: tipo de sistema, fase del ciclo de vida, restricciones clave, tamaño del equipo y criterios de calidad acordados. Los agentes son rigurosos, pero no adivinan.
- **Cada agente respeta el dominio de los demás.** La sección *Alcance de Archivos y Permisos* de cada agente le indica no modificar artefactos ajenos: si detecta un problema fuera de su dominio, lo reporta como observación en su entregable.
- **No todo proyecto necesita las siete fases.** Un bugfix no requiere un SRS. Usa la cadena completa para trabajo nuevo y significativo; para cambios acotados, invoca directamente al especialista que corresponda.

---

## Personalización

**Cambiar el modelo.** Los agentes vienen con `model: opus` por su carga de razonamiento. Para tareas más mecánicas puedes bajar a `sonnet` editando el frontmatter, o poner `model: inherit` para que use el de la sesión.

**Restringir herramientas.** Si quieres un agente estrictamente de solo lectura (por ejemplo, un auditor que no toque archivos), elimina `Write`, `Edit` y `Bash` de su lista de `tools`.

**Adaptar el alcance de archivos.** La sección *Alcance de Archivos y Permisos* al final de cada agente es texto normal del prompt: edítala para reflejar la estructura de carpetas y las convenciones reales de tu organización.

**Reinstalar tras editar los system prompts.** Si modificas algo en `system-prompts/`, vuelve a ejecutar `./install.sh` para regenerar los agentes. El script sobrescribe los archivos destino, así que cualquier edición hecha directamente en `~/.claude/agents/` se perderá: haz tus cambios en `system-prompts/`.

---

## Base de conocimiento

Todos los system prompts se fundamentan en:

- **SWEBOK Guide V4.0** — IEEE Computer Society, 2024 (incluido en [`fuente/swebok-v4.pdf`](fuente/swebok-v4.pdf))
- **ISO/IEC/IEEE 12207** — Procesos del ciclo de vida del software
- **ISO/IEC 25010 (SQuaRE)** — Modelo de calidad del producto de software
- **IEEE 730** — Planes de aseguramiento de calidad de software
- **Clean Architecture**, Robert C. Martin — base adicional del Agente 02 v2

## Estructura del repositorio

```
.
├── install.sh                 ← instalador de los 7 subagentes
├── README.md
├── system-prompts/            ← los system prompts (fuente de verdad)
│   ├── agente-00-Smith.md
│   ├── agente-01-especialista-requerimientos.md
│   ├── agente-02-arquitecto-software.md
│   ├── agente-02-arquitecto-software_v2.md
│   ├── agente-03-especialista-diseno-software.md
│   ├── agente-04-especialista-construccion-software.md
│   ├── agente-05-especialista-pruebas-software.md
│   └── agente-06-especialista-devops.md
└── fuente/
    └── swebok-v4.pdf
```
