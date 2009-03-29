//
//  iDrupalAppDelegate.h
//  iDrupal
//
//  Created by Steve on 23/01/09.
//  Copyright Eighty Elements 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSON/JSON.h>

#import "Reachability.h"
#import "LoaderViewController.h"


@class LoaderViewController, SettingsFormViewController;


@interface iDrupalAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    
    NSDictionary *siteInformation;
    NSString *siteName;
    NSString *siteBasePath;
    NSMutableData *receivedLoginData;
    
    NetworkStatus networkStatus;
    
    NSInteger isAdmin;
    
    LoaderViewController *loader;
    
    SettingsFormViewController *settingsView;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSDictionary *siteInformation;
@property (nonatomic, retain) NSString *siteName;
@property (nonatomic, retain) NSString *siteBasePath;

@property (nonatomic, retain) NSMutableData *receivedLoginData;

@property NetworkStatus networkStatus;

@property NSInteger isAdmin;

@property (nonatomic, retain) LoaderViewController *loader;

@property (nonatomic, retain) SettingsFormViewController *settingsView;


- (void)alert:(NSString *)message title:(NSString *)title confirm:(BOOL)confirm;

- (NSString *)hostName;

- (void)getSiteInformation;

- (void)drupalLogin;

- (void)loadSettingsForm;
- (void)loadApp;


@end
