import Cocoa

class AppCenterViewController : NSViewController {

  var appCenter: AppCenterDelegate = AppCenterProvider.shared().appCenter!
  var currentAction = AuthenticationViewController.AuthAction.login

  @IBOutlet var installIdLabel : NSTextField?
  @IBOutlet var appSecretLabel : NSTextField?
  @IBOutlet var logURLLabel : NSTextField?
  @IBOutlet var userIdLabel : NSTextField?
  @IBOutlet var setEnabledButton : NSButton?

  @IBOutlet weak var deviceIdField: NSTextField!
  @IBOutlet weak var startupModeField: NSComboBox!
    @IBOutlet weak var loginButton: NSButton!
    @IBOutlet weak var logOutButton: NSButton!
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    installIdLabel?.stringValue = appCenter.installId()
    appSecretLabel?.stringValue = appCenter.appSecret()
    logURLLabel?.stringValue = appCenter.logUrl()
    userIdLabel?.stringValue = UserDefaults.standard.string(forKey: kMSUserIdKey) ?? ""
    setEnabledButton?.state = appCenter.isAppCenterEnabled() ? 1 : 0

    deviceIdField?.stringValue = AppCenterViewController.getDeviceIdentifier()!
    let indexNumber = UserDefaults.standard.integer(forKey: kMSStartTargetKey)
    startupModeField.selectItem(at: indexNumber)
    
    
  }

  @IBAction func setEnabled(sender : NSButton) {
    appCenter.setAppCenterEnabled(sender.state == 1)
    sender.state = appCenter.isAppCenterEnabled() ? 1 : 0
  }

  @IBAction func userIdChanged(sender: NSTextField) {
    let text = sender.stringValue
    let userId = !text.isEmpty ? text : nil
    UserDefaults.standard.set(userId, forKey: kMSUserIdKey)
    appCenter.setUserId(userId)
  }

  // Get device identifier.
  class func getDeviceIdentifier() -> String? {
    let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
    let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0)
    let baseIdentifier = serialNumberAsCFString?.takeRetainedValue() as! String
        IOObjectRelease(platformExpert)
    return baseIdentifier
  }

  // Startup Mode.
  @IBAction func startupModeChanged(_ sender: NSComboBox) {
    let indexNumber = startupModeField.indexOfItem(withObjectValue: startupModeField.stringValue)
    UserDefaults.standard.set(indexNumber, forKey: kMSStartTargetKey)
  }
    
  // Authentication
    func showSignInController(action: AuthenticationViewController.AuthAction) {
        currentAction = action
        self.performSegue(withIdentifier: "ShowSignIn", sender: self)
        print("0131-4")
    }
    @IBAction func loginClicked(_ sender: NSButton) {
        showSignInController(action: AuthenticationViewController.AuthAction.login)
        print("0131-2")
    }
    @IBAction func signoutClicked(_ sender: NSButton) {
        showSignInController(action: AuthenticationViewController.AuthAction.signout)
        print("0131-3")
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let signInController = segue.destinationController as? AuthenticationViewController {
            signInController.action = currentAction
        }
        print("0131-1")
    }

    

}
