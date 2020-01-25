//
//  main.m
//  AgeCalculator-ObjC
//
//  Created by Joben Gohlke on 1/8/20.
//  Copyright © 2020 Ben Gohlke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
  NSString * appDelegateClassName;
  @autoreleasepool {
      // Setup code that might create autoreleased objects goes here.
      appDelegateClassName = NSStringFromClass([AppDelegate class]);
  }
  return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
