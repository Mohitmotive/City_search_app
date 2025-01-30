import UIKit

class WelcomeScreenVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let introLabel = UILabel()
        introLabel.text = "Welcome to City Search!"
        introLabel.font = UIFont.boldSystemFont(ofSize: 24)
        introLabel.textColor = .black
        introLabel.textAlignment = .center
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(introLabel)
        
        let button = UIButton(type: .system)
        button.setTitle("Start Searching", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startSearching), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            introLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 20),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func startSearching() {
        let citySearchVC = CitySearchVC()
        let navigationController = UINavigationController(rootViewController: citySearchVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
