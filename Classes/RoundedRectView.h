//
//  RoundedRectView.h
//
//  Created by Jeff LaMarche on 11/13/08.

#import <UIKit/UIKit.h>

#define kDefaultStrokeColor         [UIColor blackColor]
#define kDefaultRectColor           [UIColor blackColor]
#define kDefaultStrokeWidth         0.0
#define kDefaultCornerRadius        10.0

@interface RoundedRectView : UIView {
    UIColor     *strokeColor;
    UIColor     *rectColor;
    CGFloat     strokeWidth;
    CGFloat     cornerRadius;
}
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *rectColor;
@property CGFloat strokeWidth;
@property CGFloat cornerRadius;
@end