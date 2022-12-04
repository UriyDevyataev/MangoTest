//
//  SelectCountryViewController.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 03.12.2022.
//

import UIKit

struct Country {
    let region: String
    let name: String
    let code: String
}

protocol SelectCountryViewControllerDelegate: AnyObject {
    func selectedCountry(_ country: Country, sender: SelectCountryViewController)
}

class SelectCountryViewController: UIViewController {
    
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource = [Country]()
    
    weak var delegate: SelectCountryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDataSource()
        config()
    }
    
    // MARK: - Configuration
    
    private func config() {
        configSearchbar()
        configTableView()
    }
    
    private func configSearchbar() {
        topView.backgroundColor = .white
        cancelButton.setTitle("cancel".localized, for: .normal)
        
        searchBar.delegate = self
        searchBar.searchTextField.returnKeyType = .search
    }
    
    private func configTableView() {
        tableView.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            StandartTableViewCell.self,
            forCellReuseIdentifier: StandartTableViewCell.identifier)
    }
    
    // MARK: - Create and update DataSource
    
    private func createDataSource() {
        Locale.isoRegionCodes.forEach {
            if let name = Locale.current.localizedString(forRegionCode: $0),
               let code = countryPrefixes[$0] {
                
                let country = Country(region: $0, name: name, code: "\(code)")
                dataSource.append(country)
            }
        }
        
        dataSource = dataSource.sorted { $0.name < $1.name }
    }
    
    private func updateDataSource(for searchText: String) {
        dataSource = dataSource.filter { $0.name.hasPrefix(searchText) }
        
        if searchText == "" {
            createDataSource()
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Actions
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SelectCountryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateDataSource(for: searchText)
    }
}

// MARK: - UITableViewDataSource
extension SelectCountryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.deqReusCell(StandartTableViewCell.self, indexPath: indexPath)
        else { return UITableViewCell() }
        let country = dataSource[indexPath.row]
        cell.setCell(leftText: country.name, rightText: "+\(country.code)")
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectCountryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = dataSource[indexPath.row]
        delegate?.selectedCountry(country, sender: self)
        dismiss(animated: true)
    }
}
