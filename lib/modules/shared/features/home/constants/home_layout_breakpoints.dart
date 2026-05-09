/// Ancho mínimo (en **pixels lógicos**) del área útil del cuerpo del home para usar
/// layout tipo dashboard (rail + panel) en **plataformas no web** (móvil / escritorio
/// nativo). En **Flutter Web** el home usa siempre ese layout; esta constante no aplica
/// para decidir rail vs rejilla en web.
///
/// Es el único valor que debe tocarse para calibrar tablet apaisada / ventanas medianas
/// en nativo; el código del home compara contra esta constante (`>= kHomeWideLayoutBreakpoint`).
///
/// Nota: hoy es `const` de compilación. Si en el futuro el valor viniera de remote
/// config, sustituir por una fuente única inyectada y seguir leyendo desde un solo sitio.
const double kHomeWideLayoutBreakpoint = 900;
