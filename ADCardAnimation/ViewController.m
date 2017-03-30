//
//  ViewController.m
//  ADCardAnimation
//
//  Created by 王奥东 on 17/3/29.
//  Copyright © 2017年 DrunkenMouse. All rights reserved.
//

#import "ViewController.h"

/**
 点击前后是两个layout
 
 cardLayout通过设置偏移Y，使得一个叠加一个，是首页默认展示时的样子
 selectedLayout通过点击之后重新设置的layout
 
 cell的数量为两个与超过两个，分别是不同的布局，两个时就不进行叠加排布
 
 */

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)
#define RGBColorC(c)        RGBColor((((int)c) >> 16),((((int)c) >> 8) & 0xff),(((int)c) & 0xff))

static CGFloat collectionHeight;


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CardLayoutDelegate>

@property(nonatomic, strong)UICollectionView* cardCollectionView;
@property(nonatomic, strong)UICollectionViewLayout* cardLayout;
@property(nonatomic, strong)UICollectionViewLayout* cardLayoutStyle1;
@property(nonatomic, strong)UICollectionViewLayout* cardLayoutStyle2;
@property(nonatomic, strong)UITapGestureRecognizer* tapGesCollectionView;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    collectionHeight = self.view.bounds.size.height;
    
    self.cardLayoutStyle1 = [[CardLayout alloc] initWithOffsetY:400];
    self.cardLayout = self.cardLayoutStyle1;
    ((CardLayout *)self.cardLayoutStyle1).delegate = self;
    [self.view addSubview:self.cardCollectionView];
}

-(void)updateBlur {
    if ([self.cardLayout isKindOfClass:[CardLayout class]]) {
        for (NSInteger row = 0; row < [self.cardCollectionView numberOfItemsInSection:0]; row++) {
            ADCardCell * cell = (ADCardCell *)[self.cardCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            //获取Cell所在组有多少Cell
            CGFloat blur = ((NSNumber *)[((CardLayout *)self.cardLayout).blurList objectAtIndex:row]).floatValue;
            //设置Cell背后的毛玻璃效果
            [cell setBlur:blur];
        }
    }else {
        for (NSInteger row = 0; row < [self.cardCollectionView numberOfItemsInSection:0]; row++) {
            ADCardCell *cell = (ADCardCell *)[self.cardCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            [cell setBlur:0];
        }
    }
}

-(void)updateBlur:(CGFloat)blur ForRow:(NSInteger)row {
    if (![self.cardLayout isKindOfClass:[CardLayout class]]) {
        return;
    }
    //设置指定row的毛玻璃效果
    ADCardCell *cell = (ADCardCell *)[self.cardCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell setBlur:blur];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
    cell.bgColor = [self getGameColor:indexPath.row];
    cell.title = [NSString stringWithFormat:@"Item %d",(int)indexPath.row];
    return cell;
}

-(UIColor *)getGameColor:(NSInteger)index {
    NSArray* colorList = @[RGBColorC(0xfb742a),RGBColorC(0xfcc42d),RGBColorC(0x29c26d),RGBColorC(0xfaa20a),RGBColorC(0x5e64d9),RGBColorC(0x6d7482),RGBColorC(0x54b1ff),RGBColorC(0xe2c179),RGBColorC(0x9973e5),RGBColorC(0x61d4ff)];
    UIColor* color = [colorList objectAtIndex:(index%10)];
    return color;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat offsetY = self.cardCollectionView.contentOffset.y;
    if ([self.cardLayout isKindOfClass:[CardLayout class]]) {
        if (!self.cardLayoutStyle2) {
            self.cardLayoutStyle2 = [[ADCardSelectedLayout alloc] initWithIndexPath:indexPath offsetY:offsetY contentSizeHeight:((CardLayout *)self.cardLayout).contentSizeHeight];
            self.cardLayout = self.cardLayoutStyle2;
        }else {
            ((ADCardSelectedLayout *)self.cardLayoutStyle2).contentOffsetY = offsetY;
            ((ADCardSelectedLayout *)self.cardLayoutStyle2).contentSizeHeight = ((CardLayout *)self.cardLayout).contentSizeHeight;
            ((ADCardSelectedLayout *)self.cardLayoutStyle2).selectedIndexPath = indexPath;
            self.cardLayout = self.cardLayoutStyle2;
        }
        self.cardCollectionView.scrollEnabled = NO;
        [self showMaskView];//显示背景浮层
        //选中的卡片不显示蒙层
        [((ADCardCell *)[self.cardCollectionView cellForItemAtIndexPath:indexPath]) setBlur:0];
    }else {
        if (!self.cardLayoutStyle1) {
            self.cardLayoutStyle1 = [[CardLayout alloc] initWithOffsetY:offsetY];
            self.cardLayout = self.cardLayoutStyle1;
            ((CardLayout *)self.cardLayoutStyle1).delegate = self;
        }else {
            ((CardLayout *)self.cardLayoutStyle1).offsetY = offsetY;
            self.cardLayout = self.cardLayoutStyle1;
            ((CardLayout *)self.cardLayoutStyle1).delegate = self;
        }
        self.cardCollectionView.scrollEnabled = YES;
        [self hideMaskView];
    }
    [self.cardCollectionView setCollectionViewLayout:self.cardLayout animated:YES];
}

-(void)showMaskView {
        //    CATransform3DMakeTranslation(0, 0, -10);
        //    self.maskView.hidden = NO;
    self.cardCollectionView.backgroundColor = RGBColorC(0x161821);
        //    self.closeIconView.hidden = NO;
    [self.cardCollectionView addGestureRecognizer:self.tapGesCollectionView];
}

-(void)hideMaskView {
    
    //    self.maskView.hidden = YES;
    self.cardCollectionView.backgroundColor = RGBColorC(0x2D3142);
     //    self.closeIconView.hidden = YES;
    [self.cardCollectionView removeGestureRecognizer:self.tapGesCollectionView];
}


-(void)tapOnBackGround {
    CGFloat offsetY = self.cardCollectionView.contentOffset.y;
    if ([self.cardLayout isKindOfClass:[CardLayout class]]) {
        
    }else {
        if (!self.cardLayoutStyle1) {
            self.cardLayoutStyle1 = [[CardLayout alloc] initWithOffsetY:offsetY];
            self.cardLayout = self.cardLayoutStyle1;
            ((CardLayout *)self.cardLayoutStyle1).delegate = self;
        }else {
            ((CardLayout *)self.cardLayoutStyle1).offsetY = offsetY;
            self.cardLayout = self.cardLayoutStyle1;
        }
        self.cardCollectionView.scrollEnabled = YES;
        [self.cardCollectionView removeGestureRecognizer:self.tapGesCollectionView];
    }
    [self.cardCollectionView setCollectionViewLayout:self.cardLayout animated:YES];
    [self updateBlur];
}

-(UITapGestureRecognizer *)tapGesCollectionView {
    if (!_tapGesCollectionView) {
        _tapGesCollectionView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBackGround)];
    }
    return _tapGesCollectionView;
}

-(UICollectionView *)cardCollectionView {
    if (!_cardCollectionView) {
        _cardCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, collectionHeight) collectionViewLayout:self.cardLayout];
        [_cardCollectionView registerClass:[ADCardCell class] forCellWithReuseIdentifier:@"cardCell"];
        _cardCollectionView.delegate = self;
        _cardCollectionView.dataSource = self;
        [_cardCollectionView setContentOffset:CGPointMake(0, 400)];
        _cardCollectionView.backgroundColor = RGBColorC(0x2D3142);
    }
    return _cardCollectionView;
}

@end
