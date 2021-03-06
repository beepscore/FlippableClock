//
//  FlipsideViewController.m
//  FlippableClock
//
//  Created by Steve Baker on 12/25/09.
//  Copyright Beepscore LLC 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"


@implementation FlipsideViewController

#pragma mark -
#pragma mark properties
@synthesize delegate;
@synthesize twentyFourHourSwitch;
@synthesize timeZonePicker;

#pragma mark -
#pragma mark getter methods
- (NSString*)selectedTimeZone {
    return [timeZoneNames objectAtIndex:[timeZonePicker selectedRowInComponent:0]];
}


- (BOOL)uses24Hour {
    return twentyFourHourSwitch.on;
}


#pragma mark -
#pragma mark initializers / destructors
- (void)dealloc {
    [twentyFourHourSwitch release], twentyFourHourSwitch = nil;
    [timeZonePicker release], timeZonePicker = nil;
    [timeZoneNames release], timeZoneNames = nil;
    
    [super dealloc];
}


- (void)loadTimeZoneNames {
    if (timeZoneNames)
        return;
    NSArray *unsortedTimeZoneNames = [NSTimeZone knownTimeZoneNames];
    timeZoneNames = [unsortedTimeZoneNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    [timeZoneNames retain];
}


#pragma mark -
#pragma mark Picker delegate methods
- (NSInteger)pickerView:(UIPickerView *)pickerView 
numberOfRowsInComponent:(NSInteger)component {
    return [timeZoneNames count];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component {
    return (NSString*) [timeZoneNames objectAtIndex:row];
}


#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    [self loadTimeZoneNames];
    // init to values from main view
    MainViewController *mainVC = (MainViewController*)delegate;
    NSString *timeZone = [mainVC.clockPrefs objectForKey:TIME_ZONE_PREF_KEY];
    NSString *twentyFourHourPref = [mainVC.clockPrefs objectForKey:TWENTY_FOUR_HOUR_PREF_KEY];
    [timeZonePicker selectRow:[timeZoneNames indexOfObject:timeZone]
                  inComponent:0
                     animated:NO];
    twentyFourHourSwitch.on = [twentyFourHourPref boolValue];
}


- (IBAction)done {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end
