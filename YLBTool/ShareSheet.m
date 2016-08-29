//
//  ShareSheet.m
//  shareSdk
//
//  Created by rxj on 15/11/23.
//  Copyright © 2015年 rxj. All rights reserved.
//

#import "ShareSheet.h"

#define Screen_width  ([UIScreen mainScreen].bounds.size.width)

@interface ShareSheet ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContraint;

@end

@implementation ShareSheet

-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.bottomContraint.constant =  - self.shareView.frame.size.height;
    self.btn.layer.cornerRadius = 3;
    self.btn.layer.masksToBounds = YES;
    
    
}

- (void)setBgImg:(UIImage *)bgImg {
    _bgImg = bgImg;
    self.bgImgView.image = [self getblurImagewithImg:bgImg];
}

- (UIImage *)getblurImagewithImg:(UIImage *)img {
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = img.CGImage;
    CIImage *image = [CIImage imageWithCGImage:imgRef];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@2.5f forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

- (void)setShareContents:(NSArray *)shareContents {
    _shareContents = shareContents;
    [self addShareView];
}

- (void)addShareView {
    
    CGFloat width = 50;
    CGFloat height = 50;
    CGFloat offset = 0.0f;
    if (self.shareContents.count <= 4) {
         offset = (Screen_width - self.shareContents.count * 50) / (self.shareContents.count + 1);
    } else {
        offset = (Screen_width - 4*50) / (4 + 1);
        self.scrollView.contentSize = CGSizeMake(offset + (offset + width) * self.shareContents.count, self.scrollView.frame.size.height);
    }
   
    
    for (int i=0; i<self.shareContents.count; i++) {
        NSDictionary *dic = self.shareContents[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:dic[@"image"]] forState:UIControlStateNormal];
        btn.frame = CGRectMake(offset + (offset + width) * i, 12, width, height);
        [self.scrollView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] init];
        CGPoint center = btn.center;
        center.y += 40;
        label.center = center;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.bounds = CGRectMake(0, 0, 60, 20);
        label.textColor = [UIColor blackColor];
        label.text = dic[@"title"];
        [self.scrollView addSubview:label];
       
    }
    
}

- (void)show {
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
    [self layoutIfNeeded];
    [self updateConstraintsIfNeeded];
    self.bottomContraint.constant = 0;
    [UIView animateWithDuration:0.35 animations:^{
        [self layoutIfNeeded];
        [self updateConstraintsIfNeeded];
    }];
}

- (void)btnClick:(UIButton *)btn {
    if (self.shareClick) {
        self.shareClick(btn.tag);
        [self cancel];
    }
}

- (IBAction)btnAction:(id)sender {
    [self cancel];
}

- (void)cancel {
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    self.bottomContraint.constant = - self.shareView.frame.size.height;
    [UIView animateWithDuration:0.35 animations:^{
        [self layoutIfNeeded];
        [self updateConstraintsIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
