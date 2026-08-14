#!/usr/bin/env bash
#
# Instalador del equipo de agentes SWEBOK v4.0 para Claude Code.
#
#   ./install.sh              instala en ~/.claude/agents/      (agentes personales)
#   ./install.sh --project    instala en ./.claude/agents/      (agentes del proyecto)
#   ./install.sh --dest DIR   instala en un directorio concreto
#   ./install.sh --arch-v1    usa la v1 del arquitecto en lugar de la v2
#
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO/system-prompts"
DST="$HOME/.claude/agents"
ARCH="agente-02-arquitecto-software_v2.md"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)  DST="$(pwd)/.claude/agents"; shift ;;
    --dest)     DST="$2"; shift 2 ;;
    --arch-v1)  ARCH="agente-02-arquitecto-software.md"; shift ;;
    -h|--help)  sed -n '3,10p' "$0"; exit 0 ;;
    *)          echo "Opción desconocida: $1" >&2; exit 1 ;;
  esac
done

[[ -d "$SRC" ]] || { echo "No encuentro $SRC. Ejecuta el script desde el repo clonado." >&2; exit 1; }
mkdir -p "$DST"

TOOLS="Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch, TodoWrite, NotebookEdit"

emit() {
  local out="$1" name="$2" desc="$3" src="$4" tools="$5" scope="$6"
  [[ -f "$SRC/$src" ]] || { echo "Falta el system prompt: $SRC/$src" >&2; exit 1; }
  {
    echo "---"
    echo "name: $name"
    echo "description: $desc"
    [[ -n "$tools" ]] && echo "tools: $tools"
    echo "model: opus"
    echo "---"
    echo
    cat "$SRC/$src"
    echo
    echo "---"
    echo
    echo "## Alcance de Archivos y Permisos"
    echo
    echo "Tienes permisos de **lectura y escritura** sobre todos los archivos relacionados con tu propósito. Lees libremente cualquier archivo del repositorio para obtener contexto, pero **solo creas o modificas** artefactos de tu dominio:"
    echo
    printf '%s\n' "$scope"
    echo
    echo "No modifiques artefactos que pertenezcan al dominio de otro agente del equipo: repórtalo como observación en tu entregable en su lugar."
    echo
    echo "> **System prompt fuente:** \`system-prompts/$src\`"
  } > "$DST/$out"
  echo "  ✓ $out"
}

echo "Instalando agentes en $DST"

emit "smith-gobernador.md" "smith-gobernador" \
"Gobernador de Ingenieria de Software (Agente 00, SWEBOK v4.0). Orquestador y revisor supremo del equipo: revisa, aprueba o rechaza artefactos de los agentes 01-06, valida coherencia y trazabilidad end-to-end, y decide que fase del ciclo de vida activar. USALO como punto de entrada de cualquier proyecto de ingenieria de software y siempre que un artefacto necesite quality gate final antes de pasar a la siguiente fase." \
"agente-00-Smith.md" \
"" \
"- Actas de revision, dictamenes formales (APROBADO / APROBADO CON OBSERVACIONES / RECHAZADO / BLOQUEADO)
- Matrices de trazabilidad end-to-end entre fases
- Planes de gobernanza, criterios de calidad y quality gates del proyecto
- Registros de decisiones y conflictos inter-agente
- Cualquier documento indice o de coordinacion del equipo

Como gobernador tienes lectura sobre **todos** los artefactos del proyecto y puedes anotar observaciones en cualquiera de ellos, pero la correccion de fondo la ejecuta el agente especialista propietario."

emit "analista-requerimientos.md" "analista-requerimientos" \
"Especialista Senior en Requerimientos de Software (Agente 01, SWEBOK v4.0 Cap. 1). Elicita, analiza, especifica, valida y gestiona requerimientos funcionales y no funcionales. Produce SRS, user stories, criterios de aceptacion Given-When-Then, modelos UML/SysML y matrices de trazabilidad. USALO al inicio de un proyecto, ante requerimientos ambiguos o no testeables, o para analizar conflictos entre stakeholders." \
"agente-01-especialista-requerimientos.md" "$TOOLS" \
"- Documentos de especificacion de requerimientos (SRS), backlogs y user story maps
- Criterios de aceptacion, escenarios BDD/ATDD (.feature) y reglas de negocio
- Modelos de dominio, casos de uso y diagramas UML/SysML de analisis
- Matrices de trazabilidad requerimiento -> origen -> stakeholder
- Glosarios, catalogos de stakeholders y registros de supuestos y restricciones"

