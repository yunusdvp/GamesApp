import UIKit

extension UIView {
    func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        // Koyu mavi ve mor renkleri ayarlayın
        gradientLayer.colors = [
            UIColor(red: 0/255, green: 0/255, blue: 128/255, alpha: 1).cgColor, // Koyu mavi
            UIColor(red: 128/255, green: 0/255, blue: 128/255, alpha: 1).cgColor // Mor
        ]
        
        // Gradientin başlangıç ve bitiş noktalarını ayarlayın
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.applyGradientBackground()
    }
}
