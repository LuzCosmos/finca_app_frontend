/// Bloques predefinidos de Read LW001-BG PRO (alineados con el backend).
///
/// Los HEX están verificados por `device-remote-configuration.service.spec.ts` en el
/// backend (tests `chunkIndex=N produce el HEX exacto …`). Se duplican aquí para que
/// la UI pueda renderizar los botones aunque el endpoint del plan no responda.
///
/// Subdivisión a 18 bloques (mayo 2026): se partieron los bloques que el firmware no
/// respondía con TLV (Periodic/Timing/Motion, GPS, LoRaWAN básico, Bluetooth broadcast,
/// Sensores). Los bloques que ya respondían bien (1, 4, 5, 6, 7 -> ahora 0, 4, 5, 6,
/// 16) se mantienen sin cambios. Cada sub-bloque tiene 6 IDs o menos para que la
/// respuesta TLV quepa cómodamente en un solo uplink.
class Lw001BgProSafeReadChunkPreset {
  final int chunkIndex;
  final int count;
  final String expectedHex;

  /// Etiqueta legible mostrada en el botón (ej. `"Bloque 1 — General"`).
  final String label;

  const Lw001BgProSafeReadChunkPreset({
    required this.chunkIndex,
    required this.count,
    required this.expectedHex,
    required this.label,
  });
}

const List<Lw001BgProSafeReadChunkPreset> kLw001BgProSafeReadChunkPresets = [
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 0,
    count: 9,
    expectedHex: '0104060708090a0b0c0d',
    label: 'Bloque 1 — General',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 1,
    count: 5,
    expectedHex: '012021222324',
    label: 'Bloque 2A — Periodic / Timing',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 2,
    count: 5,
    expectedHex: '012526272829',
    label: 'Bloque 2B — Motion (inicio + en viaje)',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 3,
    count: 4,
    expectedHex: '012a2b2c2d',
    label: 'Bloque 2C — Motion (fin) + downlink',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 4,
    count: 9,
    expectedHex: '013031323334353c3e45',
    label: 'Bloque 3 — WiFi / Bluetooth básico',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 5,
    count: 6,
    expectedHex: '01363738393a3b',
    label: 'Bloque 4 — Filtros BLE A',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 6,
    count: 6,
    expectedHex: '013f4041424344',
    label: 'Bloque 5 — Filtros BLE B',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 7,
    count: 6,
    expectedHex: '0148494a4b4c4d',
    label: 'Bloque 6A — GPS accuracy / timeouts',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 8,
    count: 6,
    expectedHex: '014e4f50515253',
    label: 'Bloque 6B — GPS model + aiding',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 9,
    count: 4,
    expectedHex: '0160616364',
    label: 'Bloque 7A — LoRaWAN region + DevEUI/AppEUI',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 10,
    count: 4,
    expectedHex: '01696a6b6c',
    label: 'Bloque 7B — LoRaWAN msg / CH / DR',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 11,
    count: 3,
    expectedHex: '016d6e6f',
    label: 'Bloque 7C — LoRaWAN duty / sync / reconnect',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 12,
    count: 5,
    expectedHex: '017071727374',
    label: 'Bloque 8A — Bluetooth beacon + UUID',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 13,
    count: 6,
    expectedHex: '0175767778797a',
    label: 'Bloque 8B — Bluetooth Major/Minor/Power/Name',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 14,
    count: 6,
    expectedHex: '01808182838485',
    label: 'Bloque 9A — Axis + shock detalle',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 15,
    count: 5,
    expectedHex: '01868788898a',
    label: 'Bloque 9B — Man down + tamper + active state',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 16,
    count: 1,
    expectedHex: '0105',
    label: 'Bloque 10 — Password Bluetooth',
  ),
  Lw001BgProSafeReadChunkPreset(
    chunkIndex: 17,
    count: 4,
    expectedHex: '0105656768',
    label: 'Bloque 11 — Keys (AppKey / AppSKey / NwkSKey)',
  ),
];
