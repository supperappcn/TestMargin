//
//  WJEditPhotoVC.h
//  RDVEDemo
//
//  Created by DDQ on 2019/12/11.
//  Copyright © 2019 北京锐动天地信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WJEditPhotoBlock)(UIImage *image);

@interface WJEditPhotoVC : UIViewController

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) WJEditPhotoBlock block;


@end

NS_ASSUME_NONNULL_END
