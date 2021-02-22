import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {

  private var methodChannel: FlutterMethodChannel?
  private var eventChannel: FlutterEventChannel?
  
  let linkStreamHandler = LinkStreamHandler()

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    methodChannel = FlutterMethodChannel(name: "wallet.starcoin.org/channel", binaryMessenger: flutterViewController.engine.binaryMessenger)
    eventChannel = FlutterEventChannel(name: "wallet.starcoin.org/events", binaryMessenger: flutterViewController.engine.binaryMessenger)
    
    methodChannel?.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) in
      guard call.method == "initialLink" else {
        result(FlutterMethodNotImplemented)
        return
      }
    })

    RegisterGeneratedPlugins(registry: flutterViewController)

    eventChannel?.setStreamHandler(linkStreamHandler)

    super.awakeFromNib()
  }
}

class LinkStreamHandler:NSObject, FlutterStreamHandler {
  
  var eventSink: FlutterEventSink?
  
  // links will be added to this queue until the sink is ready to process them
  var queuedLinks = [String]()
  
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    queuedLinks.forEach({ events($0) })
    queuedLinks.removeAll()
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }
  
  func handleLink(_ link: String) -> Bool {
    guard let eventSink = eventSink else {
      queuedLinks.append(link)
      return false
    }
    eventSink(link)
    return true
  }
}
