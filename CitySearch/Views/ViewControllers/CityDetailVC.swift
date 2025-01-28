import UIKit

class CityDetailPopupVC: UIViewController {
    private let city: City

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let detailsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        return view
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(city: City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayCityDetails()
    }

    private func setupUI() {
        title = city.toponymName
        view.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.2)
        view.addSubview(detailsView)
        detailsView.addSubview(detailsLabel)
        detailsView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            detailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            detailsView.heightAnchor.constraint(equalToConstant: 300), 

            detailsLabel.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16),
            detailsLabel.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -16),

            closeButton.centerXAnchor.constraint(equalTo: detailsView.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: -16)
        ])
    }

    private func displayCityDetails() {
        let details = """
        Name: \(city.toponymName)
        Country: \(city.countryName)
        State/Province: \(city.administrativeRegion)
        Population: \(city.population)
        Latitude: \(city.latitude)
        Longitude: \(city.longitude)
        Feature: \(city.featureCodeName)
        """
        detailsLabel.text = details
    }

    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
