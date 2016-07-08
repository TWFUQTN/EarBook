//
//  MryPageTableCell.m
//  EarBook
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "MryPageTableCell.h"
#import "BookMP3.h"
#import "Voice.h"

@interface MryPageTableCell ()

/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

/// 书籍名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// 播放次数
@property (weak, nonatomic) IBOutlet UILabel *playLabel;

/// 主播名
@property (weak, nonatomic) IBOutlet UILabel *announcerLabel;

/// 描述
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfBottomView;

@end


@implementation MryPageTableCell

- (void)layoutSubviews {
    
    [self _shouldRotateToOrientation:(UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation];
    
}

-(void)_shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    if (orientation == UIDeviceOrientationPortrait ||orientation ==
        UIDeviceOrientationPortraitUpsideDown) { // 竖屏
        self.widthOfBottomView.constant = [UIScreen mainScreen].bounds.size.width;

    } else { // 横屏
        self.widthOfBottomView.constant = [UIScreen mainScreen].bounds.size.width;

    }
}

//- (void)layoutIfNeeded {
//    self.widthOfBottomView.constant = [UIScreen mainScreen].bounds.size.width;
//    NSLog(@"%f", [UIScreen mainScreen].bounds.size.width);
//}


- (void)setBook:(BookMP3 *)book
{
    if (_book != book) {
        _book = nil;
        _book = book;
        
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_book.cover] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        _nameLabel.text = _book.name;
        _announcerLabel.text = _book.announcer;
        _descLabel.text = _book.desc;
        
        CGFloat play = _book.play.integerValue;
        
        NSInteger numForTenThousand = play / 10000;
        NSInteger numForHundredMillion = play / (10000 * 10000);
        
        if (numForTenThousand < 0) {
            _playLabel.text = _book.play;
        }
        
        if (numForTenThousand > 0 && numForHundredMillion <= 0) {
            _playLabel.text = [NSString stringWithFormat:@"%.1f万", play / 10000.0];
        }
        
        if (numForHundredMillion >= 1) {
            _playLabel.text = [NSString stringWithFormat:@"%.1f亿", play / (10000.0 * 10000)];
        }
        
    }
}

- (void)setClassifyVoice:(Voice *)classifyVoice {
    
    if (_classifyVoice != classifyVoice) {
        _classifyVoice = nil;
        _classifyVoice = classifyVoice;
        
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_classifyVoice.cover] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        _nameLabel.text = _classifyVoice.name;
        _announcerLabel.text = _classifyVoice.nickName;
        _descLabel.text = _classifyVoice.Description;
        
        CGFloat play = _classifyVoice.playCount.integerValue;
        
        NSInteger numForTenThousand = play / 10000;
        NSInteger numForHundredMillion = play / (10000 * 10000);
        
        if (numForTenThousand < 0) {
            _playLabel.text = _classifyVoice.playCount;
        }
        
        if (numForTenThousand > 0 && numForHundredMillion <= 0) {
            _playLabel.text = [NSString stringWithFormat:@"%.1f万", play / 10000.0];
        }
        
        if (numForHundredMillion >= 1) {
            _playLabel.text = [NSString stringWithFormat:@"%.1f亿", play / (10000.0 * 10000)];
        }
        
    }
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
