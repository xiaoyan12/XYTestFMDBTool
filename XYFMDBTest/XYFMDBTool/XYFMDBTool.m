//
//  XYFMDBTool.m
//  XYFMDBTest
//
//  Created by 闫世超 on 2019/6/3.
//  Copyright © 2019 闫世超. All rights reserved.
//

#import "XYFMDBTool.h"
#import "XYFMDBDataBase.h"

#define XYFMDBCLASS         @"fmdbClass.sqlite"
#define XYClassMessage      @"classMessage"
#define XYClassUserInfo     @"classUserInfo"

static XYFMDBTool *FMDBTool = nil;

@interface XYFMDBTool ()
{
    FMDatabase *_db;
}
@end

@implementation XYFMDBTool

+ (XYFMDBTool *)sharedFMDBTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (FMDBTool == nil) {
            FMDBTool = [[self alloc] init];
            //创建数据库
            [FMDBTool createFMDatabase];
        }
    });
    return FMDBTool;
}


//创建数据库
- (void)createFMDatabase{
    _db = [[XYFMDBDataBase sharedFMDBDataBase] getDBWithDBName:XYFMDBCLASS];
    //创建数据库的表
    [self createFMDBTable];
}


//创建数据库的表
- (void)createFMDBTable{
    [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db createTable:XYClassUserInfo keyTypes:@[@{@"chatOne_id":@"text"}]];
    [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db createTable:XYClassMessage keyTypes:@[@{@"chatOne_msg_id":@"text"},@{@"chatOne_id":@"text"}]];
}


//给表新增字典
- (void)addFieldFMDBTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes{
    [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db addFieldTable:tableName keyTypes:keyTypes];
}

//数据库添加值
- (void)insertFMDBKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName{
    //判断主键的值存不存在 没有添加 有的话更新
    if ([tableName isEqualToString:XYClassUserInfo]) {
        if ([self isExistUserInfoWithValues:[keyValues objectForKey:@"chatOne_id"]]) {
            //存在 直接更新
            [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db updateTable:tableName setKeyValues:keyValues];
        }else{
            [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db insertKeyValues:keyValues intoTable:tableName];
        }
    }else if ([tableName isEqualToString:XYClassMessage]){
        if ([self isExistMessageWithUserValues:[keyValues objectForKey:@"chatOne_id"] messageValues:[keyValues objectForKey:@"chatOne_msg_id"]]) {
            //存在 直接更新
            [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db updateTable:tableName setKeyValues:keyValues];
        }else{
            [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db insertKeyValues:keyValues intoTable:tableName];
        }
    }
    
}

//查询
- (NSArray *)selectFMDBKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereCondition:(nonnull NSArray<NSDictionary *> *)condition count:(NSInteger)num{
   return [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db selectKeyTypes:keyTypes fromTable:tableName whereCondition:condition count:num];
}

//删除表
- (void)deleteFMDBTable:(NSString *)tableName{
    [[XYFMDBDataBase sharedFMDBDataBase] clearDatabase:_db from:tableName];
}

//更新
- (void)updateFMDBKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName{
    [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db updateTable:tableName setKeyValues:keyValues];
}

//是否存在当前用户
- (BOOL)isExistUserInfoWithValues:(NSString *)values{
    NSArray *all = [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db selectKeyTypes:@{@"chatOne_id":@"text"} fromTable:XYClassUserInfo];
    NSMutableArray *key = [NSMutableArray array];
    for (NSDictionary *dict in all) {
        [key addObject:[dict objectForKey:@"chatOne_id"]];
    }
    if ([key containsObject:values]) {
        return YES;
    }
    return NO;
}

- (BOOL)isExistMessageWithUserValues:(NSString *)userValues messageValues:(NSString *)msgValues{
    NSArray *all = [[XYFMDBDataBase sharedFMDBDataBase] DataBase:_db selectKeyTypes:@{@"chatOne_id":@"text"} fromTable:XYClassMessage whereCondition:@[@{@"chatOne_id":userValues}] count:0];
    NSMutableArray *key = [NSMutableArray array];
    for (NSDictionary *dict in all) {
        if ([dict objectForKey:@"chatOne_msg_id"]) {
            [key addObject:[dict objectForKey:@"chatOne_msg_id"]];
        }
    }
    if ([key containsObject:msgValues]) {
        return YES;
    }
    return NO;
}

@end
