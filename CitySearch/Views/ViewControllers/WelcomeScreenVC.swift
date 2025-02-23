import UIKit
import Lottie

class WelcomeScreenVC: UIViewController {
    private let welcomeAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "city_search")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        welcomeAnimationView.play()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add the Lottie animation view
        view.addSubview(welcomeAnimationView)

        // Set up constraints for the animation view
        NSLayoutConstraint.activate([
            welcomeAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeAnimationView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            welcomeAnimationView.widthAnchor.constraint(equalToConstant: 200),
            welcomeAnimationView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
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
            introLabel.topAnchor.constraint(equalTo: welcomeAnimationView.bottomAnchor, constant: 5),
            
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
