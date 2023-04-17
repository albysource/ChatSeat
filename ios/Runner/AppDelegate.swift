import UIKit
import Flutter
import Tor

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let deviceChannel = FlutterMethodChannel(
        name: "io.github.secure.onionchat/tor", 
        binaryMessenger: controller.binaryMessenger
        )
    registerMethodHandler(deviceChannel: deviceChannel);  
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func registerMethodHandler(deviceChannel: FlutterMethodChannel) {
    deviceChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      NSLog("Received native call: \(call.method)")
      switch call.method {
        case "startTor":
          result(self.startTor(result: result))
        case "stopTor":
          result(self.stopTor())
        case "isTorActive":
          result(self.isTorActive())
        default:
          result(FlutterMethodNotImplemented)
      }

    })
  }

  private func startTor(result: FlutterResult) -> String {
    let conf = TorConfiguration()
    conf.ignoreMissingTorrc = true
    conf.cookieAuthentication = true
    conf.autoControlPort = true
    conf.avoidDiskWrites = true
    conf.dataDirectory = NSURL.fileURL(withPath: NSTemporaryDirectory())
    conf.options = [
      "Socks5ProxyUsername" : "onionuser",
      "Socks5ProxyPassword" : "torpass",
    ]
    let thread = TorThread(configuration: conf)
    thread.start()
    NSLog("Tor Thread Started, launching controller task")
    DispatchQueue.main.asyncAfter(
      deadline: .now() + 15,
      execute: {
        NSLog("Creating controller")
        let controller = TorController(controlPortFile: conf.controlPortFile!)
        do {
          try controller.connect()
        } catch let e as NSError? {
          print("Caught some error (can ignore, seems to work even if thrown): \(e)")
        }
        let cookie = conf.cookie!
        controller.authenticate(with: cookie, completion: {success, error in 
          NSLog("Tor Auth \(success)")
          if !success {
            NSLog("Could not connect to Tor Control Port")
            return
          }
          var circuitEstablishObserver: Any? = nil
          circuitEstablishObserver = controller.addObserver(forCircuitEstablished: {established in
            if established {
              controller.removeObserver(circuitEstablishObserver)
              NSLog("Tor Circuit Established")
              self.testTor(controller: controller)
            }
          })
          var progressObserver: Any? = nil
          progressObserver = controller.addObserver(forStatusEvents: { (type: String, severity: String, action: String, arguments: [String : String]?) -> Bool in
            if type == "STATUS_CLIENT" && action == "BOOTSTRAP" {
              let progress = Int(arguments!["PROGRESS"]!)!
              NSLog("Tor Bootstrap Progress: \(progress)")
              if progress >= 100 {
                controller.removeObserver(progressObserver)
              }
              return true
            }
            return true
          })
        })
      })
      return "Tor Thread Started..."
  }

  private func testTor(controller: TorController) {
      controller.getSessionConfiguration({ (sessionConfig: URLSessionConfiguration?) in
        let proxyDict = sessionConfig?.connectionProxyDictionary!
        let hostname = proxyDict?[kCFStreamPropertySOCKSProxyHost]
        let port = proxyDict?[kCFStreamPropertySOCKSProxyPort]
    
        NSLog("Tor port is \(port) with hostname \(hostname)")
        let session = URLSession.init(configuration: sessionConfig!)
        var request = URLRequest(url: URL(string:"https://check.torproject.org")!)
        request.httpMethod = "GET"
        NSLog("Sending tor check get request...")
        let task = session.dataTask(with: request) { (data, response, error) in
          print("Tor check: Got response")
          print(String(data: data!, encoding: .utf8)!)
          print(response)
          print(error)
        }
        task.resume()
    })
  }

  private func stopTor() {

  }

  private func isTorActive() {

  }
}
