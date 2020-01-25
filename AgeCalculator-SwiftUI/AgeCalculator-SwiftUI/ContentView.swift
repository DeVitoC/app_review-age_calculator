//
//  ContentView.swift
//  AgeCalculator-SwiftUI
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

import SwiftUI

struct ContentView: View {
  
  // MARK: - Properties
  
  /// Sets the initial birthdate to a neutral value such that older and younger people
  /// shouldn't have to scroll too far.
  @State var birthdate: Date = {
    var dateComponents = DateComponents()
    dateComponents.year = 1990
    dateComponents.month = 6
    dateComponents.day = 1
    return Calendar.current.date(from: dateComponents) ?? Date()
  }()
  
  /// We'll need to format several dates, so let's set up a formatter
  /// object that we can reuse.
  var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
  }
  
  var currentAge: Int {
    let calendar = Calendar.current

    // Replace the hour (time) of both dates with 00:00 (midnight)
    let today = calendar.startOfDay(for: Date())
    let birthdate = calendar.startOfDay(for: self.birthdate)

    /// Compare the two dates and remove only the year property (represents the age of the user)
    let components = calendar.dateComponents([.year], from: birthdate, to: today)
    
    return components.year ?? 0
  }
  
  var nextBirthday: String {
    /// Fetches user's calendar. Could be Gregorian or another one, e.g. the Buddhist or Jewish calendars.
    let calendar = Calendar.current
    let today = Date()
    
    /// Pulls the birthdate object apart into year, month, and day components and lets us use/manipulate those pieces individually.
    var birthdateComponents = calendar.dateComponents([.year, .month, .day], from: birthdate)
    
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
      let nextBirthday = calendar.date(byAdding: oneYear, to: currentYearBirthday) else { return "" }
    
    /// Check to see if the current year birthday is in the future,
    /// as compared to today's date (meaning the user's birthday hasn't happened yet this year)
    if today.compare(currentYearBirthday) == .orderedAscending {
      return dateFormatter.string(from: currentYearBirthday)
    } else {
      return dateFormatter.string(from: nextBirthday)
    }
  }
  
  /// The body in a SwiftUI view is a computed property and is recomputed whenever the view
  /// needs to be updated.
  var body: some View {
    /// A NavigationView provides a navigation  bar and a stack to push detail views onto if required
    NavigationView {
      /// A VStack is just like a vertical axis UIStackView
      VStack(spacing: 12.0) {
        /// This date picker will show the date from "birthdate" as an initial value
        /// "labelsHidden" means the label usually shown to the left of the picker will be hidden (to match the design
        /// in the other versions of this app).
        DatePicker("", selection: $birthdate, displayedComponents: .date).labelsHidden()
        /// All the text objects below work just like UILabels in traditional iOS apps.
        Text("Today's Date")
          .font(.subheadline)
        Text(dateFormatter.string(from: Date()))
          .font(.headline)
        Text("Your Current Age")
          .font(.subheadline)
        Text("\(currentAge)")
          .font(.headline)
        Text("Your Next Birthday")
          .font(.subheadline)
        Text("\(nextBirthday)")
          .font(.headline)
        /// The spacer takes up the rest of the available space, thus pushing the above content to the top
        /// of the view
        Spacer()
      }
      /// Navbar titles should be added after the child of the NavigationView
      .navigationBarTitle("Age Calculator")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
