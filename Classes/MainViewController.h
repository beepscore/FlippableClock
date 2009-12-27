//
//  MainViewController.h
//  FlippableClock
//
//  Created by Steve Baker on 12/25/09.
//  Copyright Beepscore LLC 2009. All rights reserved.
//

#import "FlipsideViewController.h"

#define TWENTY_FOUR_HOUR_PREF_KEY @"24HourDisplay"
#define TIME_ZONE_PREF_KEY @"TimeZone"
#define DEFAULT_TWENTY_FOUR_HOUR_PREF @"NO"
#define DEFAULT_TIME_ZONE_PREF @"America/Detroit"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
    NSMutableDictionary *clockPrefs;
    UILabel *timeLabel;
    UILabel *timeZoneLabel;
    
    NSString *prefsFilePath;
    NSString *timeZoneName;
    NSDateFormatter *clockFormatter;
}

#pragma mark -
#pragma mark properties
@property(nonatomic,retain)NSMutableDictionary *clockPrefs;
@property(nonatomic,retain)IBOutlet UILabel *timeLabel;
@property(nonatomic,retain)IBOutlet UILabel *timeZoneLabel;

- (IBAction)showInfo;

- (void)initPrefsFilePath;
- (void)loadPrefs;
- (void)setClockToTimeZoneName: (NSString*) tz uses24Hour: (BOOL) u24h;
- (void)updateClockView;

@end
