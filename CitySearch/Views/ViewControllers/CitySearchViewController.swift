import UIKit

class CitySearchViewController: UIViewController {
    private let searchBarContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search cities"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let gpsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "1.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(gpsButtonTapped), for: .touchUpInside)
        return button
    }()

    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityCell")
        return tableView
    }()

    private var cityResults: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "City Search"
        setupNavigationBarAppearance()
        setupNavigationBar()
        setupUI()

        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavigationBarAppearance() {
             if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .systemTeal
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 20, weight: .bold)
                ]
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
            } else {
                
                navigationController?.navigationBar.barTintColor = .systemTeal
                navigationController?.navigationBar.titleTextAttributes = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 20, weight: .bold)
                ]
            }
            navigationController?.navigationBar.tintColor = .white
        }

    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func gpsButtonTapped() {
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }

    @objc private func searchButtonTapped() {
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchCities(query: query)
    }

    private func setupUI() {
        view.addSubview(searchBarContainer)
        searchBarContainer.addSubview(searchBar)
        searchBarContainer.addSubview(gpsButton)
        view.addSubview(searchButton)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            // Search Bar Container
            searchBarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBarContainer.heightAnchor.constraint(equalToConstant: 44),

            // Search Bar
            searchBar.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: gpsButton.leadingAnchor, constant: -8),
            searchBar.topAnchor.constraint(equalTo: searchBarContainer.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchBarContainer.bottomAnchor),

            // GPS Button
            gpsButton.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor),
            gpsButton.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor),
            gpsButton.widthAnchor.constraint(equalToConstant: 30),
            gpsButton.heightAnchor.constraint(equalToConstant: 30),

            // Search Button
            searchButton.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 16),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 100),
            searchButton.heightAnchor.constraint(equalToConstant: 44),

            // Table View
            tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchCities(query: String) {
        NetworkController.fetchCities(query: query) { [weak self] result in
            switch result {
            case .success(let cities):
                self?.cityResults = cities
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension CitySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchCities(query: query)
    }
}

extension CitySearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: cityResults[indexPath.row])
        return cell
    }
}
