//
//  WebViewController.m
//  Cypress
//
//  Created by Steve on 12/01/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import "WebViewController.h"


#define kCAMERA_BUTTON_TITLE                    @"Camera"
#define kLIBRARY_BUTTON_TITLE                   @"Library"


@implementation WebViewController


@synthesize webView;
@synthesize toolbar;
@synthesize title;
@synthesize customButton;
@synthesize nextButton;
@synthesize previousButton;

@synthesize connectionWarning;

@synthesize webViewLoaded;
@synthesize imagePickerController;

@synthesize imagePickerController;
@synthesize pickerViewController;
@synthesize imageFieldID;


- (NSString *)webViewUrl {
    // To be implemented by the subclass.
    return @"";
}


- (NSString *)webViewNoConnection {
    return @"You need an internet connection to view this. Try again when you are online.";
}


- (BOOL)adminButtonDisplay {
    return YES;
}


- (BOOL)implementImagePicker {
    return NO;
}


/**
 *  Load a page in the web view.
 */
- (void)loadAddress:(NSString *)address {
    NSURL *url = [NSURL URLWithString:address];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
}


/**
 *  If a memoryWarning is fired and this view is not being viewed, its content will be removed.
 *  Make sure that we cleared / set everything we create in viewWillAppear as well.
 */
- (void)setView:(UIView *)view {
    [super setView:view];
    
    if (view == nil) {
        self.webViewLoaded = NO;
        self.webView = nil;
        self.title = nil;
        self.toolbar = nil;
        self.customButton = nil;
        self.nextButton = nil;
        self.previousButton = nil;
        
        self.connectionWarning = nil;
        
        self.appDelegate = nil;
        
        self.imagePickerController = nil;
        self.pickerViewController = nil;
        self.imageFieldID = nil;
    }
}


- (void)viewDidLoad {
    self.appDelegate = (iDrupalAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.appDelegate.loader startAnimating:self.appDelegate.window withTitle:@"Loading..."];
    self.webView.userInteractionEnabled = NO;
}


- (void)viewWillAppear:(BOOL)animated {  
    [super viewWillAppear:animated];

    if (self.appDelegate.networkStatus == NotReachable) {
        if (self.connectionWarning == nil) {
            CGRect labelFrame = CGRectMake(20.0, 120.0, 280.0, 100.0);
            self.connectionWarning = [[UILabel alloc] initWithFrame:labelFrame];
            self.connectionWarning.textAlignment = UITextAlignmentCenter;
            self.connectionWarning.textColor = [UIColor blackColor];
            self.connectionWarning.backgroundColor = [UIColor clearColor];
            self.connectionWarning.numberOfLines = 2;
            [self.connectionWarning setText: [self webViewNoConnection]];
            [self.connectionWarning setFont:[UIFont systemFontOfSize:13]];
            
            [self.view addSubview:connectionWarning];
            
            [self.appDelegate.loader stopAnimating];
            
            self.webView.hidden = YES;
            self.webView.userInteractionEnabled = NO;
            self.webViewLoaded = NO;
        }
        
        return;
    }
    
    if (!self.webViewLoaded) {
        [self.connectionWarning removeFromSuperview];
        self.connectionWarning = nil;
        
        [self loadAddress: [self webViewUrl]];
        
        self.webView.backgroundColor = nil;
        self.webViewLoaded = YES;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self implementImagePicker] && self.imagePickerController == nil) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
    }
}


// TODO: the warning labels shouldn't be absolute positioning but use super.view.bounds.
- (void)alterOnOrientationChange:(UIInterfaceOrientation)orientation {
    [super alterOnOrientationChange:orientation];
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            if (self.connectionWarning != nil) {
                self.connectionWarning.frame = CGRectMake(20.0, 120.0, 280.0, 100.0);
            }
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            if (self.connectionWarning != nil) {
                self.connectionWarning.frame = CGRectMake(140.0, 70.0, 280.0, 100.0);
            }
            break;
    }
    
    self.appDelegate.loader.view.center = self.webView.center;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


