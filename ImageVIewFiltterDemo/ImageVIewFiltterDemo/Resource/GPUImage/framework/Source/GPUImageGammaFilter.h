#import "GPUImageFilter.h"

// 伽马线
@interface GPUImageGammaFilter : GPUImageFilter
{
    GLint gammaUniform;
}

// Gamma ranges from 0.0 to 3.0, with 1.0 as the normal level
@property(readwrite, nonatomic) CGFloat gamma; 

@end
