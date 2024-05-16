//
//  AddJournalViewController.swift
//  JRN-CodeOnly
//
//  Created by Jungjin Park on 2024-05-13.
//

import UIKit
import CoreLocation

protocol AddJournalControllerDelegate: NSObject {
    func saveJournalEntry(_ journalEntry: JournalEntry)
}

class AddJournalViewController: UIViewController, CLLocationManagerDelegate {
    weak var delegate: AddJournalControllerDelegate?
    
    private lazy var mainContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 40
        return stackView
    }()

    private lazy var ratingView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 252, height: 44))
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemCyan
        return stackView
    }()

    private lazy var toggleView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        
        let switchComponent = UISwitch()
        let labelComponent = UILabel()
        labelComponent.text = "Switch Label"
        stackView.addArrangedSubview(switchComponent)
        stackView.addArrangedSubview(labelComponent)
        
        return stackView
    }()
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Journal Title"
        return textField
    }()

    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Journal Boddy"
        return textView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "face.smiling")
        return imageView
    }()
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location Manager")
        if let myCurrentLocation = locations.first {
            currentLocation = myCurrentLocation
            print("current location: \(myCurrentLocation.coordinate.latitude), \(myCurrentLocation.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            print("authorized location permission")
        } else {
            print("unauthorized location permission")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "New Entry"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
                
        
        mainContainer.addArrangedSubview(ratingView)
        mainContainer.addArrangedSubview(toggleView)
        mainContainer.addArrangedSubview(titleTextField)
        mainContainer.addArrangedSubview(bodyTextView)
        mainContainer.addArrangedSubview(imageView)
        
        view.addSubview(mainContainer)
        
        let safeArea = view.safeAreaLayoutGuide
        
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            mainContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            mainContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            ratingView.widthAnchor.constraint(equalToConstant: 252),
            ratingView.heightAnchor.constraint(equalToConstant: 44),
            
            titleTextField.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 8),
            titleTextField.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -8),
            
            bodyTextView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 8),
            bodyTextView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -8),
            bodyTextView.heightAnchor.constraint(equalToConstant: 128),
            
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // 스위치 상태 변화 감지
        let switchComponent = toggleView.arrangedSubviews[0] as! UISwitch
        switchComponent.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.requestLocation()
        } else {
            currentLocation = nil
        }
    }
    
    @objc func save() {
        guard let title = titleTextField.text, !title.isEmpty,
              let body = bodyTextView.text, !body.isEmpty else { return }
        let journalEntry = JournalEntry(rating: 3, title: title, body: body, photo: UIImage(systemName: "face.smiling"))!
        delegate?.saveJournalEntry(journalEntry)
        dismiss(animated: true)
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */
}
