//
//  LoaderViewController.h
//  iDrupal
//
//  Created by Steve on 16/02/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RoundedRectView.h"


@interface LoaderViewController : UIViewController {
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *label;
    
    BOOL loaded;
    
    NSString *_label;
}


@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *label;

@property BOOL loaded;


- (id)initWithTitle:(NSString *)title;

- (void)startAnimating:(UIView *)addTo;
- (void)startAnimating:(UIView *)addTo withTitle:(NSString *)title;

- (void)stopAnimating;

- (void)setTitle:(NSString *)title;



@end