- (void)dealloc {
    [super dealloc];
       
	[webView release];
    [toolbar release];
    [title release];
    [customButton release];
    [nextButton release];
    [previousButton release];
    
    [imagePickerController release];
    [pickerViewController release];
    [imageFieldID release];
    
    [connectionWarning release];
}


#pragma mark - WebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webViewInstance {    
    if (!self.appDelegate.loader.loaded) {
        [self.appDelegate.loader startAnimating:self.appDelegate.window withTitle:@"Loading..."];
        self.webView.userInteractionEnabled = NO;
        
        // Fade out content only if it exists.
        if (self.webView.alpha == 1.0) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            self.webView.alpha = 0.0;
            
            [UIView commitAnimations];
        }
    }
}


/**
 *  Method to setup the actionSheet and ask the user which source to use for images.
 */
- (void)pictureButtonAction {
    NSString *cameraOption = nil;
    NSString *libraryOption = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        libraryOption = [[NSString alloc] initWithString:kLIBRARY_BUTTON_TITLE];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraOption = [[NSString alloc] initWithString:kCAMERA_BUTTON_TITLE];
    }
    
    // Make sure the user has at least 1 of the features available before continuing.
    if (cameraOption.length > 0 || libraryOption.length > 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose your image source." delegate:self cancelButtonTitle:nil 
                                                   destructiveButtonTitle:nil otherButtonTitles:nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        if (cameraOption.length > 0) {
            [actionSheet addButtonWithTitle:cameraOption];
        }
        
        if (libraryOption.length > 0) {
            [actionSheet addButtonWithTitle:libraryOption];
        }
        
        // Provide a cancel button.
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        // Display the options dialog.
        [actionSheet showInView:self.appDelegate.tabBarController.view];
        [actionSheet release];
    } else {
        [self.appDelegate alert:@"Your device does not have the needed tools to use our pictures feature." title:@"Error" confirm:NO];
    }
    
    [libraryOption release];
    [cameraOption release];
}


/**
 *  Private method used with an NSTimer to display the webView once it is ready.
 */
- (void)displayWebView {
    // Bring in content.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.webView.alpha = 1.0;
    
    [UIView commitAnimations];
    
    [self.appDelegate.loader stopAnimating];
    
    self.webView.userInteractionEnabled = YES;
}


- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *command = [url host];
    NSString *params = [[url path] substringWithRange:NSMakeRange(1, [[url path] length] - 1)];

    NSLog(@"Requested URL: %@", url);
    
    if ([[url scheme] isEqualToString:@"idrupal"]) {
        if ([command isEqualToString:@"imagePicker"]) {            
            NSLog(@"From imagefield params: %@", params);
            
            // Keep record of the id attribute of which imagefield requested the picker.
            self.imageFieldID = params;
            
            [self pictureButtonAction];
        }
        
        return NO;
    }
    
    return YES;
}


