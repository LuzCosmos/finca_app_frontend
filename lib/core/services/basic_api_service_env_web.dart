import 'package:universal_html/js.dart' as js;

/// Lee `API_BASE_URL` desde `window.ENV` en el build web.
String? readWebApiBaseUrlFromWindow() {
  if (!js.context.hasProperty('ENV')) {
    return null;
  }
  final env = js.context['ENV'];
  if (env is js.JsObject) {
    if (env.hasProperty('API_BASE_URL')) {
      final val = env['API_BASE_URL'];
      if (val != null &&
          val.toString().toLowerCase() != 'null' &&
          val.toString().trim().isNotEmpty) {
        return val.toString();
      }
    }
    return null;
  }
  try {
    final val = (env as dynamic)['API_BASE_URL'];
    if (val != null &&
        val.toString().toLowerCase() != 'null' &&
        val.toString().trim().isNotEmpty) {
      return val.toString();
    }
  } catch (_) {}
  return null;
}
