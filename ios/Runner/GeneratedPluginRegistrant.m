//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <esys_flutter_share/EsysFlutterSharePlugin.h>
#import <flutter_downloader/FlutterDownloaderPlugin.h>
#import <flutter_unity_widget/FlutterUnityWidgetPlugin.h>
#import <path_provider/PathProviderPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [EsysFlutterSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"EsysFlutterSharePlugin"]];
  [FlutterDownloaderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterDownloaderPlugin"]];
  [FlutterUnityWidgetPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterUnityWidgetPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
}

@end
