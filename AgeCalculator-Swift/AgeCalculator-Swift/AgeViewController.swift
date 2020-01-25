//
//  AgeViewController.swift
//  AgeCalculator-Swift
//
//  Created by Ben Gohlke on 1/8/2020.
//
// MIT License
// Copyright (c) 2020 Ben Gohlke
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class AgeViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var birthdatePicker: UIDatePicker!
  @IBOutlet weak var currentDateLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var nextBirthdayLabel: UILabel!
  
  // MARK: - Properties
  
  /// We'll need to format several dates, so let's set up a formatter
  /// object that we can reuse.
  var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    
    /// What does "medium style" mean? (hint: copy the value used below
    /// on the right of the assignment operator and open the "Developer Documentation"
    /// window from the Window menu at the top of the screen. Paste the value
    /// to search the Appledoc for it.)
    dateFormatter.dateStyle = .medium
    
    /// How does "no style" differ from the medium style used above?
    /// You can look in the same place in the docs to find the answer.
    dateFormatter.timeZone = .none
    
    return dateFormatter
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Age Calculator"
    updateViews()
  }
  
  // MARK: - Actions
  
  @IBAction func birthdateSelected(sender: UIDatePicker) {
    updateViews()
  }
  
  // MARK: - Private
  
  /// Used each time the view needs to be updated with new date/age values
  private func updateViews() {
    /// Initializing a new date instance provides a date set to the current date and time
    let today = Date()
    currentDateLabel.text = dateFormatter.string(from: today)
    
    let age = findAgeFromBirthdate()
    ageLabel.text = "\(age)"
    
    let nextBirthday = findNextBirthdayUsingBirthdate()
    nextBirthdayLabel.text = dateFormatter.string(from: nextBirthday)
  }
  
  private func findAgeFromBirthdate() -> Int {
    let calendar = Calendar.current

    // Replace the hour (time) of both dates with 00:00 (midnight)
    let today = calendar.startOfDay(for: Date())
    let birthdate = calendar.startOfDay(for: birthdatePicker.date)

    /// Compare the two dates and remove only the year property (represents the age of the user)
    let components = calendar.dateComponents([.year], from: birthdate, to: today)
    
    return components.year ?? 0
  }
  
  func findNextBirthdayUsingBirthdate() -> Date {
    /// Fetches user's calendar. Could be Gregorian or another one, e.g. the Buddhist or Jewish calendars.
    let calendar = Calendar.current
    let today = Date()
    
    /// Pulls the birthdate object apart into year, month, and day components and lets us use/manipulate those pieces individually.
    var birthdateComponents = calendar.dateComponents([.year, .month, .day], from: birthdatePicker.date)
    
    /// Uses today's date and simply pulls the year out as a number
    let currentYear = calendar.component(.year, from: today)
    
    /// Changes the year of the birthdate components object to the current year.
    birthdateComponents.year = currentYear
    
    /// The following object is a dateComponents object that only has its month
    /// property set. It represents 12 months of time.
    var oneYear = DateComponents()
    oneYear.month = 12
    
    /// Unwrap the date value returned from the date components since it's optional,
    /// and add the "oneYear" components to that date to produce a date 1 year in the future
    guard let currentYearBirthday = calendar.date(from: birthdateComponents),
      let nextBirthday = calendar.date(byAdding: oneYear, to: currentYearBirthday) else { return Date() }
    
    /// Check to see if the current year birthday is in the future,
    /// as compared to today's date (meaning the user's birthday hasn't happened yet this year)
    if today.compare(currentYearBirthday) == .orderedAscending {
      return currentYearBirthday
    } else {
      return nextBirthday
    }
  }
}
