//
//  AllMenuData.h
//  meirong
//
//  Created by yangfeng on 2019/1/9.
//  Copyright © 2019年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AllMenuDataDelegate <NSObject>

@optional
// 分类菜单请求
- (void)AllMenuData_requestSuccess;
- (void)AllMenuData_requestFail:(NSError *)error;

@end

@interface AllMenuData : NSObject

@property (nonatomic,weak) id <AllMenuDataDelegate> delegate;


#pragma mark - 读取数据
// 表视图数据
- (NSInteger)numOfTabRows;
- (NSString *)TitleWithTabRow:(NSInteger)row;

// 集合视图数据
- (NSInteger)numOfCollSections:(NSInteger)tag;
- (NSInteger)numOfItemsInSection:(NSInteger)section tag:(NSInteger)tag;
- (NSString *)titleWithIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag;
- (BOOL)collHaveHeaderWithTag:(NSInteger)tag;
- (NSString *)titleHeaderWith:(NSIndexPath *)indexPath tag:(NSInteger)tag;
- (ChildMenuModel_2 *)HeaderModelWith:(NSInteger)section tag:(NSInteger)tag;
- (id)ItemModelWith:(NSIndexPath *)indexPath tag:(NSInteger)tag;

#pragma mark - 全部菜单 请求
- (void)requestAllMenu;

#pragma mark - 更新Model数据
- (void)updateAllMenuModel:(NSRange)range;

@end
