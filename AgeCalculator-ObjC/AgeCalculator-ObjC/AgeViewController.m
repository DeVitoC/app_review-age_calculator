//
//  AgeViewController.m
//  AgeCalculator-ObjC
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

#import "AgeViewController.h"

@interface AgeViewController ()

@property (nonatomic, weak) IBOutlet UIDatePicker *birthdatePicker;
@property (nonatomic, weak) IBOutlet UILabel *currentDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;
@property (nonatomic, weak) IBOutlet UILabel *nextBirthdayLabel;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (IBAction)birthdateSelected:(UIDatePicker *)sender;

@end

@implementation AgeViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Age Calculator";
  
  /// We'll need to format several dates, so let's set up a formatter
  /// object that we can reuse.
  self.dateFormatter = [[NSDateFormatter alloc] init];
  
  /// What does "medium style" mean? (hint: copy the value used below
  /// on the right of the assignment operator and open the "Developer Documentation"
  /// window from the Window menu at the top of the screen. Paste the value
  /// to search the Appledoc for it.)
  self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
  
  /// How does "no style" differ from the medium style used above?
  /// You can look in the same place in the docs to find the answer.
  self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
  
  [self updateViews];
}

#pragma mark - Actions

- (IBAction)birthdateSelected:(UIDatePicker *)sender {
  [self updateViews];
}

#pragma mark - Private

/// Used each time the view needs to be updated with new date/age values
- (void)updateViews {
  /// Using the date class property returns an instance of date set to the current date and time
  NSDate *today = [NSDate date];
  self.currentDateLabel.text = [self.dateFormatter stringFromDate:today];
  
  int age = [self findAgeFromBirthdate];
  self.ageLabel.text = [NSString stringWithFormat:@"%d", age];
  
  NSDate *nextBirthday = [self findNextBirthdayUsingBirthdate];
  self.nextBirthdayLabel.text = [self.dateFormatter stringFromDate:nextBirthday];
}

- (int)findAgeFromBirthdate {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  
  /// Replace the hour (time) of both dates with 00:00 (midnight)
  NSDate *today = [calendar startOfDayForDate:[NSDate date]];
  NSDate *birthdate = [calendar startOfDayForDate:self.birthdatePicker.date];

  /// Compare the two dates and remove only the year property (represents the age of the user)
  NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:birthdate toDate:today options:0];
 
  return (int) components.year;
}

- (NSDate *)findNextBirthdayUsingBirthdate {
  /// Fetches user's calendar. Could be Gregorian or another one, e.g. the Buddhist or Jewish calendars.
  NSCalendar *calendar = [NSCalendar currentCalendar];
  
  /// Pulls the birthdate object apart into year, month, and day components and lets us use/manipulate those pieces individually.
  NSDateComponents *birthdateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitCalendar fromDate:self.birthdatePicker.date];
  
  /// Uses today's date and simply pulls the year out as a number
  NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
  
  /// Changes the year of the birthdate components object to the current year.
  [birthdateComponents setYear:currentYear];
  
  /// Converts the birthdateComponents object back into a regular NSDate object
  NSDate *currentYearBirthday = [birthdateComponents date];
  
  /// The above NSDate object represents the user's birthday for this year.
  /// We now need to add 1 year to it to determine the user's next birthday.
  /// The following object is a dateComponents object that only has its month property set.
  /// It represents 12 months of time.
  NSDateComponents *oneYear = [[NSDateComponents alloc] init];
  [oneYear setMonth:12];
  
  /// Add the "oneYear" objecgt to "currentYearBirthday" to determine the user's next birthday
  NSDate *nextBirthday = [calendar dateByAddingComponents:oneYear toDate:currentYearBirthday options:0];
  
  /// Check to see if the current year birthday is in the future,
  /// as compared to today's date (meaning the user's birthday hasn't happened yet this year)
  if ([[NSDate date] compare:currentYearBirthday] == NSOrderedAscending) {
    return currentYearBirthday;
  } else {
    return nextBirthday;
  }
}

@end
