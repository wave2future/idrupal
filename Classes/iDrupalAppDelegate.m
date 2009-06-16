//
//  iDrupalAppDelegate.m
//  iDrupal
//
//  Created by Steve on 23/01/09.
//  Copyright Eighty Elements 2009. All rights reserved.
//

#import "iDrupalAppDelegate.h"

#import "SettingsFormViewController.h"


// Configurable settings.
static NSString *IDRUPAL_SITE_HOSTNAME_KEY  = @"site_hostname";
static NSString *IDRUPAL_SITE_USERNAME_KEY  = @"site_username";
static NSString *IDRUPAL_SITE_PASSWORD_KEY  = @"site_password";


@implementation iDrupalAppDelegate


@synthesize window;
@synthesize tabBarController;

@synthesize siteInformation;
@synthesize siteName;
@synthesize siteBasePath;
@synthesize isAdmin;

@synthesize receivedLoginData;

@synthesize networkStatus;

@synthesize loader;

@synthesize settingsView;


#pragma mark -
#pragma mark Initialization Methods

+(void)initialize {
    if ([iDrupalAppDelegate class] == self) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"Root" ofType:@"plist" inDirectory:@"Settings.bundle"];
        NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:plist];
        NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
        NSString *siteHostname = nil;
        NSString *siteUsername = nil;
        NSString *sitePassword = nil;
        
        for (NSDictionary *prefItem in prefSpecifierArray) {
            if ([[prefItem objectForKey:@"Key"] isEqualToString:IDRUPAL_SITE_HOSTNAME_KEY]) {
                siteHostname = [prefItem objectForKey:@"DefaultValue"];
            }
            
            if ([[prefItem objectForKey:@"Key"] isEqualToString:IDRUPAL_SITE_USERNAME_KEY]) {
                siteUsername = [prefItem objectForKey:@"DefaultValue"];
            }
            
            if ([[prefItem objectForKey:@"Key"] isEqualToString:IDRUPAL_SITE_PASSWORD_KEY]) {
                sitePassword = [prefItem objectForKey:@"DefaultValue"];
            }
        }
        
        NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     siteHostname, IDRUPAL_SITE_HOSTNAME_KEY,
                                     siteUsername, IDRUPAL_SITE_USERNAME_KEY,
                                     sitePassword, IDRUPAL_SITE_PASSWORD_KEY,
                                     nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    }
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Setup reachability so we know when the user has an internet connection or not.
    [[Reachability sharedReachability] setHostName:[self hostName]];
    [[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
    [[Reachability sharedReachability] remoteHostStatus];
    
    // Since 0 == NOT_REACHABLE, we need to use -1.
    self.networkStatus = -1;
    
    // Setup the loader view.
    self.loader = [[LoaderViewController alloc] initWithTitle:@"Loading..."];
    [self.loader startAnimating:self.window];
    
    // Present the settings form on first load if the settings have yet to be populated.
    if ([[NSUserDefaults standardUserDefaults] stringForKey:IDRUPAL_SITE_USERNAME_KEY].length == 0) {
        [self loadSettingsForm];
    } 
    // Settings exist so load the site.
    else {
        [self loadApp];           
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:@"kNetworkReachabilityChangedNotification" object:nil];
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    
    [siteInformation release];
    [siteName release];
    [siteBasePath release];
    [receivedLoginData release];
    
    [loader release];
    [settingsView release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Custom Methods


/**
 *  Start the initial load process.
 */ 
- (void)loadApp {
    [self getSiteInformation];
    [self.window makeKeyAndVisible];
    [self.loader setTitle:@"Connecting..."];
}

/**
 *  Display the settings form.
 */
- (void)loadSettingsForm {
    if (self.settingsView == nil) {
        self.settingsView = [[SettingsFormViewController alloc] initWithNibName:@"SettingsFormView" bundle:nil];        
    }
    
    self.settingsView.view.alpha = 0.0;
    
    CGRect frame = self.settingsView.view.frame;
    self.settingsView.view.frame = CGRectMake(frame.origin.x, self.window.frame.origin.y, frame.size.width, frame.size.height);
    
    [self.window addSubview:self.settingsView.view];
    [self.window makeKeyAndVisible];
    [self.settingsView.view fadeIn:0.3];
    
    [self.loader stopAnimating];
}


/**
 *  Helper function for displaying a quick alert view.
 */
- (void)alert:(NSString *)message title:(NSString *)title confirm:(BOOL)confirm {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    if (confirm) {
        [alert addButtonWithTitle:@"Cancel"];
    }
    
    [alert show];
    [alert release];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}


#pragma mark -
#pragma mark Reachability

/**
 *  The host we connect to as our server.
 */
- (NSString *)hostName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:IDRUPAL_SITE_HOSTNAME_KEY];
}


- (void)reachabilityChanged:(NSNotification *)note {
    self.networkStatus = [[Reachability sharedReachability] remoteHostStatus];
}


#pragma mark -
#pragma mark Drupal Communication

- (void)setSiteInformation {
    self.siteName = [self.siteInformation objectForKey:@"siteName"];
    self.siteBasePath = [self.siteInformation objectForKey:@"basePath"];
    
    // Automatically log the user in now that we know the site has what we need.
    if (self.siteName != nil) {
        [self drupalLogin];
        [self.loader setTitle:@"Logging In..."];
    }
    
    // If the user has admin access on the site or not.
    self.isAdmin = (NSInteger)[self.siteInformation valueForKey:@"isAdmin"];
}


/**
 *  Fetch the site information from the server.
 */
- (void)fetchSiteInformation {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    // TODO: support base path.
    NSString *json = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/idrupal/site-information", [self hostName]]]];
    self.siteInformation = [json JSONValue];
    
    if (self.siteInformation == nil) {
        [self.loader stopAnimating];
        [self alert:@"Unable to receive the site information. Is the iDrupal module properly installed on the server? Did you properly configure this application in the settings to use your hostname?" title:@"Error" confirm:NO];
        [self loadSettingsForm];
        [self.tabBarController.view removeFromSuperview];
    } else {
        [self performSelectorOnMainThread:@selector(setSiteInformation) withObject:nil waitUntilDone:NO];        
    }
    
    [pool drain];
}


/**
 *  Call fetchSiteInformation method in a background thread.
 */
- (void)getSiteInformation {
    [self performSelectorInBackground:@selector(fetchSiteInformation) withObject:nil];  
}


/**
 *  Handle a drupal login.
 */
- (void)drupalLogin {
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:IDRUPAL_SITE_USERNAME_KEY];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:IDRUPAL_SITE_PASSWORD_KEY];
    
    if (username.length == 0 || password.length == 0) {
        [self alert:@"You have not provided all your login information." title:@"Error" confirm:NO];
        [self loadSettingsForm];
        
        return;
    }
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    // TODO: support base_path.
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/idrupal/login", [self hostName]]]];
    [request setHTTPMethod:@"POST"];
    
    // Add the header info.
    NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // Create the body post with all the needed post fields.
    NSMutableData *postBody = [NSMutableData data];
    
    // Username.
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[username dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Password.
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pass\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Terminate the form.
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Set the body of the post.
    [request setHTTPBody:postBody];
    
    // Send it!
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!conn) {
        [self alert:@"Failed to login. Please make sure your hostname is correct (without a protocol, example: drupal.org) and your server is accessible." title:@"Error" confirm:NO];
        [self loadSettingsForm];
        return;
    }
    
    self.receivedLoginData = [[NSMutableData data] retain];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *result = [[NSString alloc] initWithData:self.receivedLoginData encoding:NSASCIIStringEncoding];
    
    if ([result intValue] > 0) {
        self.tabBarController.view.alpha = 0.0;
        
        [self.window insertSubview:self.tabBarController.view atIndex:0];
        [self.tabBarController.view fadeIn:0.3];
        
        // Remove from memory.
        if (self.settingsView.view.superview == nil) {
            self.settingsView = nil;
        }
    } else {
        [self alert:@"Unable to login. Please make sure your login information is correct." title:@"Error" confirm:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadSettingsForm) userInfo:nil repeats:NO];
    }
    
    [result release];
    [self.receivedLoginData release];
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response {
    [self.receivedLoginData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedLoginData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self alert:[@"Login failed with message: " stringByAppendingString:[error description]] title:@"Error" confirm:NO];    
    [self.receivedLoginData release];
    self.receivedLoginData = nil;
}


@end

