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
    [clockPrefs release], clockPrefs = nil;
    [timeLabel release], timeLabel = nil;
    [timeZoneLabel release], timeZoneLabel = nil;
    [prefsFilePath release], prefsFilePath = nil;
    [timeZoneName release], timeZoneName = nil;
    [clockFormatter release], clockFormatter = nil;
    [clockViewUpdateTimer release], clockViewUpdateTimer = nil;
    
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


#pragma mark -
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
    //  Dudney book errata one comment says use nil not NULL
    //    if (NULL == clockFormatter) {
    if (nil == clockFormatter) {
        timeLabel.text = @"";
        timeZoneLabel.text = @"";
    }
    NSDate *dateNow = [NSDate date];
    timeLabel.text = [clockFormatter stringFromDate:dateNow];
    timeZoneLabel.text = timeZoneName;
}


- (void)startClock {
    // since timer's first callback will occur after interval,
    // do one up-front refresh
    [self updateClockView];
    // now set up timer to repeatedly call updateClockView
    // ????: Need to retain and release this?
    clockViewUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                            target:self
                                                          selector:@selector (updateClockView)
                                                          userInfo:NULL
                                                           repeats:YES];
    [clockViewUpdateTimer retain];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPrefs];
    [self startClock];
}

// To avoid compiler warning, must declare a method in .h header
// or the method must be defined in .m before it's called by another method in the .m file.
// Objective C does not support "private" methods.
// However, if a method is used only inside a class, 
// we can avoid declaring it in the header, and so avoid exposing/advertising its existence.
- (void)savePrefs {
    [clockPrefs writeToFile:prefsFilePath atomically:YES];
}


#pragma mark delegate method
// <FlipsideViewControllerDelegate> protocol requires this method
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    timeZoneName = [controller selectedTimeZone];
    BOOL uses24Hour = [controller uses24Hour];
    NSString *selected24HourDisplayS = uses24Hour ? @"YES" : @"NO";
    [clockPrefs setObject:timeZoneName forKey:TIME_ZONE_PREF_KEY];
    [clockPrefs setObject:selected24HourDisplayS forKey:TWENTY_FOUR_HOUR_PREF_KEY];
    // save prefs to documents folder
    [self savePrefs];
    
    // update display to changed prefs
    [self setClockToTimeZoneName:timeZoneName uses24Hour:uses24Hour];
    [self updateClockView];
    
    // from template
	[self dismissModalViewControllerAnimated:YES];
}
#pragma mark -
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
