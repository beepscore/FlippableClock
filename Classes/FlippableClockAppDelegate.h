//
//  FlippableClockAppDelegate.h
//  FlippableClock
//
//  Created by Steve Baker on 12/25/09.
//  Copyright Beepscore LLC 2009. All rights reserved.
//

@class MainViewController;

@interface FlippableClockAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

