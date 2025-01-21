import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setupSplashContent()
    }

    private func setupSplashContent() {
        
        let introLabel = UILabel()
        introLabel.text = "Welcome to City Search!"
        introLabel.font = UIFont.boldSystemFont(ofSize: 24)
        introLabel.textColor = .black
        introLabel.textAlignment = .center
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(introLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Search for cities and get information about them."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        let goToCitySearchButton = UIButton(type: .system)
        goToCitySearchButton.setTitle("Go to City Search", for: .normal)
        goToCitySearchButton.setTitleColor(.white, for: .normal)
        goToCitySearchButton.layer.cornerRadius = 8
        goToCitySearchButton.translatesAutoresizingMaskIntoConstraints = false
//        goToCitySearchButton.addTarget(self, action: #selector(navigateToCitySearch), for: .touchUpInside)
        goToCitySearchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToCitySearchButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            introLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            introLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            goToCitySearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToCitySearchButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40)
        ])
    }

//    @objc private func navigateToCitySearch() {
//        let citySearchVC = CitySearchViewController()
//        let navigationController = UINavigationController(rootViewController: citySearchVC)
//        navigationController.modalTransitionStyle = .crossDissolve
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true, completion: nil)
//    }
}


