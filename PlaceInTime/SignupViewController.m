//
//  SignupViewController.m
//  PlaceInTime
//
//  Created by Rachel Schneebaum on 8/27/15.
//  Copyright (c) 2015 Rachel Schneebaum & Quinn Harney. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "SignupViewController.h"
#import "LoginViewController.h"
#import "RootViewController.h"
#import "UserInfo.h"

@interface SignupViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property BOOL textFieldsComplete;
@property BOOL passwordConfirmed;
@property BOOL signupFailed;
@property NSArray *textFields;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(41.89374, -87.63533), MKCoordinateSpanMake(0.5, 0.5)) animated:false];
    self.signupButton.enabled = false;

    self.textFields = @[self.usernameTextField, self.passwordTextField, self.confirmPasswordTextField, self.emailTextField, self.nameTextField];
    for (UITextField *textField in self.textFields) {
        textField.delegate = self;
    }
}

-(void)checkForTextFieldsComplete {
    if ([self.usernameTextField hasText] && [self.passwordTextField hasText] && [self.confirmPasswordTextField hasText] && [self.emailTextField hasText] && [self.nameTextField hasText]) {
        self.textFieldsComplete = true;
    }
    if (self.textFieldsComplete == true) {
        [self.signupButton setEnabled:true];
    }
}

-(void)checkForConfirmedPassword {
    if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        self.passwordConfirmed = true;
    }
}

-(void)displayAlertWithErrorString:(NSString *)errorString {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"signup"]) {
        if (self.signupFailed || !self.passwordConfirmed) {
            return false;
        }
    }
    return true;
}

-(void)registerUser {
    if (self.passwordConfirmed == false) {
        [self displayAlertWithErrorString:@"Please make sure your passwords are identical!"];
    } else {
        PFUser *user = [PFUser user];
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                self.signupFailed = false;
                UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"navVC"];
                [self presentViewController:navVC animated:true completion:nil];
                NSLog(@"user - %@ signed up", user.username);
                UserInfo *userInfo = [UserInfo object];
                userInfo.name = self.nameTextField.text;
                [userInfo saveInBackground];
                NSLog(@"userinfo - %@ saved", userInfo.name);
            } else {
                self.signupFailed = true;
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITextField *textField in self.textFields) {
        [textField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
#pragma mark -

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    textField.delegate = self;
    [textField endEditing:true];
    return false;
}

-(IBAction)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField isEqual:self.textFields.lastObject]) {
        textField.returnKeyType = UIReturnKeyGo;
        [self registerUser];
    } else {
        textField.returnKeyType = UIReturnKeyNext;
        if ([textField isEqual:self.textFields[0]]) {
            [self.textFields[1] becomeFirstResponder];
        } else if ([textField isEqual:self.textFields[1]]) {
            [self.textFields[2] becomeFirstResponder];
        } else if ([textField isEqual:self.textFields[2]]) {
            [self.textFields[3] becomeFirstResponder];
        } else if ([textField isEqual:self.textFields[3]]) {
            [self.textFields[4] becomeFirstResponder];
        }
    }
}

#pragma mark - Navigation
#pragma mark -

- (IBAction)onUsernameTextFieldChanged:(UITextField *)sender {
    [self checkForTextFieldsComplete];
}

- (IBAction)onPasswordTextFieldChanged:(UITextField *)sender {
    [self checkForTextFieldsComplete];
    [self checkForConfirmedPassword];
}

- (IBAction)onConfirmPasswordTextFieldChanged:(UITextField *)sender {
    [self checkForTextFieldsComplete];
    [self checkForConfirmedPassword];
}

- (IBAction)onEmailTextFieldChanged:(UITextField *)sender {
    [self checkForTextFieldsComplete];
}

- (IBAction)onNameTextFieldChanged:(UITextField *)sender {
    [self checkForTextFieldsComplete];
}


- (IBAction)onSignupButtonPressed:(UIButton *)sender {
    [self registerUser];
    }

- (IBAction)unwindOnCancelButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"cancel" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signup"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        RootViewController *rvc = (RootViewController *)navigationController.topViewController;
        rvc.user = self.user;
    } else {
        LoginViewController *lvc = segue.destinationViewController;
    }
}


@end
