//
//  UIView+ZYXExtension.m
//  algorithm1
//
//  Created by 公安信息 on 16/8/15.
//  Copyright © 2016年 zhangyanxiao. All rights reserved.
//

#import "UIView+ZYXExtension.h"

@implementation UIView (ZYXExtension)


/**
 *  x
 *
 *  @param extension_x <#extension_x description#>
 */

-(void)setX_extension:(CGFloat)x_extension{
    CGRect fram = self.frame;
    fram.origin.x = x_extension;
    self.frame = fram;
}

- (CGFloat)x_extension
{
    return self.frame.origin.x;
}





/**
 *  y
 *
 *  @param extension_y <#extension_y description#>
 */

-(void)setY_extension:(CGFloat)y_extension{
    
    CGRect frame = self.frame;
    
    frame.origin.y = y_extension;
    self.frame = frame;
    
}

- (CGFloat)y_extension
{
    return self.frame.origin.y;
}



/**
 *  width
 *
 *  @param extension_width <#extension_width description#>
 */


- (void)setWidth_extension:(CGFloat)width_extension{
    CGRect frame = self.frame;
    
    frame.size.width = width_extension;
    self.frame = frame;
}
- (CGFloat)width_extension
{
    return self.frame.size.width;
}



/**
 *  height
 *
 *  @param extension_height <#extension_height description#>
 */
- (void)setHeight_extension:(CGFloat)height_extension{
    CGRect frame = self.frame;
    frame.size.height = height_extension;
    self.frame = frame;
}

- (CGFloat)height_extension
{
    return self.frame.size.height;
}




/**
 *  centerx
 *
 *  @param extension_centerX <#extension_centerX description#>
 */
-(void)setCenterX_extension:(CGFloat)centerX_extension{
    CGPoint center = self.center;
    center.x = centerX_extension;
    
    self.center = center;
    
}



- (CGFloat)centerX_extension{
    return self.center.x;
}


/**
 *  centerY
 *
 *  @param extension_centerY <#extension_centerY description#>
 */
-(void)setCenterY_extension:(CGFloat)centerY_extension

{
    
    CGPoint center = self.center;
    center.y = centerY_extension;
    self.center = center;
    
}


- (CGFloat)centerY_extension
{
    return self.center.y;
}



/**
 *  size
 *
 *  @param extension_size <#extension_size description#>
 */

- (void)setSize_extension:(CGSize)size_extension
{
    CGRect frame = self.frame;
    frame.size = size_extension;
    self.frame = frame;
}

- (CGSize)size_extension
{
    return self.frame.size;
}

/**
 *  origin
 *
 *  @param extension_origin <#extension_origin description#>
 */
- (void)setOrigin_extension:(CGPoint)origin_extension
{
    CGRect frame = self.frame;
    frame.origin = origin_extension;
    self.frame = frame;
}

- (CGPoint)origin_extension{
    return self.frame.origin;
}








-(NSString *)logframe{
    
    
    return NSStringFromCGRect(self.frame);
    
    
}

-(NSString *)logcenter{
    
    return NSStringFromCGPoint(self.center);
}

-(NSString *)logContentInset{
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scorllview = (UIScrollView *)self;
        return NSStringFromUIEdgeInsets(scorllview.contentInset);
        
    }else{
        
        return @"没有这个属性";
    }
}






@end
