//
//  CityTableViewCell.swift
//  CitySearch
//
//  Created by Mohit Kumar on 21/01/25.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stateNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(stateNameLabel)
        contentView.addSubview(countryNameLabel)

        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            stateNameLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 4),
            stateNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stateNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            countryNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countryNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with city: City) {
        cityNameLabel.text = city.topographicalName
        stateNameLabel.text = city.administrativeRegion
        countryNameLabel.text = city.countryName
    }
}
