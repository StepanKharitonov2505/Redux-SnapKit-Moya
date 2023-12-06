import UIKit

class InteractiveButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: [
                                .allowUserInteraction,
                                .beginFromCurrentState
                               ]
                ) {
                    self.transform = CGAffineTransform(scaleX: 0.985, y: 0.985)
                    //self.layer.opacity = 0.75
                    //self.alpha = 0.75
                }
            } else {
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: [
                                .allowUserInteraction,
                                .beginFromCurrentState
                               ]
                ) {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    //self.layer.opacity = 1.0
                    //self.alpha = 1
                }
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                print("is Enabled == false")
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: [
                                .allowUserInteraction,
                                .beginFromCurrentState
                               ]
                ) {
                    self.alpha = 0.4
                }
            } else {
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: [
                                .allowUserInteraction,
                                .beginFromCurrentState
                               ]
                ) {
                    self.alpha = 1
                }
            }
        }
    }
}
