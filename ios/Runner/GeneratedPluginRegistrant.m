//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<esys_flutter_share/EsysFlutterSharePlugin.h>)
#import <esys_flutter_share/EsysFlutterSharePlugin.h>
#else
@import esys_flutter_share;
#endif

#if __has_include(<flutter_downloader/FlutterDownloaderPlugin.h>)
#import <flutter_downloader/FlutterDownloaderPlugin.h>
#else
@import flutter_downloader;
#endif

#if __has_include(<flutter_unity_widget/FlutterUnityWidgetPlugin.h>)
#import <flutter_unity_widget/FlutterUnityWidgetPlugin.h>
#else
@import flutter_unity_widget;
#endif

#if __has_include(<path_provider/PathProviderPlugin.h>)
#import <path_provider/PathProviderPlugin.h>
#else
@import path_provider;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [EsysFlutterSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"EsysFlutterSharePlugin"]];
  [FlutterDownloaderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterDownloaderPlugin"]];
  [FlutterUnityWidgetPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterUnityWidgetPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
}

@end
