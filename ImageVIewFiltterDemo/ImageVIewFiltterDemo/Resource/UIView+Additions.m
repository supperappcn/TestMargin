//
//  UIView+Additions.m
//  ydtctz
//
//  Created by Develop on 1/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////////////////
- (void)plusLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x += x;
    self.frame = frame;
}


////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////////////////
- (void)plusTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y += y;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)plusWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width += width;
    self.frame = frame;
}


////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////////////////
- (void)plusHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height += height;
    self.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


/////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

-(BOOL) containsSubView:(UIView *)subView
{
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView])
        {
            return YES;
        }
    }
    return NO;
}

//-(BOOL) containsSubViewOfClassType:(Class)class {
//    for (UIView *view in [self subviews]) {
//        if ([view isMemberOfClass:class]) {
//            return YES;
//        }
//    }
//    return NO;
//}

+(UIView*)viewWithFrame:(CGRect)frame {
    return [[UIView alloc] initWithFrame:frame];
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
{
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(-M_PI / 2);
	} else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI / 2);
	} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else{
		return CGAffineTransformIdentity;
	}
}

- (UIInterfaceOrientation)currentOrientation {
    return [UIApplication sharedApplication].statusBarOrientation;
}

-(UIInterfaceOrientation)resetOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformRotate(transform, -M_PI/2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformRotate(transform, M_PI/2);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        default:
            break;
    }
    
    [self setTransform:transform];
    return orientation;
}

- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

// 移除除了给定的view外的所有子view
- (void)removeAllSubviewsExcept:(UIView*)view {
    for (UIView *v in self.subviews) {
        if(![v isEqual:view]) [v removeFromSuperview];
    }
}

// 移除除了给定的view外的所有子view
- (void)removeAllSubviewsExceptViews:(NSArray*)views {
    for (UIView *v in self.subviews) {
        if(![views containsObject:v])
            [v removeFromSuperview];
    }
}


-(void)setScaleX:(float)scaleX andY:(float)scaleY{
    [self setTransform:CGAffineTransformMakeScale(scaleX,scaleY)];
}

@end

@implementation UIScrollView(Additions)

-(void)setContentHeight:(CGFloat)height{
    CGSize size = self.contentSize;
    size.height = height;
    [self setContentSize:size];
}

-(void)setContentWidth:(CGFloat)width {
    CGSize size = self.contentSize;
    size.width = width;
    [self setContentSize:size];
}

-(float)contentWidth{
    return self.contentSize.width;
}

-(float)contentHeight{
    return self.contentSize.height;
}

@end

@implementation UINavigationController (Additions)

-(void)removeViewController:(UIViewController*)controller{
    NSMutableArray *array = [self.viewControllers mutableCopy];
    [array removeObject:controller];
    [self setViewControllers:array];
}

-(void)setTintColor:(UIColor*)tintColor{
    [self.navigationBar setTintColor:tintColor];
}

-(void)setBackgroudImage:(UIImage *)image{
//    if(!image)
//        image = [[UIImage imageNamed:@"title_bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 160, 44, 160)];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

@end

