//
//  ImagePickerViewController.h
//  iDrupal
//
//  Created by Steve on 03/03/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LayoutsViewController.h"
#import "LoaderViewController.h"
#import "WebViewController.h"

@class LoaderViewController, WebViewController;


@interface ImagePickerViewController : LayoutsViewController {
    IBOutlet UIImageView *previewImage;
    IBOutlet UIButton *sendButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet LoaderViewController *loader;   
    
    UIImage *image;
    
    NSMutableData *receivedData;    
    
    WebViewController *webViewController;
}


@property (nonatomic, retain) UIImageView *previewImage;
@property (nonatomic, retain) UIButton *sendButton;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) LoaderViewController *loader;

@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) NSMutableData *receivedData;

@property (nonatomic, retain) WebViewController *webViewController;


- (id)initWithImage:(UIImage *)theImage parent:(WebViewController *)theWebViewController;

- (IBAction)sendAction:(UIButton *)sender;
- (IBAction)cancelAction:(UIButton *)sender;


@end
