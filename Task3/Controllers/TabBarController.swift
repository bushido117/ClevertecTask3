//
//  TabBarController.swift
//  Task3
//
//  Created by Вадим Сайко on 19.12.22.
//

import UIKit

final class TabBarController: UITabBarController {
    private enum Tabs: String {
        case contacts = "contacts_title"
        case favourites = "favourites_title"
        var iconName: String {
            switch self {
            case .contacts:
                return "person"
            case .favourites:
                return "heart"
            }
        }
        var selectedIconName: String {
            switch self {
            case .contacts:
                return "person.fill"
            case .favourites:
                return "heart.fill"
            }
        }
    }
    private var customContactsImageView = UIImageView()
    private var customFavouritesImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupCustomImageViews()
    }
    private func setupTabBar() {
        let contactsController = ContactsViewController()
        let favouritesController = FavouritesViewController()
        let contactsNavigation = UINavigationController(rootViewController: contactsController)
        let favouritesNavigation = UINavigationController(rootViewController: favouritesController)
        contactsController.tabBarItem = UITabBarItem(title: NSLocalizedString(Tabs.contacts.rawValue, comment: ""),
                                                     image: UIImage(systemName: Tabs.contacts.iconName),
                                                     selectedImage: UIImage(systemName: Tabs.contacts.selectedIconName))
        contactsController.tabBarItem.tag = 0
        favouritesController.tabBarItem = UITabBarItem(title: NSLocalizedString(Tabs.favourites.rawValue, comment: ""),
                                                     image: UIImage(systemName: Tabs.favourites.iconName),
                                                     selectedImage:
                                                       UIImage(systemName: Tabs.favourites.selectedIconName))
        favouritesController.tabBarItem.tag = 1
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.borderColor = UIColor.black.cgColor
        tabBar.layer.borderWidth = 1
        tabBar.layer.masksToBounds = true

        setViewControllers([contactsNavigation, favouritesNavigation], animated: true)
    }
    private func setupCustomImageViews() {
        var itemView = tabBar.subviews[0]
        guard let imageView = itemView.subviews.first as? UIImageView else { return }
        customContactsImageView = imageView
        customContactsImageView.contentMode = .center
        itemView = tabBar.subviews[1]
        guard let imageView = itemView.subviews.first as? UIImageView else { return }
        customFavouritesImageView = imageView
        customFavouritesImageView.contentMode = .center
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            customContactsImageView.shake()
        } else {
            customFavouritesImageView.shake()
        }
    }
}
