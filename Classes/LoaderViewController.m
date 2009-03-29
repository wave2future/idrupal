//
//  LoaderViewController.m
//  iDrupal
//
//  Created by Steve on 16/02/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import "LoaderViewController.h"


@implementation LoaderViewController


@synthesize indicator;
@synthesize label;
@synthesize loaded;


#pragma mark -
#pragma mark Initialization

- (id)initWithTitle:(NSString *)title {
    if (self = [super initWithNibName:@"LoaderView" bundle:nil]) {
        _label = title;
    }
    return self;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)dealloc {
    [super dealloc];
    
    [label release];
    [indicator release];
}


- (void)setView:(UIView *)view {
    [super setView:view];
    
    if (view == nil) {
        self.indicator = nil;
        self.label = nil;
        
        _label = nil;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = nil;
    
    CGRect frame = CGRectMake(0.0, 0.0, 130.0, 70.0);
    RoundedRectView *background = [[RoundedRectView alloc] initWithFrame:frame];
    [self.view insertSubview:background atIndex:0];
    [background release];
    
    [self.label setText:_label];
}


#pragma mark - Custom Methods

- (void)startAnimating:(UIView *)addTo {    
    if (!self.loaded) {
        self.loaded = YES;
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        CGRect frame = CGRectMake(ceil(addTo.center.x - (130.0 / 2)), ceil(addTo.center.y - 70.0), 130.0, 70.0);
        self.view.frame = frame;
        self.view.alpha = 0.0;
        
        [addTo addSubview:self.view];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        self.view.alpha = 1.0;
        
        [UIView commitAnimations];
    }
}


- (void)setLabelText {
    [self setTitle:_label];
}


- (void)setTitle:(NSString *)title {
    [self.label setText:title];
    _label = title;
    
    if (!self.loaded) {
        [self.label setText:title];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setLabelText) userInfo:nil repeats:NO];
    }
}


- (void)startAnimating:(UIView *)addTo withTitle:(NSString *)title {
    [self setTitle:title];
    [self startAnimating:addTo];
}


- (void)stopAnimating {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDidStopSelector:@selector(destroy)];
    
    self.view.alpha = 0.0;
    
    [UIView commitAnimations]; 
    
    self.loaded = NO;
}


- (void)destroy {
    [self.view removeFromSuperview];
}


@end

