//
//  PushControllerView.swift
//  Task3
//
//  Created by Вадим Сайко on 22.12.22.
//

import UIKit
import SnapKit

final class PushControllerView: UIView {

    private lazy var stackViewForLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 18
        return stackView
    }()
    private lazy var stackViewForTextFields: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 3
        return stackView
    }()
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 100 * 0.5
        imageView.backgroundColor = UIColor(red: 0.84, green: 0.85, blue: 0.86, alpha: 1.00)
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var givenNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Given name:"
        label.textAlignment = .center
        return label
    }()
    private lazy var familyNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Family name:"
        label.textAlignment = .center
        return label
    }()
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone number:"
        label.textAlignment = .center
        return label
    }()
    let givenNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your given name"
        textField.borderStyle = .roundedRect
        textField.layer.masksToBounds = true
        textField.isUserInteractionEnabled = false
        return textField
    }()
    let familyNameTextField: UITextField = {
        let textField = UITextField()
        textField.sizeToFit()
        textField.placeholder = "Enter your family name"
        textField.borderStyle = .roundedRect
        textField.layer.masksToBounds = true
        textField.isUserInteractionEnabled = false
        return textField
    }()
    let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.sizeToFit()
        textField.placeholder = "Enter your phone name"
        textField.borderStyle = .roundedRect
        textField.layer.masksToBounds = true
        textField.isUserInteractionEnabled = false
        return textField
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubviews() {
        stackViewForLabels.addArrangedSubview(givenNameLabel)
        stackViewForLabels.addArrangedSubview(familyNameLabel)
        stackViewForLabels.addArrangedSubview(phoneNumberLabel)
        stackViewForTextFields.addArrangedSubview(givenNameTextField)
        stackViewForTextFields.addArrangedSubview(familyNameTextField)
        stackViewForTextFields.addArrangedSubview(phoneNumberTextField)
        containerStackView.addArrangedSubview(stackViewForLabels)
        containerStackView.addArrangedSubview(stackViewForTextFields)
        addSubview(iconImageView)
        addSubview(containerStackView)
    }
    private func setConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
    }
    func setProperties(model: ContactModel) {
        self.givenNameTextField.text = model.givenName
        self.familyNameTextField.text = model.familyName
        self.phoneNumberTextField.text = model.phoneNumber.formatter()
        if let imageData = model.imageData {
            iconImageView.image = UIImage(data: imageData)?
                .resizeImage(to: CGSize(width: 100, height: 100))
        } else {
            iconImageView.image = UIImage(systemName: "person.crop.circle")?
                .resizeImage(to: CGSize(width: 100, height: 100))
        }
    }
}
