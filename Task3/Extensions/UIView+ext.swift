//
//  UIView+ext.swift
//  Task3
//
//  Created by Вадим Сайко on 21.12.22.
//

import UIKit

extension UIView {
    func shake(for duration: TimeInterval = 0.8, withTranslation translation: CGFloat = 5) {
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3) { [weak self] in
            self?.transform = CGAffineTransform(translationX: 0, y: translation)
        }
        propertyAnimator.addAnimations({ [weak self] in
            self?.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.2)
        propertyAnimator.startAnimation()
    }
}
