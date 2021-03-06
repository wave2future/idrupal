//
//  SettingsFormViewController.m
//  iDrupal
//
//  Created by Steve on 13/03/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import "SettingsFormViewController.h"

#import "iDrupalAppDelegate.h"


// Configurable settings.
static NSString *IDRUPAL_SITE_HOSTNAME_KEY  = @"site_hostname";
static NSString *IDRUPAL_SITE_USERNAME_KEY  = @"site_username";
static NSString *IDRUPAL_SITE_PASSWORD_KEY  = @"site_password";


@implementation SettingsFormViewController


@synthesize hostname;
@synthesize username;
@synthesize password;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.hostname setText:[[NSUserDefaults standardUserDefaults] stringForKey:IDRUPAL_SITE_HOSTNAME_KEY]];
    [self.username setText:[[NSUserDefaults standardUserDefaults] stringForKey:IDRUPAL_SITE_USERNAME_KEY]];
    [self.password setText:[[NSUserDefaults standardUserDefaults] stringForKey:IDRUPAL_SITE_PASSWORD_KEY]];    
}


- (void)dealloc {
    [super dealloc];
    
    [hostname release];
    [username release];
    [password release];
}


- (void)finishedAction {
    [self.view removeFromSuperview];
}


- (IBAction)saveSettings:(UIButton *)sender {
    // Validate fields.
    
    if ([self.hostname.text isEqualToString:@""]) {
        [self.hostname becomeFirstResponder];
        return;
    }
    
    if ([self.username.text isEqualToString:@""]) {
        [self.username becomeFirstResponder];
        return;
    }
    
    if ([self.password.text isEqualToString:@""]) {
        [self.password becomeFirstResponder];
        return;
    }    
    
    // Save fields.
    [[NSUserDefaults standardUserDefaults] setObject:self.hostname.text forKey:IDRUPAL_SITE_HOSTNAME_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:IDRUPAL_SITE_USERNAME_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:IDRUPAL_SITE_PASSWORD_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Attempt to reload.
    [self.appDelegate loadApp];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedAction)];
    [UIView setAnimationDuration:0.3];
    [UIView beginAnimations:nil context:nil];
    
    CGRect frame = self.view.frame;

    self.view.frame = CGRectMake(frame.origin.x, self.appDelegate.window.bounds.origin.y + frame.size.height, frame.size.width, frame.size.height);
    
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.hostname) {        
        [self.username becomeFirstResponder];
    } else if (textField == self.username) {
        [self.password becomeFirstResponder];
    } else if (textField == self.password) {
        [self.password resignFirstResponder];
    }
    
    return NO;
}


@end

