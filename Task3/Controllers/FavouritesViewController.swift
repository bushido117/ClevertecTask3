//
//  SecondViewController.swift
//  Task3
//
//  Created by Вадим Сайко on 19.12.22.
//

import UIKit

final class FavouritesViewController: UIViewController {
    var favourites = ContactModel.writeContacts(forFavourites: true) {
        didSet {
            favouritesTableView.reloadData()
        }
    }

    lazy var favouritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContactsTableViewCell.self,
                           forCellReuseIdentifier: String(describing: ContactsTableViewCell.self))
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(favouritesTableView)
        setupNavBar()
        setConstraints()
    }
    private func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        title = NSLocalizedString("favourites_title", comment: "")
    }
    private func setConstraints() {
        favouritesTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactsTableViewCell.self))
                as? ContactsTableViewCell else { return UITableViewCell() }
        cell.setProperties(model: favourites[indexPath.row])
        return cell
    }
}
