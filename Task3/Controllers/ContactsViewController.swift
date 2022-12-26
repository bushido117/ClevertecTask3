//
//  ViewController.swift
//  Task3
//
//  Created by Вадим Сайко on 19.12.22.
//

import UIKit
import Contacts
import SnapKit

final class ContactsViewController: UIViewController {
    private let userDefaults = UserDefaults()
    private let store = CNContactStore()
    private var contacts = [ContactModel]()
    private var favouritesVC: FavouritesViewController {
            guard let navVC = tabBarController?.viewControllers?[1]
                    as? UINavigationController else { return FavouritesViewController() }
            guard let favVC = navVC.topViewController
                    as? FavouritesViewController else { return FavouritesViewController() }
            return favVC
        }
    private lazy var uploadContactsButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 185, height: 50)
        button.setTitle("Upload contacts", for: .normal)
        button.configuration = .bordered()
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(uploadContacts), for: .touchUpInside)
        return button
    }()
    private lazy var contactsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContactsTableViewCell.self,
                           forCellReuseIdentifier: String(describing: ContactsTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addGestureRecognizer(longPressGesture)
        return tableView
    }()
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.minimumPressDuration = 0.5
        gesture.delaysTouchesBegan = true
        gesture.addTarget(self, action: #selector(handleLongPress(_:)))
        return gesture
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavBar()
        isFirstLaunch()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uploadContactsButton.center = view.center
    }
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .systemBackground
        title = NSLocalizedString("contacts_title", comment: "")
    }
    private func setConstraints() {
        contactsTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func isFirstLaunch() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        if userDefaults.bool(forKey: "firstLaunch") {
            DispatchQueue.global().async { [weak self] in
                self?.contacts = ContactModel.writeContacts(forFavourites: false)
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
                self?.view.addSubview(self?.contactsTableView ?? UITableView())
                self?.setConstraints()
            }
        } else {
            view.addSubview(uploadContactsButton)
        }
    }
    @objc private func uploadContacts() {
        DispatchQueue.global().async { [weak self] in
            self?.store.requestAccess(for: .contacts) { [weak self] isAllowed, _ in
                if isAllowed == true {
                    self?.contacts = ContactModel.fetchContacts()
                    DispatchQueue.main.async { [weak self] in
                        self?.uploadContactsButton.removeFromSuperview()
                        self?.view.addSubview(self?.contactsTableView ?? UITableView())
                        self?.setConstraints()
                        self?.userDefaults.set(true, forKey: "firstLaunch")
                        DispatchQueue.global().async { [weak self] in
                            ContactModel.saveContacts(self?.contacts ?? [ContactModel]())
                        }
                        self?.contactsTableView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.contactsAccessDenied()
                    }
                }
            }
        }
    }
    private func contactsAccessDenied() {
        let alertController = UIAlertController(
            title: "Allow access to your contacts",
            message: "Go to setting and allow access",
            preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }
        let point = gestureRecognizer.location(in: contactsTableView)
        guard let indexPath = contactsTableView.indexPathForRow(at: point) else { return }
        longPressureAlert(indexPath: indexPath)
    }
    private func longPressureAlert(indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        let alertController = UIAlertController(
            title: contact.givenName + " " + contact.familyName,
            message: nil,
            preferredStyle: .alert)
        let copyNumberAction = UIAlertAction(title: "Copy phone number", style: .default) { _ in
            UIPasteboard.general.string = contact.phoneNumber
        }
        let shareNumberAction = UIAlertAction(title: "Share phone number", style: .default) { [weak self] _ in
            let activityController = UIActivityViewController(
                activityItems: [contact.phoneNumber],
                applicationActivities: nil)
            self?.present(activityController, animated: true)
        }
        let deleteContactAction = UIAlertAction(title: "Delete contact", style: .destructive) { [weak self] _ in
            if contact.isFavourite == true {
                self?.favouritesVC.favourites.removeAll { contactModel in
                    contactModel.phoneNumber == contact.phoneNumber
                }
            }
            self?.contacts.remove(at: indexPath.row)
            DispatchQueue.global().async { [weak self] in
                ContactModel.saveContacts(self?.contacts ?? [ContactModel]())
            }
            self?.contactsTableView.reloadData()
            if self?.contacts.count == 0 {
                self?.userDefaults.set(false, forKey: "firstLaunch")
                self?.contactsTableView.removeFromSuperview()
                self?.view.addSubview(self?.uploadContactsButton ?? UIButton())
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(copyNumberAction)
        alertController.addAction(shareNumberAction)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteContactAction)
        present(alertController, animated: true)
    }
    func heartButtonTapped(_ model: ContactModel) {
        let model = model
        if !favouritesVC.favourites.contains(where: { contactModel in
            contactModel.phoneNumber == model.phoneNumber
        }) {
            model.isFavourite = true
            favouritesVC.favourites.append(model)
        } else {
            model.isFavourite = false
            favouritesVC.favourites.removeAll { contactModel in
                contactModel.phoneNumber == model.phoneNumber
            }
        }
        DispatchQueue.global().async { [weak self] in
            ContactModel.saveContacts(self?.contacts ?? [ContactModel]())
        }
        contactsTableView.reloadData()
    }
}

// MARK: - TableViewDataSource
extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactsTableViewCell.self))
                as? ContactsTableViewCell else { return UITableViewCell() }
        cell.setProperties(model: contacts[indexPath.row])
        cell.heartButtonTap = { [weak self] in
            if let contacts = self?.contacts {
                self?.heartButtonTapped((contacts[indexPath.row]))
            }
        }
        return cell
    }
}

// MARK: - TableViewDelegate
extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pushVC = PushViewController()
        pushVC.delegate = self
        show(pushVC, sender: nil)
        pushVC.container.setProperties(model: contacts[indexPath.row])
        pushVC.indexPathRow = indexPath.row
    }
}

// MARK: - PushViewControllerDelegate
extension ContactsViewController: PushViewControllerDelegate {
    func editContact(_ model: inout ContactModel, row: Int) {
        model.isFavourite = contacts[row].isFavourite
        contacts[row] = model
        contactsTableView.reloadData()
        DispatchQueue.global().async { [weak self] in
            ContactModel.saveContacts(self?.contacts ?? [ContactModel]())
        }
        let favouriteContacts = contacts.filter { contactModel in
            contactModel.isFavourite == true
        }

        favouritesVC.favourites = favouriteContacts
    }
}
