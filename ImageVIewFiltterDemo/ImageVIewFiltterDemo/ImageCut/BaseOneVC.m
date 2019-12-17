//
//  BaseOneVC.m
//  RDVEDemo
//
//  Created by DDQ on 2019/12/11.
//  Copyright © 2019 北京锐动天地信息技术有限公司. All rights reserved.
//

#import "BaseOneVC.h"
#import "WJEditPhotoVC.h"
#import "FilterImgVC.h"
#import <Photos/Photos.h>
#import "GPUImage.h"
#import "BBGPUImageBeautifyFilter.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface BaseOneVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *camareBtn;
}

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIScrollView *showscrollview;
@property(nonatomic,strong)UIImagePickerController *pickerVC;

@property (strong, nonatomic) GPUImageStillCamera *camera;
@property (strong,nonatomic)BBGPUImageBeautifyFilter *beautyFielter;
@property (strong, nonatomic) GPUImageView *gpuImageView;
@property (strong, nonatomic) GPUImageFilter *currentFilter;
@property (strong, nonatomic) UIButton *selectedBtn;
@property (weak,nonatomic) UISlider *mySlider;
@property (copy, nonatomic) NSArray *filterArr;

@end

@implementation BaseOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imageView = [[UIImageView alloc] init];
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(100));
        make.top.equalTo(@(200));
    }];
    
    //gaussBlur
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"选择图片" forState:UIControlStateNormal];
    button.frame = CGRectMake(
                              0, 80, 80, 30);
    [button setBackgroundColor:[UIColor orangeColor]];
    [button addTarget:self action:@selector(selectedImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    camareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [camareBtn setTitle:@"拍照" forState:UIControlStateNormal];
    camareBtn.frame = CGRectMake(
                              0, button.bottom, 80, 30);
    [camareBtn setBackgroundColor:[UIColor orangeColor]];
    [camareBtn addTarget:self action:@selector(camareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:camareBtn];

}

- (void)selectedImageAction:(UIButton *)btn {
    _pickerVC = [[UIImagePickerController alloc] init];
    _pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _pickerVC.delegate = self;
    [self presentViewController:_pickerVC animated:YES completion:nil];
}

- (void)camareAction:(UIButton*)btn {
    
    // UIImagePickerControllerSourceTypeCamera
//    _pickerVC = [[UIImagePickerController alloc] init];
//    _pickerVC.allowsEditing = YES;
//    _pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
//    _pickerVC.delegate = self;
//
//    [self presentViewController:_pickerVC animated:YES completion:nil];
    
    
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf cameraFilter];
    });
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self filterImgEventWithImage:image];
    return;
    
  WJEditPhotoVC *editPhotoVC = [[WJEditPhotoVC alloc] init];
  editPhotoVC.selectedImage = image;
    WeakSelf(self);
    editPhotoVC.block = ^(UIImage *image) {
//      [weakSelf showGradImageViewsWithImage:image];
      
//      weakSelf.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//      weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFill;
  };
    
  [self presentViewController:editPhotoVC animated:YES completion:nil];
}

- (void)filterImgEventWithImage:(UIImage*)img {
    FilterImgVC *filtervc = [[FilterImgVC alloc] init];
    filtervc.selectImg = img;
    [self.navigationController pushViewController:filtervc animated:NO];
}

//效果不行
- (void)changeBackgroundColorWIthImage:(UIImage*)img {
    self.imageView.image = [img imageToTransparent:img];
}