-(void)webViewDidFinishLoad:(UIWebView *)webViewInstance {
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(displayWebView) userInfo:nil repeats:NO];    
    
    if (self.appDelegate.siteName != nil) {
        self.title.text = self.appDelegate.siteName;
    } else {
        self.title.text = self.tabBarItem.title;        
    }
    
    // Enable buttons only when usable.
    if (self.webView.canGoBack) {
        self.previousButton.enabled = YES;
    } else {
        self.previousButton.enabled = NO;        
    }
    
    if (self.webView.canGoForward) {
        self.nextButton.enabled = YES;        
    } else {
        self.nextButton.enabled = NO;                
    }
        
    // Prepare the navigation for the webViews.
    
    // Admin button.
    if (self.appDelegate.isAdmin > 0 && [self adminButtonDisplay] && self.customButton.hidden) {
        self.customButton.alpha = 0.0;
        self.customButton.hidden = NO;
        
        UIImage *image = [UIImage imageNamed:@"ico-gear.png"];
        
        [self.customButton setTitle:nil forState:UIControlStateNormal];
        [self.customButton setBackgroundImage:image forState:UIControlStateNormal];
        [self.customButton addTarget:self action:@selector(adminAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Only fade in navigation on first load.
    if (self.nextButton.hidden) {
        self.nextButton.alpha = 0.0;
        self.nextButton.hidden = NO;
        
        self.previousButton.alpha = 0.0;
        self.previousButton.hidden = NO;
        
        // Display the navigation.
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        if (self.appDelegate.isAdmin > 0 && [self adminButtonDisplay]) {
            self.customButton.alpha = 1.0;
        }
        
        self.nextButton.alpha = 1.0;
        self.previousButton.alpha = 1.0;
        
        [UIView commitAnimations];
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error domain] != NSURLErrorDomain && [error code] != NSURLErrorCancelled) {
        CGRect labelFrame = CGRectMake(20.0, 120.0, 280.0, 100.0);
        self.connectionWarning = [[UILabel alloc] initWithFrame:labelFrame];
        self.connectionWarning.textAlignment = UITextAlignmentCenter;
        self.connectionWarning.textColor = [UIColor blackColor];
        self.connectionWarning.backgroundColor = [UIColor clearColor];
        self.connectionWarning.numberOfLines = 2;
        [self.connectionWarning setText: @"The server appears to be offline. Please try again later."];
        [self.connectionWarning setFont:[UIFont systemFontOfSize:13]];
        
        [self.view addSubview:connectionWarning];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.appDelegate.loader stopAnimating];
        
        self.webView.hidden = YES;
        self.webView.userInteractionEnabled = NO;    
        self.webViewLoaded = NO;
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)theImage editingInfo:(NSDictionary *)editingInfo {
    // If the user uses the camera and chooses to accept this image, instead of waiting till they send the picture to the server,
    // we save it to their photo library now because they probably liked it since they did pick it?
    if (imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(theImage, self, nil, nil);
        [self.appDelegate alert:@"The picture was saved in your photos section." title:@"Saved" confirm:NO];
    }
    
    self.pickerViewController = [[ImagePickerViewController alloc] initWithImage:theImage parent:self];
    CGRect frame = self.pickerViewController.view.frame;
    
    self.pickerViewController.view.alpha = 0.0;
    self.pickerViewController.view.frame = CGRectMake(frame.origin.x, self.appDelegate.window.bounds.origin.y + frame.size.height, frame.size.width, frame.size.height);
    self.pickerViewController.view.frame = self.appDelegate.window.frame;
    
    [self.view addSubview:self.pickerViewController.view];
    
    // Slide up the pickerView.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    
    self.pickerViewController.view.alpha = 1.0;
    self.pickerViewController.view.frame = CGRectMake(frame.origin.x, self.appDelegate.window.frame.origin.y, frame.size.width, frame.size.height);
    
    [UIView commitAnimations];
    
	// Dismiss the image selection, hide the picker.
	[self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
    
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    NSString* activeButton = [NSString stringWithString:[actionSheet buttonTitleAtIndex:buttonIndex]];
    
    if ([activeButton isEqualToString:kCAMERA_BUTTON_TITLE]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;   
    } else if([activeButton isEqualToString:kLIBRARY_BUTTON_TITLE]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentModalViewController:imagePickerController animated:YES];
}


#pragma mark - Custom Selectors

- (IBAction)homeAction {
    [self loadAddress:[self webViewUrl]];
}


- (IBAction)nextAction {
    [self.webView goForward];
}


- (IBAction)previousAction {
    [self.webView goBack];    
}


- (IBAction)adminAction {
    // TODO: support https.
    // TODO: support base_path.
    [self loadAddress:[NSString stringWithFormat:@"http://%@/admin", [self.appDelegate hostName]]];
}


@end
