//
//  Models.swift
//  KChat
//
//  Created by Sokolov on 24.03.2023.
//

import UIKit

final class CustomButton: UIButton {
    
    typealias Action = () -> Void
    
    var title: String
    var titleColor: UIColor
    var backgroundButtonColor: UIColor
    var cornerRadius: CGFloat
    var tapAction: Action
    
    init(title: String, titleColor: UIColor, backgroundButtonColor: UIColor, cornerRadius: CGFloat, action: @escaping Action)  {
        self.title = title
        self.titleColor = titleColor
        self.backgroundButtonColor = backgroundButtonColor
        self.cornerRadius = cornerRadius
        self.tapAction = action
        super.init(frame: .zero)
        
        setTitleColor(titleColor, for: .normal)
        backgroundColor = backgroundButtonColor
        layer.cornerRadius = cornerRadius
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setTitle(title, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        tapAction()
    }
}


