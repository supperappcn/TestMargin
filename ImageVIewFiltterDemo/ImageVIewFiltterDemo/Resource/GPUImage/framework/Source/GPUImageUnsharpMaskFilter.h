#import "GPUImageFilterGroup.h"
//unsharp取消锐化 遮罩mask
@class GPUImageGaussianBlurFilter;

@interface GPUImageUnsharpMaskFilter : GPUImageFilterGroup
{
    GPUImageGaussianBlurFilter *blurFilter;
    GPUImageFilter *unsharpMaskFilter;
}
// The blur radius of the underlying Gaussian blur. The default is 4.0.
@property (readwrite, nonatomic) CGFloat blurRadiusInPixels;

// The strength of the sharpening, from 0.0 on up, with a default of 1.0
@property(readwrite, nonatomic) CGFloat intensity;

@end
