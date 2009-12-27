//
//  MainViewController.m
//  FlippableClock
//
//  Created by Steve Baker on 12/25/09.
//  Copyright Beepscore LLC 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"


@implementation MainViewController

#pragma mark -
#pragma mark properties
@synthesize clockPrefs;
@synthesize timeLabel;
@synthesize timeZoneLabel;

#pragma mark -
#pragma mark initializers / destructors

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.clockPrefs = nil;
    self.timeLabel = nil;
    self.timeZoneLabel = nil;
    [prefsFilePath release], prefsFilePath = nil;
    [timeZoneName release], timeZoneName = nil;
    [clockFormatter release], clockFormatter = nil;
    
    [super dealloc];
}

- (void)initPrefsFilePath {
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    prefsFilePath = [documentsDirectory stringByAppendingPathComponent:@"flippingprefs.plist"];
    [prefsFilePath retain];
}

- (void)loadPrefs {
    if (nil == prefsFilePath)
        [self initPrefsFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:prefsFilePath]) {
        clockPrefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsFilePath];
    } else {
        clockPrefs = [[NSMutableDictionary alloc] initWithCapacity:2];
        [clockPrefs setObject:DEFAULT_TIME_ZONE_PREF forKey:TIME_ZONE_PREF_KEY];
        [clockPrefs setObject:DEFAULT_TWENTY_FOUR_HOUR_PREF forKey:TWENTY_FOUR_HOUR_PREF_KEY];            
    }
    NSString *prefTimeZone = [clockPrefs objectForKey:TIME_ZONE_PREF_KEY];
    BOOL uses24Hour = [(NSString*)
                       [clockPrefs objectForKey:TWENTY_FOUR_HOUR_PREF_KEY] boolValue];
    [self setClockToTimeZoneName: prefTimeZone uses24Hour: uses24Hour];
}

- (void)setClockToTimeZoneName: (NSString*) tz uses24Hour: (BOOL) u24h {
    [timeZoneName release];
    [tz retain];
    timeZoneName = tz;
    // set time formatter with 24 hour preference and time zone
    if (nil == clockFormatter) {
        clockFormatter = [[NSDateFormatter alloc] init];
    }
    // see formats at
    // http://unicode.org/reports/tr35/tr35-4.html#Date_Format_Patterns
    [clockFormatter setTimeZone:[NSTimeZone timeZoneWithName:tz]];
    if (u24h)
        [clockFormatter setDateFormat:@"HH:mm:ss"];
    else
        [clockFormatter setDateFormat:@"h:mm:ss a"];
}
     
- (void)updateClockView {
    if (NULL == clockFormatter) {
        timeLabel.text = @"";
        timeZoneLabel.text = @"";
    }
    NSDate *dateNow = [NSDate date];
    timeLabel.text = [clockFormatter stringFromDate:dateNow];
    timeZoneLabel.text = timeZoneName;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPrefs];
    [self updateClockView];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
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
