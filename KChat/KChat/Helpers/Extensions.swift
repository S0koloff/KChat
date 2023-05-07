//
//  Extensions.swift
//  KChat
//
//  Created by Sokolov on 27.03.2023.
//

import UIKit


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    var isValidPass: Bool {
        NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z\\d]{6,}$").evaluate(with: self)
    }
    
    var isValidId: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]{2,15}").evaluate(with: self)
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
