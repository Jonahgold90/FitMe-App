//
//  BikingWorkoutViewController.swift
//  Calculator
//
//  Created by Jonah Goldberg on 4/6/23.
//

import UIKit

class BikingWorkoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    

    @IBOutlet var milesLabel: UILabel!
    
    @IBOutlet var milesStepper: UIStepper!
    

    @IBOutlet weak var durationPickerView: UIPickerView!
    
    @IBOutlet weak var countdownLabel: UILabel!
    
    
    @IBOutlet weak var startButton: UIButton!
    
    
    
    //Array to hold all time intervals for the up picker
    let durations = ["5 mins", "10 mins", "15 mins", "20 mins", "30 mins", "45 mins", "60 mins"]
    
    var countdownTimer: Timer?
    var remainingTime: TimeInterval = 0
    var previousRemainingTime: TimeInterval = 0
    var stepValue: Double = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        durationPickerView.delegate = self
        durationPickerView.dataSource = self
        
        milesStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        milesStepper.addTarget(self, action: #selector(stepperTouched(_:)), for: .touchDownRepeat)
        
        startButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        countdownLabel.numberOfLines = 0
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        // Update the miles label with the new stepper value
        milesLabel.text = "\(Int(sender.value)) miles"
    }
    
    @objc func stepperTouched(_ sender: UIStepper) {
        // Increment or decrement the stepper value by the step value
        if sender.isContinuous {
            sender.value += stepValue
        } else {
            sender.value += sender.stepValue
        }
        stepperValueChanged(sender)
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
