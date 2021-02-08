//
//  ViewController.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 05/02/21.
//

import UIKit

protocol SearchDelegate {
    func appendNewLocation(coordinate: Coordinate)
}

class SearchViewController: BaseSearchVC {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    
    var listLocation: SearchLocationModel = SearchLocationModel(data: [])
    var delegate: SearchDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.rx.text
            .changed
            .filter { ($0?.count ?? 0) > 3 }
            .subscribe(onNext: { value in
                guard let text = value else { return }
                self.mutate(.search(text))
            }).disposed(by: disposeBag)
        
        locationTableView.register(type: SearchCell.self)
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.reloadData()
    }
    
    override func render(_ viewState: SearchViewState) {
        switch viewState {
        case .initial(_):
            break
        case let .isLoading(loading):
            break
        case let .success(value):
            listLocation.data.removeAll()
            listLocation = value
            locationTableView.reloadData()
        case .error(_):
            listLocation.data.removeAll()
            locationTableView.reloadData()
            break
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < listLocation.data.count {
            let chosed = listLocation.data[indexPath.row]
            delegate.appendNewLocation(coordinate: Coordinate(lat: "\(Int(chosed.latitude ?? 0) )", lon: "\(Int(chosed.longitude ?? 0))"))
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listLocation.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCell = tableView.dequeueReusableCell(indexPath)
        let city = listLocation.data[indexPath.row].label ?? ""
        let country = listLocation.data[indexPath.row].region ?? ""
        cell.render(city: city, country: country)
        return cell
    }
}


extension SearchViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
