# Equipo de Agentes de Ingeniería de Software — SWEBOK v4.0

Colección de system prompts para un equipo de agentes de IA especializados en las disciplinas de ingeniería de software definidas por el **SWEBOK Guide V4.0** (IEEE Computer Society). Cada agente actúa como un especialista senior en su área de conocimiento, con roles, metodologías y protocolos de interacción claramente definidos.

---

## Descripción de los Agentes

### [Agente 00 — Gobernador de Ingeniería (Smith)](system-prompts/agente-00-Smith.md)

El agente orquestador y revisor supremo del equipo. No ejecuta trabajo especializado: revisa, aprueba y coordina el trabajo de los demás agentes. Emite decisiones formales (`APROBADO`, `APROBADO CON OBSERVACIONES`, `RECHAZADO`, `BLOQUEADO — CONFLICTO INTER-AGENTE`) y mantiene la trazabilidad end-to-end de los artefactos del proyecto. Tiene autoridad sobre todos los demás agentes y es el único que puede declarar un artefacto válido para continuar a la siguiente fase.

### [Agente 01 — Especialista en Requerimientos](system-prompts/agente-01-especialista-requerimientos.md)

Cubre la elicitación, análisis, especificación, validación y gestión de requerimientos de software. Trabaja con stakeholders para producir requerimientos funcionales y no funcionales no ambiguos, testeables y trazables. Aplica técnicas como user story mapping, Given-When-Then (BDD/ATDD), modelos UML/SysML y análisis de conflictos entre stakeholders.

### [Agente 02 — Arquitecto de Software](system-prompts/agente-02-arquitecto-software.md)

Toma las decisiones estructurales de alto nivel que determinan la forma del sistema y sus atributos de calidad. Produce vistas arquitectónicas (C4, 4+1), Architecture Decision Records (ADRs) y análisis de trade-offs usando métodos como ATAM. Domina estilos arquitectónicos (Microservices, Event-Driven, Hexagonal, CQRS, Serverless) y sus implicaciones en disponibilidad, rendimiento, seguridad y modificabilidad.

### [Agente 03 — Especialista en Diseño de Software](system-prompts/agente-03-especialista-diseno-software.md)

Traduce la arquitectura en diseño detallado de módulos, interfaces y contratos. Aplica principios SOLID, patrones de diseño (GoF y arquitectónicos), alta cohesión y bajo acoplamiento. Produce diagramas de clases, secuencia e interacción, asegurando que el diseño sea testeable por construcción y consistente con las restricciones arquitectónicas.

### [Agente 04 — Especialista en Construcción de Software](system-prompts/agente-04-especialista-construccion-software.md)

Transforma el diseño en código de alta calidad. Se ocupa de la gestión de complejidad, calidad del código (complejidad ciclomática, deuda técnica, cobertura de pruebas unitarias), gestión de dependencias, prácticas de secure coding y estrategias de integración. Entiende cómo adaptar las prácticas de construcción a distintos ciclos de vida (ágil, iterativo, continuo).

### [Agente 05 — Especialista en Pruebas de Software](system-prompts/agente-05-especialista-pruebas-software.md)

Planifica y ejecuta la estrategia de pruebas del proyecto. Distingue entre faults, failures y errors, y diseña suites de prueba funcionales y no funcionales (rendimiento, seguridad, usabilidad). Gestiona la automatización de pruebas de regresión, los criterios de entrada/salida de las fases de prueba y la trazabilidad entre casos de prueba y requerimientos.

### [Agente 06 — Especialista en DevOps / Operaciones](system-prompts/agente-06-especialista-devops.md)

Cierra el ciclo entre desarrollo y producción. Diseña y mantiene pipelines de CI/CD, Infrastructure as Code (IaC), estrategias de despliegue (blue/green, canary, rolling), observabilidad (métricas, logs, trazas), SLOs/SLIs/SLAs y gestión de incidentes. Asegura que los quality gates del equipo de pruebas estén automatizados en el pipeline.

---

## Cómo Implementar Estos Prompts en Claude Code

Estos system prompts están diseñados para usarse como **agentes en Claude Code** mediante el [Agent SDK](https://docs.anthropic.com/en/docs/claude-code/agent-sdk). Hay dos formas principales de implementarlos:

### Opción 1 — Agente individual por proyecto (recomendada para proyectos pequeños)

Copia el contenido del system prompt del agente que necesitas directamente en el archivo de configuración de tu proyecto en Claude Code.

1. Abre o crea el archivo `CLAUDE.md` en la raíz de tu proyecto.
2. En la sección relevante, indica al agente cuál es su rol copiando el contenido del system prompt correspondiente.
3. Activa el agente desde Claude Code invocándolo por su nombre o rol.

### Opción 2 — Equipo completo orquestado por Smith (recomendada para proyectos complejos)

1. **Configura el agente orquestador:** Crea un agente basado en `agente-00-Smith.md` como el punto de entrada de tu equipo. Smith es quien activa y coordina a los demás.

2. **Registra los agentes especializados:** Para cada agente (01 al 06), crea una definición de agente en tu proyecto de Claude Code con el system prompt del archivo correspondiente.

   Estructura sugerida en tu proyecto:
   ```
   .claude/
   └── agents/
       ├── smith.md           ← contenido de agente-00-Smith.md
       ├── requerimientos.md  ← contenido de agente-01-especialista-requerimientos.md
       ├── arquitectura.md    ← contenido de agente-02-arquitecto-software.md
       ├── diseno.md          ← contenido de agente-03-especialista-diseno-software.md
       ├── construccion.md    ← contenido de agente-04-especialista-construccion-software.md
       ├── pruebas.md         ← contenido de agente-05-especialista-pruebas-software.md
       └── devops.md          ← contenido de agente-06-especialista-devops.md
   ```

3. **Flujo de trabajo:** Inicia siempre con Smith. Smith determinará qué agente especializado activar según la fase del proyecto y coordinará sus outputs.

4. **Trazabilidad:** Smith valida que los artefactos de cada agente sean consistentes entre sí antes de pasar a la siguiente fase del ciclo de vida.

### Buenas prácticas al implementar

- **Provee contexto del proyecto a Smith** al inicio de cada sesión: tipo de sistema, fase del ciclo de vida, restricciones clave y criterios de calidad acordados.
- **No omitas la revisión de Smith.** Cada artefacto producido por un agente especializado debe pasar por la revisión del Gobernador antes de considerarse válido.
- **Respeta el orden de la cadena:** Requerimientos → Arquitectura → Diseño → Construcción → Pruebas → DevOps. Activar un agente de fases posteriores sin outputs validados de las anteriores genera inconsistencias.

---

## Base de Conocimiento

Todos los system prompts se fundamentan en:

- **SWEBOK Guide V4.0** — IEEE Computer Society, 2024 (disponible en [`fuente/swebok-v4.pdf`](fuente/swebok-v4.pdf))
- **ISO/IEC/IEEE 12207** — Procesos del ciclo de vida del software
- **ISO/IEC 25010 (SQuaRE)** — Modelo de calidad del producto de software
- **IEEE 730** — Planes de aseguramiento de calidad de software
