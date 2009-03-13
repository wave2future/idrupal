//
//  WebViewController.h
//  Cypress
//
//  Created by Steve on 12/01/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LayoutsViewController.h"
#import "LoaderViewController.h"
#import "ImagePickerViewController.h"


@class ImagePickerViewController;

@interface WebViewController : LayoutsViewController <UIWebViewDelegate, UIPickerViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate> {
    UIWebView *webView;
    UIToolbar *toolbar;
    UILabel *title;
    UIButton *customButton;
    UIButton *nextButton;
    UIButton *previousButton;
    
    UILabel *connectionWarning;
    
    BOOL webViewLoaded;
    
    // TODO: move to the SubmitViewController since that is the only one that uses it.
	UIImagePickerController *imagePickerController;
    ImagePickerViewController *pickerViewController;
    NSString *imageFieldID;
}


@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UIButton *customButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *previousButton;

@property (nonatomic, retain) UILabel *connectionWarning;

@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) ImagePickerViewController *pickerViewController;
@property (nonatomic, retain) NSString *imageFieldID;

@property BOOL webViewLoaded;


// To be implemented by the subclass.
- (NSString *)webViewUrl;


- (NSString *)webViewNoConnection;

- (BOOL)adminButtonDisplay;
- (BOOL)implementImagePicker;

- (void)loadAddress:(NSString *)address;

- (IBAction)homeAction;
- (IBAction)nextAction;
- (IBAction)previousAction;
- (IBAction)adminAction;

- (void)pictureButtonAction;


@end
