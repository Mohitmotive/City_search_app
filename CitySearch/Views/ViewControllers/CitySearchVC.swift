import UIKit
import SVProgressHUD

class CitySearchVC: UIViewController {
    private let viewModel = CitySearchVM()
    
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
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let gpsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "1.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(gpsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "CityCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupNavigationBarAppearance()
        setupUI()
        setupBindings()
        configureSVProgressHUD()
    }
    
    private func setupUI() {
        title = "City Search"
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(gpsButton)
        view.addSubview(searchButton)
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            gpsButton.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -8),
            gpsButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            gpsButton.widthAnchor.constraint(equalToConstant: 30),
            gpsButton.heightAnchor.constraint(equalToConstant: 30),
            
            searchButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 150),
            searchButton.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    private func setupBindings() {
        viewModel.onCitiesUpdated = { [weak self] in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                SVProgressHUD.showError(withStatus: errorMessage)
            }
        }
    }
    
    private func configureSVProgressHUD() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }
    
    @objc private func gpsButtonTapped() {
        let mapVC = MapVC()
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc private func searchButtonTapped() {
        guard let query = searchBar.text, !query.isEmpty else {
            viewModel.resetToDummyData()
            return
        }
        SVProgressHUD.show(withStatus: "Searching...")
        viewModel.fetchCities(query: query)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension CitySearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = viewModel.city(at: indexPath.row)
        let detailVC = CityDetailPopupVC(city: selectedCity)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension CitySearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cityCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        let city = viewModel.city(at: indexPath.row)
        cell.configure(with: city)
        return cell
    }
}

extension CitySearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            viewModel.resetToDummyData()
            return
        }
        SVProgressHUD.show(withStatus: "Searching...")
        viewModel.fetchCities(query: query)
    }
}
