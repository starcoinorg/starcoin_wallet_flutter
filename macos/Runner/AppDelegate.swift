import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func application(_ application: NSApplication,
                     open urls: [URL]) {
    let window = mainFlutterWindow as! MainFlutterWindow;
    for url in urls {
      let _ = window.linkStreamHandler.handleLink(url.absoluteString)
    }
  }

}
