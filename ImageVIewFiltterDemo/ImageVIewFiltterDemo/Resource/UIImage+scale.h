//
//  UIImage+scale.h
//  ImageVIewFiltterDemo
//
//  Created by DDQ on 2019/12/12.
//  Copyright © 2019 DDQ. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (scale)

- (UIImage *)imageWidthScaled:(float)wScale heightScaled:(CGFloat)hScale;
- (UIImage*) imageToTransparent:(UIImage*) image;

@end

NS_ASSUME_NONNULL_END
