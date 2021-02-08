//
//  ViewController.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: BaseDetailVC, UIGestureRecognizerDelegate {
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var scrollView: CornerScroll!
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var detailsCollection: UICollectionView!
    @IBOutlet weak var detailsCollectionFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var clearHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelForecast: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var cardFeelsLike: DetailsView!
    @IBOutlet weak var cardTempMin: DetailsView!
    @IBOutlet weak var cardTempMax: DetailsView!
    @IBOutlet weak var cardHumidity: DetailsView!
    @IBOutlet weak var cardSunRise: DetailsView!
    @IBOutlet weak var cardSunSet: DetailsView!
    @IBOutlet weak var dayOne: NextDaysView!
    @IBOutlet weak var dayTwo: NextDaysView!
    @IBOutlet weak var dayThree: NextDaysView!
    @IBOutlet weak var dayFour: NextDaysView!
    @IBOutlet weak var dayFive: NextDaysView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var suportView: UIView!
    @IBOutlet weak var contentBackgroundView: CornerView!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var lineDetails: UIView!
    @IBOutlet weak var labelNextDays: UILabel!
    @IBOutlet weak var lineNextDays: UIView!
    
    var heightConstant: CGFloat = 0
    fileprivate var lastContentOffset: CGFloat = 0
    fileprivate var newOffset = CGPoint(x: 0, y: 0)
    var backgroundImageHeroId = ""
    var weather: Weather? = nil
    var forecast: Forecast? = nil
    var forecastHours: [ForecastHour] = []
    var time = 0
    var color = UIColor.white
    var secondaryColor = UIColor.white
    var secondaryAccentColor = UIColor.white
    var backgroundColor = UIColor.white

    override func viewDidLoad() {
        super.viewDidLoad()
        time = (weather?.dt ?? 0) - (weather?.timezone ?? 0)
        color = time.intervalToDate().getPrimaryColor()
        secondaryColor = time.intervalToDate().getSecondaryColor()
        secondaryAccentColor = time.intervalToDate().getSecondaryAccentColor()
        backgroundColor = time.intervalToDate().getBackgroundColor()
        setupCollection()
        setupScroll()
        setupView()
        backgroundImage.heroID = backgroundImageHeroId
        animateFade(labels: [labelTemp, labelForecast])
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func animateFade(labels: [UILabel]) {
        for label in labels {
            label.alpha = 0.0
            UIView.animate(withDuration: 1) { () -> Void in
                label.alpha = 1.0
            }
        }
    }
    
    func setupCollection() {
        detailsCollectionFlow.minimumLineSpacing = 20
        detailsCollection.register(type: HourCell.self)
    }

    func setupScroll() {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            let topPadding = window.safeAreaInsets.top
            heightConstant = topPadding + headerStackView.bounds.height
            clearHeightConstant.constant = -(heightConstant)
            }
        scrollView.delegate = self
    }
    
    override func render(_ viewState: DetailViewState) {
        switch viewState {
        case .initial(_):
            mutate(.getHours(forecast!))
            mutate(.getDays(forecast!))
        case let .resultDays(days):
            setupNextDays(days)
            labelNextDays.text = "Próximos \(days.count) dias"
        case let .resultHours(hours):
            forecastHours = hours
            detailsCollection.reloadData()
        }
    }
    
    private func setupView() {
        guard let safeWeather = weather else { return }
        let time = (safeWeather.dt ?? 0) - (safeWeather.timezone ?? 0)
        backgroundImage.image = time.intervalToDate().getDayPeriod()
        setupText(weather: safeWeather)
        setupUIColor()
        setupCards(safeWeather)
    }
    
    private func setupText(weather: Weather) {
        labelCity.text = weather.name
        labelTemp.text = weather.main.temp?.toCelsius()
        labelForecast.text = weather.weather.first?.weatherDescription
    }
    
    private func setupUIColor() {
        backButton.tintColor = secondaryColor
        labelCity.textColor = color
        labelTemp.textColor = secondaryColor
        labelForecast.textColor = secondaryColor
        labelDetails.textColor = secondaryAccentColor
        labelNextDays.textColor = secondaryAccentColor
        lineDetails.backgroundColor = secondaryAccentColor
        lineNextDays.backgroundColor = secondaryAccentColor
        contentBackgroundView.backgroundColor = secondaryColor.withAlphaComponent(0.6)
        suportView.backgroundColor = secondaryColor.withAlphaComponent(0.6)
        contentView.backgroundColor = backgroundColor
    }
    
    private func setupCards(_ safeWeather: Weather) {
        let time = (safeWeather.dt ?? 0) - (safeWeather.timezone ?? 0)
        let color = time.intervalToDate().getPrimaryColor()
        cardFeelsLike.render(title: "Sensação",
                             value: safeWeather.main.feelsLike?.toCelsius() ?? "",
                             image: UIImage(systemName: "sun.min.fill")!, color: color)
        cardTempMin.render(title: "Temp. Min",
                             value: safeWeather.main.tempMin?.toCelsius() ?? "",
                             image: UIImage(systemName: "sun.min")!, color: color)
        cardTempMax.render(title: "Temp. Max",
                             value: safeWeather.main.tempMax?.toCelsius() ?? "",
                             image: UIImage(systemName: "sun.max")!, color: color)
        cardHumidity.render(title: "Humidade",
                            value: safeWeather.main.humidity?.toPercentage() ?? "",
                            image: UIImage(systemName: "drop")!, color: color)
        cardSunRise.render(title: "Nascer do sol",
                           value: safeWeather.sys.sunrise?.intervalToString() ?? "",
                           image: UIImage(systemName: "sunrise")!, color: color)
        cardSunSet.render(title: "Pôr do sol",
                          value: safeWeather.sys.sunset?.intervalToString() ?? "",
                          image: UIImage(systemName: "sunset")!, color: color)
    }
    
    private func setupNextDays(_ days: [ForecastDay]) {
        if 0 < days.count {
            dayOne.render(title: days[0].day.dateFormatted(), value: days[0].temp.toCelsiusRedonded(), image: days[0].icon, imageColor: color, defaultColor: secondaryAccentColor)
        } else {
            dayOne.isHidden = true
        }
        if 1 < days.count {
            dayTwo.render(title: days[1].day.dateFormatted(), value: days[1].temp.toCelsiusRedonded(), image: days[1].icon, imageColor: color, defaultColor: secondaryAccentColor)
        } else {
            dayTwo.isHidden = true
        }
        if 2 < days.count {
            dayThree.render(title: days[2].day.dateFormatted(), value: days[2].temp.toCelsiusRedonded(), image: days[2].icon, imageColor: color, defaultColor: secondaryAccentColor)
        } else {
            dayThree.isHidden = true
        }
        if 3 < days.count {
            dayFour.render(title: days[3].day.dateFormatted(), value: days[3].temp.toCelsiusRedonded(), image: days[3].icon, imageColor: color, defaultColor: secondaryAccentColor)
        } else {
            dayFour.isHidden = true
        }
        if 4 < days.count {
            dayFive.render(title: days[4].day.dateFormatted(), value: days[4].temp.toCelsiusRedonded(), image: days[4].icon, imageColor: color, defaultColor: secondaryAccentColor)
        } else {
            dayFive.isHidden = true
        }
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableHero()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableHero()
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastHours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HourCell = collectionView.dequeueReusableCell(indexPath)
        cell.render(date: forecastHours[indexPath.row].hour.dateFormattedHour(), temp: forecastHours[indexPath.row].temp, image: forecastHours[indexPath.row].icon, color: color, accentColor: secondaryAccentColor)
        return cell
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.lastContentOffset < clearView.bounds.height && self.lastContentOffset > 0 && scrollView == self.scrollView {
            scrollView.setContentOffset(newOffset, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if (self.lastContentOffset > scrollView.contentOffset.y) {
                newOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
            }
            else if (self.lastContentOffset < scrollView.contentOffset.y) {
                newOffset = CGPoint(x: scrollView.contentOffset.x, y: clearView.bounds.height)
            }
            if scrollView.contentOffset.y == 0 {
                contentStackView.isHidden = true
            } else {
                contentStackView.isHidden = false
            }

            self.lastContentOffset = scrollView.contentOffset.y
        }
    }
}

