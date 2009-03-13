//
//  PostsViewController.m
//  Drog
//
//  Created by Steve on 23/01/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import "SubmitViewController.h"


@implementation SubmitViewController


- (NSString *)webViewUrl {
    // TODO: support base_path.
    return [NSString stringWithFormat:@"http://%@/node/add/?view=submit", [self.appDelegate hostName]];
}


- (NSString *)webViewNoConnection {
    return @"You need an internet connection to submit content to your site. Try again when you are online.";
}


- (BOOL)adminButtonDisplay {
    return NO;
}


- (BOOL)implementImagePicker {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [super dealloc];
}

@end
