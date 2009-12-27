//
//  FlipsideViewController.h
//  FlippableClock
//
//  Created by Steve Baker on 12/25/09.
//  Copyright Beepscore LLC 2009. All rights reserved.
//

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController 
        <UIPickerViewDataSource, UIPickerViewDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
    UISwitch *twentyFourHourSwitch;
    UIPickerView *timeZonePicker;
    NSArray *timeZoneNames;
}

#pragma mark -
#pragma mark properties
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property(nonatomic,retain)IBOutlet UISwitch *twentyFourHourSwitch;
@property(nonatomic,retain)IBOutlet UIPickerView *timeZonePicker;


- (IBAction)done;
- (void)loadTimeZoneNames;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

