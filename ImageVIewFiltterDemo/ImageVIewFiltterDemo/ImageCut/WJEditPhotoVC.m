//  编辑图片

#import "WJEditPhotoVC.h"

#define kwidth [UIScreen mainScreen].bounds.size.width
#define kheight [UIScreen mainScreen].bounds.size.height

@interface WJEditPhotoVC ()

/** coverView*/
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *neweditImage;
@property (nonatomic, assign) CGRect alphaRect;

@end

@implementation WJEditPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)drawMaskLayer {
    //描边
    _alphaRect = CGRectMake(kwidth*0.5-53.5, 200, 170, 300);
    
    //镂空
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = _coverView.bounds;
        maskLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;

        UIBezierPath *cutBezierPath=[UIBezierPath bezierPathWithRect:_coverView.bounds];
        [cutBezierPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:_alphaRect cornerRadius:0]  bezierPathByReversingPath]];
        maskLayer.path = cutBezierPath.CGPath;

        [_coverView.layer insertSublayer:maskLayer atIndex:0];

}

- (void)setUpUI {
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = self.selectedImage;
    _backgroundImageView.userInteractionEnabled = YES;
    _backgroundImageView.contentMode =  UIViewContentModeScaleAspectFit;
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _backgroundImageView.clipsToBounds = YES;
    [self.view insertSubview:_backgroundImageView atIndex:0];
    
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    _coverView = [[UIView alloc] initWithFrame:self.view.frame];
//    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.backgroundColor = [UIColor clearColor];
    _coverView.clipsToBounds = YES;
    _coverView.userInteractionEnabled = NO;
    _coverView.alpha = 0.6;
    [self.view addSubview:_coverView];
        
      //图片放大缩小手势
      UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeScale:)];
      [_backgroundImageView addGestureRecognizer:pinGesture];
      _backgroundImageView.userInteractionEnabled = YES;
      _backgroundImageView.multipleTouchEnabled = YES;

    //图片拖拉手势
     UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePoint:)];
     [_backgroundImageView addGestureRecognizer:panGesture];
    
    [self drawMaskLayer];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"重置" forState:UIControlStateNormal];
    button.frame = CGRectMake(50, 50, 50, 30);
    [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.frame = CGRectMake(300, 50, 50, 30);
    [sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    [self.view bringSubviewToFront:sureButton];
    
    UIButton *reSelectImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reSelectImageButton setTitle:@"重选" forState:UIControlStateNormal];
    reSelectImageButton.frame = CGRectMake(175, 50, 50, 30);
    [reSelectImageButton addTarget:self action:@selector(reSelectedImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reSelectImageButton];
    [self.view bringSubviewToFront:reSelectImageButton];
    
}

//对应上面的三种手势
 - (void)changeScale:(UIPinchGestureRecognizer *)sender {
   UIView *view = sender.view;
   if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
     view.transform = CGAffineTransformScale(view.transform, sender.scale, sender.scale);
     sender.scale = 1.0;
   }
     

     
 }

- (void)changePoint:(UIPanGestureRecognizer *)sender {
   UIView *view = sender.view;
   if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
     CGPoint translation = [sender translationInView:view.superview];
     [view setCenter:CGPointMake(view.centerX+translation.x, view.centerY+translation.y)];
     [sender setTranslation:CGPointZero inView:view.superview];
   }
 }



//- (UIImage *)editImageFromView:(UIView *)theView {
//
//    //截取全屏
//    UIGraphicsBeginImageContext(theView.bounds.size);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    //截取所需区域
//    CGRect captureRect = self.coverRect;
//    CGImageRef sourceImageRef = [image CGImage];
//    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, captureRect);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    return newImage;
//}


- (void)reSelectedImageAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAction:(UIButton *)btn {
}

- (void)sureAction:(UIButton *)btn {
    
    NSLog(@"backgroundImageView.frame===%@",NSStringFromCGRect(_backgroundImageView.frame));
//    UIGraphicsBeginImageContextWithOptions(<#CGSize size#>, <#BOOL opaque#>, <#CGFloat scale#>)
    
    
    
  UIImage *scaledimg = [_selectedImage imageWidthScaled:_backgroundImageView.size.width/_selectedImage.size.width heightScaled:_backgroundImageView.size.height/_selectedImage.size.height];
    _backgroundImageView.image = scaledimg;
    
    CGFloat imgwidth = _backgroundImageView.size.width;
    CGFloat imgheight = _backgroundImageView.size.height;
   CGRect cutrect = CGRectMake((imgwidth-_alphaRect.size.width)*0.5, (imgheight-_alphaRect.size.height)*0.5 , _alphaRect.size.width,_alphaRect.size.height);
    CGImageRef imageRef = scaledimg.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, cutrect);
    UIImage *cropImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    self.block(cropImage);
    [self dismissViewControllerAnimated:YES completion:nil];

////截取全屏
//UIGraphicsBeginImageContext(_coverView.bounds.size);
//[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//UIGraphicsEndImageContext();
//
////截取所需区域
//CGRect captureRect =_alphaRect;
//CGImageRef sourceImageRef = [image CGImage];
//CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, captureRect);
//UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//
//    self.block(newImage);
//    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
