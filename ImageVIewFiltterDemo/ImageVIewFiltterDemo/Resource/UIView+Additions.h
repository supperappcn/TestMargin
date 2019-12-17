//
//  UIView+Additions.h
//  ydtctz
//
//  Created by 小宝 on 1/9/12.
//  Copyright (c) 2012 Bosermobile. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TT_TRANSITION_DURATION 0.3

@interface UIView (Additions)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/* 在原来的宽、高上加上一定的尺寸 */
-(void)plusWidth:(CGFloat)width;
- (void)plusHeight:(CGFloat)height;
/* 在原来的左、上边距加上一定的尺寸 */
- (void)plusLeft:(CGFloat)x;
- (void)plusTop:(CGFloat)y;

/* 是否含有子View */
-(BOOL) containsSubView:(UIView *)subView;
//-(BOOL) containsSubViewOfClassType:(Class)class;

+(UIView*)viewWithFrame:(CGRect)frame;

/* 调整UIView旋转方向 */
-(CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
-(UIInterfaceOrientation)currentOrientation;
-(UIInterfaceOrientation)resetOrientation;

- (void)removeAllSubviews;
- (void)removeAllSubviewsExcept:(UIView*)view;

// 移除除了给定的view外的所有子view
- (void)removeAllSubviewsExceptViews:(NSArray*)views;

/* 设置缩放 */
-(void)setScaleX:(float)scaleX andY:(float)scaleY;

@end



@interface UIScrollView(Additions)

-(void)setContentHeight:(CGFloat)height;
-(void)setContentWidth:(CGFloat)width;
-(float)contentHeight;
-(float)contentWidth;

@end

@interface UINavigationController (Additions)
-(void)setBackgroudImage:(UIImage*)image;
-(void)setTintColor:(UIColor*)tintColor;
-(void)removeViewController:(UIViewController*)controller;
@end