- (void)showGradImageViewsWithImage:(UIImage *)img {
    
    self.imageView.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;

    CGFloat imgwidht = img.size.width;
    CGFloat imgheight = img.size.height;
    
    if (!_showscrollview) {
        _showscrollview = [[UIScrollView alloc] init];
        [self.view addSubview:_showscrollview];
        [_showscrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.top.equalTo(@(120));
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(@(img.size.height*2.2));
        }];
    }
    
    for (int i = 0; i < 6; i++) {
        UIImageView *tempimg = [[UIImageView alloc] initWithImage:img];
        _showscrollview.backgroundColor = [UIColor whiteColor];
        [_showscrollview addSubview:tempimg];
        [tempimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@((imgwidht+5)*(i%3)));
            make.top.equalTo(@((i/3)*(imgheight+5)));
            make.width.equalTo(@(imgwidht));
            make.height.equalTo(@(imgheight));
        }];
    }
    
    _showscrollview.contentSize = CGSizeMake(imgwidht*3.2, imgheight*4.2);
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark 相机动态渲染
-(void)cameraFilter {
    //初始化相机，第一个参数表示相册的尺寸，第二个参数表示前后摄像头
    _camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    // 相机方向
    _camera.outputImageOrientation = UIInterfaceOrientationPortrait;
        
//    饱和度
//    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    
        //美颜
    _beautyFielter = [[BBGPUImageBeautifyFilter alloc] init];
        

    // 初始化GPUImageView
    _gpuImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    _currentFilter = _beautyFielter;
    [_camera addTarget:_beautyFielter];
    [_beautyFielter addTarget:_gpuImageView];
    [self.view addSubview:_gpuImageView];
    [_camera startCameraCapture];
    
    //照相的按钮
       UIButton *catchImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       catchImageBtn.frame = CGRectMake((ScreenW-60)/2, ScreenH-80, 60, 60);
       [catchImageBtn addTarget:self action:@selector(capturePhoto:) forControlEvents:UIControlEventTouchUpInside];
       [catchImageBtn setBackgroundImage:[UIImage imageNamed:@"photo.png"] forState:UIControlStateNormal];
       [self.view addSubview:catchImageBtn];
       
       // UISlider
       UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((ScreenW-200)/2, ScreenH-130, 200, 30)];
       slider.value = 0.5;
       [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
       [self.view addSubview:slider];
       _mySlider = slider;
       
       //切换前后摄像机
       UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       //设置2s内不可以连续点击,防止用户连续点击
       switchBtn.frame = CGRectMake(ScreenW-60, 30, 44, 35);
       [switchBtn setImage:[UIImage imageNamed:@"switch.png"] forState:UIControlStateNormal];
       [switchBtn addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventTouchUpInside];
       
       [self.view addSubview:switchBtn];
}

//切换前后镜头
- (void)switchIsChanged:(UIButton *)sender {
    [_camera rotateCamera];
}

// 开始拍照
-(void)capturePhoto:(UIButton *)sender {
    [_camera capturePhotoAsPNGProcessedUpToFilter:_currentFilter withCompletionHandler:^(NSData *processedPNG, NSError *error) {
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageWithData:processedPNG]];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
        }];
    }];
    
}

//滑动slider滚动条
- (void)sliderValueChanged:(UISlider *)slider {

//  .brightness = self.slider;
//  [self.pic processImage];
//  [self.filterGroup useNextFrameForImageCapture];
//  self.imgView.image = [self.filterGroup imageFromCurrentFramebuffer];
}

#pragma mark  静态图片加滤镜
-(void)pictureFilter {
    UIImage *inputIamge = [UIImage imageNamed:@"tree.jpg"];
    
    UIImageView *preImageView = [[UIImageView alloc] initWithImage:inputIamge];
    preImageView.frame = CGRectMake(0, 0, 300, 200);
    preImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 150);
    [self.view addSubview:preImageView];
    
    // 使用黑白素描滤镜
    GPUImageSketchFilter *disFilter = [[GPUImageSketchFilter alloc] init];
    [disFilter forceProcessingAtSize:inputIamge.size];
    [disFilter useNextFrameForImageCapture];
    // 获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputIamge];
    // 加上滤镜
    [stillImageSource addTarget:disFilter];
    // 开始渲染
    [stillImageSource processImage];
    // 获取渲染后的图片
    UIImage *newImage = [disFilter imageFromCurrentFramebuffer];
    
    // 加载出来
    UIImageView *finishImageView = [[UIImageView alloc] initWithImage:newImage];
    finishImageView.frame = CGRectMake(0, 0, 300, 200);
    finishImageView.center = CGPointMake(self.view.center.x, self.view.center.y + 150);
    [self.view addSubview:finishImageView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}




@end
