//
//  LoginViewController.h
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/27/15.
//  Copyright (c) 2015 Rachel Schneebaum. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
