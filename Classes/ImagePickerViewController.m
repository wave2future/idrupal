//
//  ImagePickerViewController.m
//  iDrupal
//
//  Created by Steve on 03/03/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import "ImagePickerViewController.h"


@implementation ImagePickerViewController


@synthesize previewImage;
@synthesize sendButton;
@synthesize cancelButton;
@synthesize loader;

@synthesize image;

@synthesize receivedData;

@synthesize webViewController;


- (id)initWithImage:(UIImage *)theImage parent:(WebViewController *)theWebViewController {
    if (self = [super initWithNibName:@"ImagePickerView" bundle:nil]) {
        self.image = theImage;
        self.webViewController = theWebViewController;
    }
    return self;
}


/**
 *  If a memoryWarning is fired and this view is not being viewed, its content will be removed.
 *  Make sure that we cleared / set everything we create in viewWillAppear as well.
 */
- (void)setView:(UIView *)view {
    [super setView:view];
    
    if (view == nil) {
        self.previewImage = nil;
        self.sendButton = nil;
        self.cancelButton = nil;
        self.image = nil;
        
        self.receivedData = nil;
        
        self.webViewController = nil;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.previewImage setImage:self.image];
}


- (void)dealloc {
    [super dealloc];
    
    [previewImage release];
    [sendButton release];
    [cancelButton release];
    [loader release];
    
    [image release];
    [receivedData release];
    
    [webViewController release];
}


#pragma mark - Custom Selectors

- (IBAction)sendAction:(UIButton *)sender {    
    [self.loader startAnimating:self.view];
    
    // Prepare the data we need to send to the server.
    NSData * imageData = UIImageJPEGRepresentation(self.image, 0.90);
    
    // TODO: support base_path.
    NSString *urlString = [NSString stringWithFormat:@"http://%@/idrupal/imagefield-upload", [self.appDelegate hostName]];
    
    // Start the request.
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    // Add the header info.
    NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // Create the body post with all the needed post fields.
    NSMutableData *postBody = [NSMutableData data];
    
    // The image as data.
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"image\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[NSData dataWithData:imageData]];
    
    // Terminate the form.
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Set the body of the post.
    [request setHTTPBody:postBody];
    
    // Send it!
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!conn) {
        [self.appDelegate alert:@"The upload has failed because we cannot get a connection to the server. Please try again later." title:@"Error" confirm:NO];
    }
    
    self.receivedData = [[NSMutableData data] retain];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.loader stopAnimating];
    
    NSString *result = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
    
    NSLog(@"Image Upload Results: %@", result);
    
    if ([result intValue]) {
        [self.appDelegate alert:@"Image uploaded." title:@"Success" confirm:NO];
        
        if (self.webViewController.imageFieldID != nil) {
            NSLog(@"Returning fid back to imagefield:  %@", self.webViewController.imageFieldID);
            
            [self.webViewController.webView stringByEvaluatingJavaScriptFromString:
             [NSString stringWithFormat:@"iDrupal.attachImage(%d, '%@')", [result intValue], self.webViewController.imageFieldID]];
            
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(cancelAction:)];
            [UIView setAnimationDuration:0.3];
            [UIView beginAnimations:nil context:nil];
            
            CGRect frame = self.view.frame;
            
            self.view.alpha = 0.0;
            self.view.frame = CGRectMake(frame.origin.x, self.appDelegate.window.bounds.origin.y + frame.size.height, frame.size.width, frame.size.height);
            
            [UIView commitAnimations];
        }
    } else {
        [self.appDelegate alert:@"Your image failed to upload. There may have been a connection problem. Please try again or report this issue." title:@"Error" confirm:NO];
    }
    
    [result release];
    [self.receivedData release];
    self.receivedData = nil;
    
    [connection release];
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response {
    [receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.appDelegate alert:[@"photo: upload failed! " stringByAppendingString:[error description]] title:@"Error" confirm:NO];    
    [receivedData release];
    receivedData = nil;
    
    [connection release];
}


- (IBAction)cancelAction:(UIButton *)sender {
    [self.view removeFromSuperview];
    [self release];
}


@end
