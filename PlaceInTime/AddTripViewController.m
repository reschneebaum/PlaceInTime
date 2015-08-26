//
//  AddTripViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/26/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "AddTripViewController.h"
#import "NewTripViewController.h"
#import "UserEvent.h"
#import "Trip.h"

@interface AddTripViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UIButton *setCurrentLocationButton;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *dayTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation AddTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITextFieldDelegate methods
#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length) {
        return NO;
    }

    if (textField == self.monthTextField || textField == self.dayTextField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength == 2;
    }
    if (textField == self.yearTextField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength == 4;
    }
    else return NO;
}




#pragma mark - Navigation


@end
