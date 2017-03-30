//
//  CardLayout.h
//  ADCardAnimation
//
//  Created by 王奥东 on 17/3/29.
//  Copyright © 2017年 DrunkenMouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardLayoutDelegate <NSObject>

- (void)updateBlur:(CGFloat)blur ForRow:(NSInteger)row;

@end

@interface CardLayout : UICollectionViewLayout

@property(nonatomic, assign)CGFloat offsetY;
@property(nonatomic, assign)CGFloat contentSizeHeight;
@property(nonatomic, strong)NSMutableArray* blurList;//当前组有多少Cell
@property(nonatomic, weak)id<CardLayoutDelegate> delegate;

-(instancetype)initWithOffsetY:(CGFloat)offsetY;

@end
