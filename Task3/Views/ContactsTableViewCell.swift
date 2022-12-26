//
//  ContactsTableViewCell.swift
//  Task3
//
//  Created by Вадим Сайко on 20.12.22.
//

import UIKit
import SnapKit

final class ContactsTableViewCell: UITableViewCell {

    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.sizeToFit()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 30 * 0.5
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(red: 0.84, green: 0.85, blue: 0.86, alpha: 1.00)
        return imageView
    }()
    private lazy var namesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.30, green: 0.36, blue: 0.39, alpha: 1.00)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.47, green: 0.52, blue: 0.53, alpha: 1.00)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()
    var heartButtonTap: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = heartButton
        addSubviews()
        setUpConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(namesLabel)
        addSubview(phoneNumberLabel)
    }
    private func setUpConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        namesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.height.equalTo(20)
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(namesLabel.snp.bottom)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.height.equalTo(14)
        }
    }
    func setProperties(model: ContactModel) {
        self.namesLabel.text = model.givenName + " " + model.familyName
        self.phoneNumberLabel.text = model.phoneNumber.formatter()
        if let imageData = model.imageData {
            iconImageView.image = UIImage(data: imageData)?
                .resizeImage(to: CGSize(width: 30, height: 30))
        } else {
            iconImageView.image = UIImage(systemName: "person.crop.circle")?
                .resizeImage(to: CGSize(width: 30, height: 30))
        }
        if model.isFavourite {
            self.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    @objc func heartButtonTapped() {
        heartButtonTap?()
    }
}
