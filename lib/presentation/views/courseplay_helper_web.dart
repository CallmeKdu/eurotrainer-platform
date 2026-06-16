// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

void registerScormCallback(String trainingId, void Function(String status, double score) onCommit) {
  globalContext['onScormCommit'] = ((JSAny? status, JSAny? score) {
    final statusStr = status?.dartify()?.toString() ?? '';
    final scoreNum = double.tryParse(score?.dartify()?.toString() ?? '') ?? 0.0;
    onCommit(statusStr, scoreNum);
  }).toJS;
}

void registerIframeViewFactory(String iframeId, String scormUrl) {
  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(iframeId, (int viewId) {
    // ignore: undefined_class
    final iframe = html.IFrameElement()
      ..src = scormUrl
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allowFullscreen = true;
    return iframe;
  });
}

void cleanupScormCallback() {
  globalContext['onScormCommit'] = null;
}
