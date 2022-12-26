//
//  PushViewController.swift
//  Task3
//
//  Created by Вадим Сайко on 22.12.22.
//

import UIKit
import SnapKit

protocol PushViewControllerDelegate: AnyObject {
    func editContact(_ model: inout ContactModel, row: Int)
}

final class PushViewController: UIViewController {
    let container = PushControllerView()
    var indexPathRow = 0
    weak var delegate: PushViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(container)
        setConstraints()
        setupNavBar()
        container.phoneNumberTextField.delegate = self
        container.familyNameTextField.delegate = self
        container.givenNameTextField.delegate = self
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) { [weak self] _ in
            self?.view.frame.origin.y = -200
        }
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) { [weak self] _ in
            self?.view.frame.origin.y = 0
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func setEditing (_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.editButtonItem.title = "Save"
            container.familyNameTextField.isUserInteractionEnabled = true
            container.givenNameTextField.isUserInteractionEnabled = true
            container.phoneNumberTextField.isUserInteractionEnabled = true
        } else {
            self.editButtonItem.title = "Edit"
            container.familyNameTextField.isUserInteractionEnabled = false
            container.givenNameTextField.isUserInteractionEnabled = false
            container.phoneNumberTextField.isUserInteractionEnabled = false
            var model = ContactModel(
                givenName: container.givenNameTextField.text ?? "",
                familyName: container.familyNameTextField.text ?? "",
                phoneNumber: container.phoneNumberTextField.text ?? "",
                imageData: (container.iconImageView.image?.pngData()) ?? Data(),
                isFavourite: false)
            delegate?.editContact(&model, row: indexPathRow)
        }
    }
    func setupNavBar() {
        navigationItem.rightBarButtonItem = self.editButtonItem
        navigationController?.navigationBar.backgroundColor = .white
        title = NSLocalizedString("detail_title", comment: "")
    }
    private func setConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension PushViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == container.phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.formatter()
            return false
        }
        return true
    }
}
