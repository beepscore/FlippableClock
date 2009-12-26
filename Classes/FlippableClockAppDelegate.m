//
//  FlippableClockAppDelegate.m
//  FlippableClock
//
//  Created by Steve Baker on 12/25/09.
//  Copyright Beepscore LLC 2009. All rights reserved.
//

#import "FlippableClockAppDelegate.h"
#import "MainViewController.h"

@implementation FlippableClockAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
