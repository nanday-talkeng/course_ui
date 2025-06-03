import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // iOS workaround to prevent screenshots & screen recording
    let secureField = UITextField()
    secureField.isSecureTextEntry = true
    secureField.backgroundColor = .clear
    secureField.tintColor = .clear
    secureField.textColor = .clear
    self.window?.addSubview(secureField)
    secureField.center = self.window?.center ?? CGPoint(x: 0, y: 0)
    self.window?.layer.superlayer?.addSublayer(secureField.layer)
    secureField.removeFromSuperview()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
