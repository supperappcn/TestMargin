
#import "GPUImageFilter.h"
//色度hue
@interface GPUImageHueFilter : GPUImageFilter
{
    GLint hueAdjustUniform;
    
}
@property (nonatomic, readwrite) CGFloat hue;

@end
