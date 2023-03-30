import 'package:flutter/material.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewArg {
  const WebViewArg({this.title, required this.url});

  final String? title;
  final String url;
}

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arg = context.getRouteArguments<WebViewArg>();
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).colorScheme.background)
      ..loadRequest(Uri.parse(arg?.url ?? ''));
    return Scaffold(
      appBar: AppBar(title: Text(arg?.title ?? '')),
      body: WebViewWidget(controller: controller),
    );
  }
}
