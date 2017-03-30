//
//  ADCardCell.m
//  ADCardAnimation
//
//  Created by 王奥东 on 17/3/29.
//  Copyright © 2017年 DrunkenMouse. All rights reserved.
//

#import "ADCardCell.h"

@interface ADCardCell()

@property(nonatomic, strong)UILabel* titleLabel;
@property(nonatomic, strong)UIImageView* imageView;
@property(nonatomic, strong)UIVisualEffectView* blurView;

@end

static int cellCount;

@implementation ADCardCell


-(instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self initUI];
        cellCount++;
        NSLog(@"%d",cellCount);
    }
    return self;
}

-(void)layoutSubviews {
    self.contentView.frame = self.bounds;
    self.titleLabel.center = CGPointMake(self.bounds.size.width/2.0, 2 + self.titleLabel.frame.size.height/2.0);
    self.imageView.frame = self.bounds;
    self.blurView.frame = self.bounds;
}

-(void)initUI {
    [self.contentView addSubview:self.titleLabel];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    [self setNeedsLayout];
}

-(void)setBgColor:(UIColor *)bgColor {
    self.contentView.backgroundColor = bgColor;
}

-(void)setImage:(UIImage *)image {
    _image = image;
    [self.imageView removeFromSuperview];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.contentView addSubview:self.imageView];
}


//设置毛玻璃效果
-(void)setBlur:(CGFloat)ratio {
    if (!self.blurView.superview) {
        [self.contentView addSubview:self.blurView];
    }
    [self.contentView bringSubviewToFront:self.blurView];
    self.blurView.alpha = ratio;
}

-(UIVisualEffectView *)blurView {
    if (!_blurView) {
        _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurView.frame = self.bounds;
    }
    return _blurView;
}

@end
