//
//  ADCardCell.h
//  ADCardAnimation
//
//  Created by 王奥东 on 17/3/29.
//  Copyright © 2017年 DrunkenMouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADCardCell : UICollectionViewCell

@property(nonatomic, copy)NSString* title;
@property(nonatomic, strong)UIColor* bgColor;
@property(nonatomic, strong)UIImage* image;

-(void)setBlur:(CGFloat)ratio;//设置毛玻璃效果

@end
