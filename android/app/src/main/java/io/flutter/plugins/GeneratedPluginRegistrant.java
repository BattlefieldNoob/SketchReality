package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import de.esys.esysfluttershare.EsysFlutterSharePlugin;
import vn.hunghd.flutterdownloader.FlutterDownloaderPlugin;
import com.rexraphael.flutterunitywidget.FlutterUnityWidgetPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    EsysFlutterSharePlugin.registerWith(registry.registrarFor("de.esys.esysfluttershare.EsysFlutterSharePlugin"));
    FlutterDownloaderPlugin.registerWith(registry.registrarFor("vn.hunghd.flutterdownloader.FlutterDownloaderPlugin"));
    FlutterUnityWidgetPlugin.registerWith(registry.registrarFor("com.rexraphael.flutterunitywidget.FlutterUnityWidgetPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
