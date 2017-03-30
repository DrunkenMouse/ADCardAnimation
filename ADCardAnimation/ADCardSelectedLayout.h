//
//  ADCardSelectedLayout.h
//  ADCardAnimation
//
//  Created by 王奥东 on 17/3/29.
//  Copyright © 2017年 DrunkenMouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADCardSelectedLayout : UICollectionViewLayout

-(instancetype)initWithIndexPath:(NSIndexPath *)indexPath offsetY:(CGFloat)offsetY contentSizeHeight:(CGFloat)sizeHeight;

@property(nonatomic, assign)NSIndexPath * selectedIndexPath;
@property(nonatomic, assign)CGFloat contentOffsetY;
@property(nonatomic, assign)CGFloat contentSizeHeight;


@end
