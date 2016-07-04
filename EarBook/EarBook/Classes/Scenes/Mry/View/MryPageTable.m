//
//  MainTableView.m
//  MryNewsFrameWork
//
//  Created by mryun11 on 16/6/7.
//  Copyright © 2016年 mryun11. All rights reserved.
//

#import "MryPageTable.h"
#import "MoreListCell.h"
#import "BookMP3.h"
#import "Voice.h"

@interface MryPageTable ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MryPageTable

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MoreListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor blueColor];
    NSLog(@"=========%ld", self.dataArray.count);
    if ([self.dataArray[indexPath.row] class] == [BookMP3 class]) {
        cell.book = self.dataArray[indexPath.row];
    }
    else if ([self.dataArray[indexPath.row] class] == [Voice class]) {
        cell.classifyVoice = self.dataArray[indexPath.row];
    }
    
    return cell;
}


@end
