//
//  RunningWorkoutViewController.swift
//  Calculator
//
//  Created by Jonah Goldberg on 4/6/23.
//

import UIKit
import MapKit
import HealthKit
var healthStore = HKHealthStore()


class RunningWorkoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    //For Ui Picker
    @IBOutlet weak var durationPickerView: UIPickerView!
    //For timer label
    @IBOutlet weak var countdownLabel: UILabel!
    //For start / reset button
    @IBOutlet weak var startButton: UIButton!
    //For displaying number of steps
    @IBOutlet var stepsLabel: UILabel!
    
    //Array to hold all time intervals for the up picker
    let durations = ["5 mins", "10 mins", "15 mins", "20 mins", "30 mins", "45 mins", "60 mins"]
    
    var countdownTimer: Timer?
    var remainingTime: TimeInterval = 0
    var previousRemainingTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        durationPickerView.delegate = self
        durationPickerView.dataSource = self
        
        startButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        countdownLabel.numberOfLines = 0

        
        //Check user authorization for steps
        // Access Step Count
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ]
        // Check for Authorization
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            if (bool) {
                // Authorization Successful
                self.getSteps { (result) in
                    DispatchQueue.main.async {
                        let stepCount = String(Int(result))
                        self.stepsLabel.text = String(stepCount)
                    }
                }
            }
        }
    }
    
    

    @objc func startButtonTapped(_ sender: UIButton) {
          if countdownTimer == nil {
              // Timer is not running, start it
              startTimer()
              let titleAttributes: [NSAttributedString.Key: Any] = [
                      .font: UIFont(name: "GillSans-SemiBold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .semibold),
                      .foregroundColor: UIColor.white
              ]
              let title = NSAttributedString(string: "Pause", attributes: titleAttributes)
              startButton.setAttributedTitle(title, for: .normal)
          } else {
              // Timer is running, pause it
              previousRemainingTime = remainingTime
              countdownTimer?.invalidate()
              countdownTimer = nil
              let titleAttributes: [NSAttributedString.Key: Any] = [
                      .font: UIFont(name: "GillSans-SemiBold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .semibold)
  ,
                      .foregroundColor: UIColor.white
              ]
              let title = NSAttributedString(string: "Resume", attributes: titleAttributes)
                  startButton.setAttributedTitle(title, for: .normal)
        }
    }

    
    func startTimer() {
        guard let selectedRow = durationPickerView?.selectedRow(inComponent: 0) else { return }
        let selectedDuration = durations[selectedRow]
        
        // Extract the time interval from the duration string
        let durationComponents = selectedDuration.split(separator: " ")
        guard durationComponents.count == 2, let durationValue = TimeInterval(durationComponents[0]) else { return }
        
        if previousRemainingTime > 0 {
            // If the timer was paused, use the previous remaining time instead of the original duration value
            remainingTime = previousRemainingTime
        } else {
            remainingTime = durationValue * 60
        }
        
        print("remainingTime = \(remainingTime)") // Add this line
        
        // Start the countdown timer
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.remainingTime -= 1
            print("remainingTime = \(self.remainingTime)") // Add this line
            
            if self.remainingTime == 0 {
                // Timer has finished
                timer.invalidate()
            } else {
                // Update the countdown label with the remaining time
                let minutes = Int(self.remainingTime) / 60
                let seconds = Int(self.remainingTime) % 60
                self.countdownLabel.text = String(format: "%02d:%02d", minutes, seconds)
            }
        }
    }

    
    func getSteps(completion: @escaping (Double) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        var interval = DateComponents()
        interval.day = 1
        //Get current date / time information
        let query = HKStatisticsCollectionQuery(quantityType: type,
        quantitySamplePredicate: nil,
        options: [.cumulativeSum],
        anchorDate: startOfDay,
        intervalComponents: interval)
        query.initialResultsHandler = { _, result, error in
                var resultCount = 0.0
                result!.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in

                if let sum = statistics.sumQuantity() {
                    // Get steps (they are of double type)
                    resultCount = sum.doubleValue(for: HKUnit.count())
                }

                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        query.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in

            // If new statistics are available update it
            if let sum = statistics?.sumQuantity() {
                let resultCount = sum.doubleValue(for: HKUnit.count())
                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        healthStore.execute(query)
    }
    
    // UI Picker View Setup
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durations[row]
    }
    
    
}
