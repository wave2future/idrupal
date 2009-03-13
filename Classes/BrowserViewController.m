//
//  BlogViewController.m
//  Drog
//
//  Created by Steve on 23/01/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import "BrowserViewController.h"


@implementation BrowserViewController


- (NSString *)webViewUrl {
    // TODO: support base_path.
    return [NSString stringWithFormat:@"http://%@/?view=browse", [self.appDelegate hostName]];
}


- (NSString *)webViewNoConnection {
    return @"You need an internet connection to browse your site. Try again when you are online.";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [super dealloc];
}


@end
