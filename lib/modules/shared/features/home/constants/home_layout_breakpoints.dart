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

/// Umbral de ancho útil del **cuerpo** del home (tras padding horizontal) para mostrar el
/// rail **extendido** (ícono + texto) frente al **compacto** (solo íconos + tooltip).
///
/// Aplica en **Flutter Web** (siempre layout rail + panel) y en **nativo** cuando ya se
/// eligió el layout ancho (`home-wide`). Por debajo de este valor el rail va compacto salvo
/// que no quepa ni eso (el layout wide ya no aplicaría en nativo).
const double kHomeWebRailExtendedBreakpoint = 900;

/// Ancho del rail cuando está extendido (web + nativo en modo rail).
const double kHomeWideRailWidth = 280;

/// Ancho del rail en modo compacto (web angosto o nativo ancho con rail colapsado).
const double kHomeCompactRailWidth = 72;
