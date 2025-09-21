import SVProgressHUD
import UIKit
import Foundation
import SwiftUI
import Combine
import Lottie

class CitySearchVC: UIViewController, UISearchBarDelegate {
    private let viewModel = CitySearchVM(networkService: NetworkService())
    private var floatingChatView: FloatingChatVC?
    private var searchTimer: Timer?
    private var cancellables = Set<AnyCancellable>()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search cities"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(
            self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()

    private let chatbotButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "bubble.left.and.bubble.right.fill"), for: .normal)
            button.tintColor = .white
            button.backgroundColor = .black
            button.layer.cornerRadius = 32
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(chatbotButtonTapped), for: .touchUpInside)
            return button
    }()

    private let gpsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "gps_button.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self, action: #selector(gpsButtonTapped), for: .touchUpInside)
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            CityTableViewCell.self, forCellReuseIdentifier: "CityCell")
        return tableView
    }()

    private let cityDetailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self, action: #selector(closeDropdown), for: .touchUpInside)
        return button
    }()

    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dropdownView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.alpha = 0  
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let cityDetailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let closeDetailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.addTarget(
        self, action: #selector(closeDetailTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var cityDetailViewTopConstraint: NSLayoutConstraint?

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "No internet connection"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true 
        return label
    }()

    private let noResultsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true 
        return view
    }()

    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Results not found"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let noInternetView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let noInternetLabel: UILabel = {
        let label = UILabel()
        label.text = "No Internet Connection"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subheadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Please check your connection and try again."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) 
        return button
    }()

    private let wifiSlashImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "wifi.slash")
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Lottie Animation for Loading
    private let locationAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "search_icon")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.isHidden = true
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupNavigationBarAppearance()
        setupUI()
        configureSVProgressHUD()
        setupFloatingChatButton()

        // Set up closures for handling updates and errors
        viewModel.onCitiesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.locationAnimationView.stop()
                self?.locationAnimationView.isHidden = true
                SVProgressHUD.dismiss()
                self?.tableView.reloadData()
                self?.updateNoResultsLabelVisibility()
            }
        }

        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.locationAnimationView.stop()
                self?.locationAnimationView.isHidden = true
                SVProgressHUD.showError(withStatus: errorMessage)
            }
        }

        // Observe network connectivity
        viewModel.networkMonitor.$isConnected
            .receive(on: RunLoop.main)
            .sink { [weak self] isConnected in
                if !isConnected {
                    self?.showNoInternetBanner()
                } else {
                    self?.hideNoInternetBanner()
                    self?.retrySearchIfNeeded() 
                }
            }
            .store(in: &cancellables)

        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }

    private func setupUI() {
        title = "City Search"
        view.backgroundColor = .white

        let searchContainerView = UIView()
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.addSubview(searchBar)
        searchContainerView.addSubview(gpsButton)
        view.addSubview(searchContainerView)
        view.addSubview(tableView)
        view.addSubview(searchButton)
        view.addSubview(cityDetailView)
        view.addSubview(blurEffectView)
        view.addSubview(dropdownView)
        view.addSubview(chatbotButton)
        view.addSubview(errorLabel)
        view.addSubview(noResultsView)
        view.addSubview(noInternetView)
        view.addSubview(locationAnimationView)

        blurEffectView.frame = view.bounds
        dropdownView.addSubview(closeButton)

        cityDetailView.addSubview(cityDetailLabel)
        cityDetailView.addSubview(closeDetailButton)

        noInternetView.addSubview(noInternetLabel)
        noInternetView.addSubview(subheadingLabel)
        noInternetView.addSubview(retryButton)
        noInternetView.addSubview(wifiSlashImageView)

        noResultsView.addSubview(noResultsLabel)

        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        cityDetailViewTopConstraint = cityDetailView.topAnchor.constraint(
            equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([

            searchContainerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16),
            searchContainerView.heightAnchor.constraint(equalToConstant: 44),

            searchBar.leadingAnchor.constraint(
                equalTo: searchContainerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(
                equalTo: gpsButton.leadingAnchor, constant: -8),
            searchBar.topAnchor.constraint(
                equalTo: searchContainerView.topAnchor),
            searchBar.bottomAnchor.constraint(
                equalTo: searchContainerView.bottomAnchor),

            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            dropdownView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dropdownView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            dropdownView.heightAnchor.constraint(equalToConstant: 250),
            dropdownView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: 250),

            gpsButton.trailingAnchor.constraint(
                equalTo: searchContainerView.trailingAnchor, constant: -8),
            gpsButton.centerYAnchor.constraint(
                equalTo: searchContainerView.centerYAnchor),
            gpsButton.widthAnchor.constraint(equalToConstant: 30),
            gpsButton.heightAnchor.constraint(equalToConstant: 30),

            searchButton.topAnchor.constraint(
                equalTo: searchContainerView.bottomAnchor, constant: 16),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 150),
            searchButton.heightAnchor.constraint(equalToConstant: 44),

            tableView.topAnchor.constraint(
                equalTo: searchButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cityDetailView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16),
            cityDetailView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16),
            cityDetailView.heightAnchor.constraint(equalToConstant: 200),
            cityDetailViewTopConstraint!,

            cityDetailLabel.topAnchor.constraint(
                equalTo: cityDetailView.topAnchor, constant: 16),
            cityDetailLabel.leadingAnchor.constraint(
                equalTo: cityDetailView.leadingAnchor, constant: 16),
            cityDetailLabel.trailingAnchor.constraint(
                equalTo: cityDetailView.trailingAnchor, constant: -16),

            closeDetailButton.topAnchor.constraint(
                equalTo: cityDetailLabel.bottomAnchor, constant: 16),
            closeDetailButton.centerXAnchor.constraint(
                equalTo: cityDetailView.centerXAnchor),
            closeDetailButton.bottomAnchor.constraint(
                equalTo: cityDetailView.bottomAnchor, constant: -16),

            // Floating AI Chatbot Button Constraints
            chatbotButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20),
            chatbotButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            chatbotButton.widthAnchor.constraint(equalToConstant: 64),
            chatbotButton.heightAnchor.constraint(equalToConstant: 64),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            noInternetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noInternetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            noInternetLabel.topAnchor.constraint(equalTo: noInternetView.topAnchor, constant: 10),
            noInternetLabel.centerXAnchor.constraint(equalTo: noInternetView.centerXAnchor),

            subheadingLabel.topAnchor.constraint(equalTo: noInternetLabel.bottomAnchor, constant: 5),
            subheadingLabel.centerXAnchor.constraint(equalTo: noInternetView.centerXAnchor),

            retryButton.topAnchor.constraint(equalTo: subheadingLabel.bottomAnchor, constant: 10),
            retryButton.centerXAnchor.constraint(equalTo: noInternetView.centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: noInternetView.bottomAnchor, constant: -10),

            wifiSlashImageView.topAnchor.constraint(equalTo: retryButton.bottomAnchor, constant: 10),
            wifiSlashImageView.centerXAnchor.constraint(equalTo: noInternetView.centerXAnchor),
            wifiSlashImageView.widthAnchor.constraint(equalToConstant: 40),
            wifiSlashImageView.heightAnchor.constraint(equalToConstant: 40),

            // Constraints for noResultsView
            noResultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noResultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noResultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            noResultsLabel.topAnchor.constraint(equalTo: noResultsView.topAnchor, constant: 10),
            noResultsLabel.centerXAnchor.constraint(equalTo: noResultsView.centerXAnchor),

            // Set up constraints for locationAnimationView
            locationAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            locationAnimationView.widthAnchor.constraint(equalToConstant: 150),
            locationAnimationView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            searchButton.isEnabled = false
            searchButton.backgroundColor = .gray
            viewModel.allCities = []
            tableView.reloadData()
        } else {
            searchButton.isEnabled = true
            searchButton.backgroundColor = .black
            
            searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                locationAnimationView.isHidden = false
                locationAnimationView.play()
                self.viewModel.fetchCities(query: searchText)
            }
        }
    }
    
    private func setupFloatingChatButton() {
            view.addSubview(chatbotButton)

            NSLayoutConstraint.activate([
                chatbotButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                chatbotButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                chatbotButton.widthAnchor.constraint(equalToConstant: 64),
                chatbotButton.heightAnchor.constraint(equalToConstant: 64)
            ])
        }

    private func setupNavigationBarAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            ]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance =
                appearance
        } else {
            navigationController?.navigationBar.barTintColor = .systemTeal
            navigationController?.navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            ]
        }
        navigationController?.navigationBar.tintColor = .white
    }

    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
    }

    private func configureSVProgressHUD() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }

    @objc private func searchButtonTapped() {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        locationAnimationView.isHidden = false // Show Lottie animation
        locationAnimationView.play() // Start playing the animation
        viewModel.fetchCities(query: query)
    }

    private func updateDropdownContent(with city: City) {
        let detailsLabel = UILabel()
        detailsLabel.numberOfLines = 0
        detailsLabel.textAlignment = .center
        detailsLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        detailsLabel.textColor = .black
        detailsLabel.text = """
            Name: \(city.topographicalName)
            Country: \(city.countryName)
            State: \(city.administrativeRegion)
            Population: \(city.population)
            Latitude: \(city.latitude)
            Longitude: \(city.longitude)
            Feature: \(city.featureCodeName)
            """
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        dropdownView.subviews.forEach {
            if $0 != closeButton { $0.removeFromSuperview() }
        }

        dropdownView.addSubview(detailsLabel)
        dropdownView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(
                equalTo: dropdownView.topAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(
                equalTo: dropdownView.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(
                equalTo: dropdownView.trailingAnchor, constant: -16),
            closeButton.bottomAnchor.constraint(
                equalTo: dropdownView.bottomAnchor, constant: -22),
            closeButton.centerXAnchor.constraint(
                equalTo: dropdownView.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(
            target: self, action: #selector(closeDropdown))
        blurEffectView.addGestureRecognizer(tapGesture)
    }

    @objc private func closeDropdown() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.blurEffectView.alpha = 0
                self.dropdownView.transform = CGAffineTransform.identity
                self.dropdownView.alpha = 0
            })
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func chatbotButtonTapped() {
            if floatingChatView == nil {
                let chatView = FloatingChatVC()
                view.addSubview(chatView)
                
                NSLayoutConstraint.activate([
                    chatView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    chatView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    chatView.widthAnchor.constraint(equalToConstant: 300),
                    chatView.heightAnchor.constraint(equalToConstant: 400)
                ])

                floatingChatView = chatView
            } else {
                floatingChatView?.removeFromSuperview()
                floatingChatView = nil
            }
        }
    
    @objc private func gpsButtonTapped() {
        let mapVC = MapVC()
        mapVC.cities = viewModel.allCities
        navigationController?.pushViewController(mapVC, animated: true)
    }

    @objc private func closeDetailTapped() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.cityDetailViewTopConstraint?.constant = 0
                self.view.layoutIfNeeded()
            }
        ) { _ in
            self.cityDetailView.isHidden = true
        }
    }

    private func updateNoResultsLabelVisibility() {
        noResultsView.isHidden = !viewModel.allCities.isEmpty
        tableView.isHidden = viewModel.allCities.isEmpty
    }

    private func showNoInternetBanner() {
        noInternetView.isHidden = false
        searchButton.isEnabled = false
        noResultsView.isHidden = true
        searchBar.isUserInteractionEnabled = false
        viewModel.allCities = []
        tableView.reloadData()
        SVProgressHUD.dismiss()
    }

    private func hideNoInternetBanner() {
        noInternetView.isHidden = true
        searchButton.isEnabled = true
        searchBar.isUserInteractionEnabled = true
    }

    private func retrySearchIfNeeded() {
        if let searchText = searchBar.text, !searchText.isEmpty {
            locationAnimationView.isHidden = false // Show Lottie animation
            locationAnimationView.play() // Start playing the animation
            
            tableView.isHidden = true
            
            viewModel.fetchCities(query: searchText)
        }
    }

    @objc private func retryButtonTapped() {
        if viewModel.networkMonitor.isConnected {
            searchBar.text = "" 
            searchButton.isEnabled = false 
            viewModel.allCities = [] 
            tableView.reloadData() 
            updateNoResultsLabelVisibility() 
        } else {
            checkInternetConnection()
        }
    }

    private func checkInternetConnection() {
        let checkInterval: TimeInterval = 2.0 
        Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { [weak self] timer in
            if self?.viewModel.networkMonitor.isConnected == true {
                timer.invalidate() 
                self?.hideNoInternetBanner() 
                self?.retrySearchIfNeeded() 
            }
        }
    }

}

extension CitySearchVC: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let selectedCity = viewModel.city(at: indexPath.row)
        updateDropdownContent(with: selectedCity)

        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.blurEffectView.alpha = 1
                self.dropdownView.transform = CGAffineTransform(
                    translationX: 0, y: -250)
                self.dropdownView.alpha = 1
            })
    }
}

extension CitySearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return viewModel.cityCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "CityCell", for: indexPath)
            as! CityTableViewCell
        cell.configure(with: viewModel.city(at: indexPath.row))
        return cell
    }
}
