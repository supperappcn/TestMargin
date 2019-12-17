//
//  UIImage+scale.m
//  ImageVIewFiltterDemo
//
//  Created by DDQ on 2019/12/12.
//  Copyright © 2019 DDQ. All rights reserved.
//

#import "UIImage+scale.h"


@implementation UIImage (scale)

- (UIImage *)imageWidthScaled:(float)wScale heightScaled:(CGFloat)hScale
{
    CGSize size = CGSizeMake(self.size.width * wScale, self.size.height * hScale);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

//颜色替换

- (UIImage*) imageToTransparent:(UIImage*) image

{

    // 分配内存

    const int imageWidth = image.size.width;

    const int imageHeight = image.size.height;

    size_t      bytesPerRow = imageWidth * 4;

    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);



    // 创建context

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,

                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);

    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);



    // 遍历像素

    int pixelNum = imageWidth * imageHeight;

    uint32_t* pCurPtr = rgbImageBuf;

    for (int i = 0; i < pixelNum; i++, pCurPtr++)

    {

        //把绿色变成黑色，把背景色变成透明

        if ((*pCurPtr & 0x65815A00) == 0x65815a00)    // 将背景变成透明

        {

            uint8_t* ptr = (uint8_t*)pCurPtr;

            ptr[0] = 0;

        }

        else if ((*pCurPtr & 0x00FF0000) == 0x00ff0000)    // 将绿色变成黑色

        {

            uint8_t* ptr = (uint8_t*)pCurPtr;

            ptr[3] = 0; //0~255

            ptr[2] = 0;

            ptr[1] = 0;

        }

        else if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00)    // 将白色变成透明

        {

            uint8_t* ptr = (uint8_t*)pCurPtr;

            ptr[0] = 0;

        }

        else

        {

            // 改成下面的代码，会将图片转成想要的颜色

            uint8_t* ptr = (uint8_t*)pCurPtr;

            ptr[3] = 0; //0~255

            ptr[2] = 0;

            ptr[1] = 0;

        }



    }



    // 将内存转成image

    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);

    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,

                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,

                                        NULL, true, kCGRenderingIntentDefault);

    CGDataProviderRelease(dataProvider);



    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];



    // 释放

    CGImageRelease(imageRef);

    CGContextRelease(context);

    CGColorSpaceRelease(colorSpace);

    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free

    

    return resultUIImage;

}



/** 颜色变化 */

void ProviderReleaseData (void *info, const void *data, size_t size)

{

    free((void*)data);

}



@end
