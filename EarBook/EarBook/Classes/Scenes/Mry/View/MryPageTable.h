//
//  MainTableView.h
//  MryNewsFrameWork
//
//  Created by mryun11 on 16/6/7.
//  Copyright © 2016年 mryun11. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookMP3;
@class Voice;

typedef void(^BookBlock)(BookMP3 *bookMp3);
typedef void(^VoiceBlock)(BookMP3 *bookMp3);


@interface MryPageTable : UITableView

@property (nonatomic,copy) NSString *title;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, assign) BOOL status;

@property (nonatomic, copy) BookBlock bookBlock;

@property (nonatomic, copy) VoiceBlock voiceBlock;



@end
