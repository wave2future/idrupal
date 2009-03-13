//
//  SettingsFormViewController.h
//  iDrupal
//
//  Created by Steve on 13/03/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LayoutsViewController.h"


@interface SettingsFormViewController : LayoutsViewController <UITextFieldDelegate> {
    IBOutlet UITextField *hostname;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
}


@property (nonatomic, retain) UITextField *hostname;
@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *password;


- (IBAction)saveSettings:(UIButton *)sender;


@end

