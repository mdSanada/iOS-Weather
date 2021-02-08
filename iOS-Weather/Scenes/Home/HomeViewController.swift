//
//  HomeViewController.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import CoreLocation

protocol HomeDelegate {
    func navigateToDetails(weather: Weather, forecast: Forecast, indexPath: IndexPath)
    func pushSearch(controller: HomeViewController)
}

class HomeViewController: BaseHomeVC {
    @IBOutlet weak var locationCollection: UICollectionView!
    @IBOutlet weak var locationColletionFlow: UICollectionViewFlowLayout!    
    @IBOutlet weak var searchBar: UISearchBar!
    var delegate: HomeDelegate!
    var weathers: [Weather] = []
    var myWeathersIsLoading: [Bool] = []
    var weatherIsLoading: [Bool] = []
    var myWeathers: [Weather] = []
    let recommended = [Coordinate(lat: "40", lon: "-73"),Coordinate(lat: "35", lon: "139"), Coordinate(lat: "49", lon: "123")]
    var actualLocation = Coordinate(lat: "00", lon: "00")
    let loadingView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    var locationManager: CLLocationManager?

    var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
                setupLoadingView()
            } else {
                loadingView.removeFromSuperview()
                activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationCollection.register(type: LocationCell.self)
        locationCollection.register(type: HeaderLocationCell.self)
        locationColletionFlow.headerReferenceSize = CGSize(width: self.locationCollection.frame.size.width, height: 60)
        searchBar.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.delegate.pushSearch(controller: self)
        }).disposed(by: disposeBag)
    }
    
    func setupLoadingView() {
        loadingView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        activityIndicator.style = .large
        loadingView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
    }
    
    override func render(_ viewState: HomeViewState) {
        switch viewState {
        case .initial(_):
            let agent = UserAgent.shared.getData()
            actualLocation = Coordinate(lat: agent.latitude, lon: agent.longitude)
            mutate(.getActualWeather(actualLocation))
            mutate(.getRecommendedWeather(recommended))
        case let .isLoading(loading):
            isLoading = loading
        case let .successActual(weather):
            self.myWeathersIsLoading.append(false)
            self.myWeathers.insert(weather, at: 0)
        case let .successRecommended(weather):
            weatherIsLoading.append(false)
            self.weathers.append(weather)
            self.mutate(.checkStatus(myWeathers.first, weathers, self.recommended.count))
        case .success:
            locationCollection.reloadData()
        case let .successForecast(forecast, indexPath):
            if indexPath.section == 0 {
                delegate.navigateToDetails(weather: myWeathers[indexPath.row], forecast: forecast, indexPath: indexPath)
            } else {
                delegate.navigateToDetails(weather: weathers[indexPath.row], forecast: forecast, indexPath: indexPath)
            }
        case let .successChosed(success):
            self.myWeathers.append(success)
            self.myWeathersIsLoading.append(false)
            self.locationCollection.reloadData()
        case let .error(error):
            isLoading = false
            Alert.shared.show(message: "Erro ao carregar dados", controller: self, handler: {()})
        case .errorForecast(_):
            isLoading = false
            Alert.shared.show(message: "Erro ao carregar dados", controller: self, handler: {()})
        case .errorChosed(_):
            isLoading = false
            Alert.shared.show(message: "Erro ao carregar dados", controller: self, handler: {()})
        }
    }
}

extension HomeViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationCollection.reloadData()
        searchBar.resignFirstResponder()
        enableHero()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        weatherIsLoading.enumerated().forEach { (index, _) in
            weatherIsLoading[index] = false
        }
        myWeathersIsLoading.enumerated().forEach { (index, _) in
            myWeathersIsLoading[index] = false
        }
        disableHero()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        locationCollection.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            weatherIsLoading.enumerated().forEach { (index, _) in
                weatherIsLoading[index] = false
            }
            for (index, _) in myWeathersIsLoading.enumerated() {
                if (index) == indexPath.row {
                    myWeathersIsLoading[index] = true
                } else {
                    myWeathersIsLoading[index] = false
                }
            }
            if let lat = myWeathers[indexPath.row].coord.lat, let lon = myWeathers[indexPath.row].coord.lon {
                mutate(.getForecast(indexPath, lat: String(lat), lon: String(lon)))
            }
        } else {
            myWeathersIsLoading.enumerated().forEach { (index, _) in
                myWeathersIsLoading[index] = false
            }
            for (index, _) in weatherIsLoading.enumerated() {
                if (index) == indexPath.row {
                    weatherIsLoading[index] = true
                } else {
                    weatherIsLoading[index] = false
                }
            }
            if let lat = weathers[indexPath.row].coord.lat, let lon = weathers[indexPath.row].coord.lon {
                mutate(.getForecast(indexPath, lat: String(lat), lon: String(lon)))
            }
        }
        locationCollection.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? myWeathers.count : weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       viewForSupplementaryElementOfKind kind: String,
                       at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: HeaderLocationCell = collectionView.dequeueReusableCell(indexPath)
        headerView.render(title: (indexPath.section == 0) ? "Sua localização" : "Recomendados")
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LocationCell = collectionView.dequeueReusableCell(indexPath)
        if indexPath.section == 0 {
            let time = (myWeathers[indexPath.row].dt ?? 0) - (myWeathers[indexPath.row].timezone ?? 0)
            let backgroundColor = time.intervalToDate().getSecondaryColor()

            cell.render(city: myWeathers[indexPath.row].name ?? "",
                        country: myWeathers[indexPath.row].sys.country ?? "",
                        temp: Int(myWeathers[indexPath.row].main.temp ?? 0),
                        image: (time.intervalToDate().getDayPeriod()),
                        isLoading: myWeathersIsLoading[indexPath.row],
                        isLocation: indexPath.row == 0,
                        color: backgroundColor)
        } else {
            if weathers.count > indexPath.row {
                let time = (weathers[indexPath.row].dt ?? 0) - (weathers[indexPath.row].timezone ?? 0)
                let backgroundColor = time.intervalToDate().getSecondaryColor()

                cell.render(city: weathers[indexPath.row].name ?? "",
                            country: weathers[indexPath.row].sys.country ?? "",
                            temp: Int(weathers[indexPath.row].main.temp ?? 0),
                            image: (time.intervalToDate().getDayPeriod()),
                            isLoading: weatherIsLoading[indexPath.row], color: backgroundColor)
            }
        }
        cell.selectedBackgroundView?.backgroundColor = .clear
        cell.imageBackground.heroID = "background-\(indexPath.row)-\(indexPath.section)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 40), height: 160)
    }
}

extension HomeViewController: SearchDelegate {
    func appendNewLocation(coordinate: Coordinate) {
        mutate(.getChosedWeather(coordinate))
    }
}
