//
//  SceneDelegate.swift
//  Task3
//
//  Created by Вадим Сайко on 19.12.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
        self.window = window
    }
}
