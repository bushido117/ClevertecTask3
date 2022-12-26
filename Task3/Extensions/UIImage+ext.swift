//
//  UIImage+ext.swift
//  Task3
//
//  Created by Вадим Сайко on 25.12.22.
//

import UIKit

extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
