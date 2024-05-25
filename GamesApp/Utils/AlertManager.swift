import UIKit

class AlertManager {
    static func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    
    static func showError(on viewController: UIViewController, error: APIError) {
        showAlert(on: viewController, title: "Error", message: error.localizedDescription)
    }
}
