//
//  LayoutsViewController.h
//  Cypress
//
//  Created by Steve on 15/01/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iDrupalAppDelegate.h"


@interface LayoutsViewController : UIViewController {
    UIInterfaceOrientation lastOrientation;
    
    iDrupalAppDelegate* appDelegate;    
}


@property UIInterfaceOrientation lastOrientation;

@property (nonatomic, assign) iDrupalAppDelegate* appDelegate;


- (void)alterOnOrientationChange:(UIInterfaceOrientation)orientation;


@end