emit "arquitecto-software.md" "arquitecto-software" \
"Arquitecto de Software Senior (Agente 02, SWEBOK v4.0 Cap. 2 + Clean Architecture de Robert C. Martin). Define estructura de alto nivel, limites de componentes, politicas vs. detalles, vistas C4/4+1, ADRs y analisis de trade-offs (ATAM) sobre atributos de calidad. USALO para decidir estilo arquitectonico, evaluar decisiones de alto costo de reversion, definir limites entre capas o revisar la arquitectura de un sistema existente." \
"$ARCH" "$TOOLS" \
"- Documentos de arquitectura, vistas C4 / 4+1 y diagramas de componentes y despliegue
- Architecture Decision Records (ADRs) y registros de trade-offs
- Definicion de limites de modulos, capas, puertos y adaptadores, y reglas de dependencia
- Archivos de configuracion que hacen cumplir limites arquitectonicos (linters de dependencias, module boundaries, estructura de carpetas)
- Escenarios de atributos de calidad y utility trees (ATAM)"

emit "disenador-software.md" "disenador-software" \
"Especialista Senior en Diseno de Software (Agente 03, SWEBOK v4.0 Cap. 3). Traduce arquitectura y requerimientos en diseno detallado: modulos, interfaces, contratos, algoritmos y estructuras de datos, aplicando SOLID, patrones GoF, alta cohesion y bajo acoplamiento. USALO entre la arquitectura y la codificacion, para disenar un modulo o API nuevos, o para evaluar cohesion/acoplamiento de un diseno existente." \
"agente-03-especialista-diseno-software.md" "$TOOLS" \
"- Documentos de diseno detallado (HLD y LLD) por modulo
- Diagramas de clases, secuencia, estados e interaccion
- Contratos de interfaces y APIs (OpenAPI, esquemas, tipos, pre/postcondiciones e invariantes)
- Definiciones de tipos, interfaces y firmas de modulos en codigo
- Registros de patrones aplicados y justificacion de decisiones de diseno"

emit "constructor-software.md" "constructor-software" \
"Especialista Senior en Construccion de Software (Agente 04, SWEBOK v4.0 Cap. 4). Convierte el diseno en codigo de alta calidad: gestion de complejidad, secure coding, manejo de errores, gestion de dependencias, refactoring y estrategias de integracion. USALO para implementar funcionalidad, refactorizar codigo, reducir deuda tecnica o complejidad ciclomatica, y revisar calidad de codigo." \
"agente-04-especialista-construccion-software.md" "$TOOLS" \
"- Codigo fuente de la aplicacion en cualquier lenguaje del proyecto
- Pruebas unitarias que acompanan al codigo que escribes
- Manifiestos y lockfiles de dependencias (package.json, requirements.txt, pom.xml, go.mod, etc.)
- Configuracion de linters, formateadores, analisis estatico y pre-commit hooks
- Documentacion tecnica del codigo: docstrings, comentarios y READMEs de modulo"

emit "tester-software.md" "tester-software" \
"Especialista Senior en Pruebas de Software (Agente 05, SWEBOK v4.0 Cap. 5). Disena la estrategia y las suites de prueba: unitarias, integracion, sistema y aceptacion; funcionales y no funcionales (rendimiento, seguridad, usabilidad); automatizacion de regresion, criterios de entrada/salida y trazabilidad caso-requerimiento. USALO para planificar pruebas, escribir o revisar tests, analizar cobertura, o diagnosticar la distincion fault/failure/error de un defecto." \
"agente-05-especialista-pruebas-software.md" "$TOOLS" \
"- Planes de prueba, estrategias de testing y criterios de entrada/salida
- Casos de prueba y codigo de pruebas en todos los niveles (unit, integracion, e2e, contract)
- Fixtures, mocks, stubs, datos de prueba y utilidades del arnes de pruebas
- Configuracion de frameworks y runners de test, y de herramientas de cobertura
- Reportes de defectos, analisis de cobertura y matrices de trazabilidad caso de prueba -> requerimiento"

emit "devops-operaciones.md" "devops-operaciones" \
"Especialista Senior en DevOps y Operaciones (Agente 06, SWEBOK v4.0 Cap. 6). Disena pipelines CI/CD, Infrastructure as Code, estrategias de despliegue (blue/green, canary, rolling), observabilidad (metricas, logs, trazas), SLOs/SLIs/SLAs y gestion de incidentes. USALO para automatizar builds y despliegues, definir infraestructura, instrumentar observabilidad o responder a incidentes de produccion." \
"agente-06-especialista-devops.md" "$TOOLS" \
"- Definiciones de pipelines CI/CD (.github/workflows, .gitlab-ci.yml, Jenkinsfile, etc.)
- Infrastructure as Code (Terraform, CloudFormation, Pulumi, Ansible, Helm, manifiestos Kubernetes)
- Dockerfiles, docker-compose y configuracion de contenedores y entornos
- Configuracion de observabilidad: dashboards, alertas, reglas de SLO, exporters y agentes
- Runbooks, playbooks de incidentes, postmortems y documentacion operativa
- Configuracion de entornos y gestion de secretos (nunca valores de secretos en claro)"

echo
echo "Listo: 7 agentes instalados."
echo "Reinicia Claude Code (o abre una sesión nueva) y verifícalos con /agents"
