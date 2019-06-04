//
//  XYFMDBTool.h
//  XYFMDBTest
//
//  Created by 闫世超 on 2019/6/3.
//  Copyright © 2019 闫世超. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYFMDBTool : NSObject

+ (XYFMDBTool *)sharedFMDBTool;

//创建数据库
- (void)createFMDatabase;
//- (void)createFMDBTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes;

//给表新增字典
- (void)addFieldFMDBTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes;

//数据库添加值
- (void)insertFMDBKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName;

//更新
- (void)updateFMDBKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName;

//查询
- (NSArray *)selectFMDBKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereCondition:(NSArray <NSDictionary *>*)condition count:(NSInteger)num;

//删除表
- (void)deleteFMDBTable:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
