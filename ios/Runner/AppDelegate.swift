import UIKit
import Flutter
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    InitArgs(CommandLine.argc, CommandLine.unsafeArgv)
    GeneratedPluginRegistrant.register(with: self)
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    //
    // Integration note:
    //
    // In Flutter, in order to work in background isolate, plugins need to register with
    // a special instance of `FlutterEngine` that serves for background execution only.
    // Hence, all (and only) plugins that require background execution feature need to
    // call `register` in this function.
    //
    // The default `GeneratedPluginRegistrant` will call `register` of all plugins integrated
    // in your application. Hence, if you are using `FlutterDownloaderPlugin` along with other
    // plugins that need UI manipulation, you should register `FlutterDownloaderPlugin` and any
    // 'background' plugins explicitly like this:
    //
    // FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "vn.hunghd.flutter_downloader"))
    //
    GeneratedPluginRegistrant.register(with: registry)
}
