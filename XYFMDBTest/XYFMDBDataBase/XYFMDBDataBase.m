//
//  XYFMDBDataBase.m
//  XYFMDBTest
//
//  Created by 闫世超 on 2019/6/3.
//  Copyright © 2019 闫世超. All rights reserved.
//

#import "XYFMDBDataBase.h"


static XYFMDBDataBase *FMDBDataBase = nil;

@implementation XYFMDBDataBase

+ (XYFMDBDataBase *)sharedFMDBDataBase{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (FMDBDataBase == nil) {
            FMDBDataBase = [[self alloc] init];
        }
    });
    return FMDBDataBase;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (FMDBDataBase == nil) {
            FMDBDataBase = [super allocWithZone:zone];
        }
    });
    return FMDBDataBase;
}

#pragma mark --创建数据库

- (FMDatabase *)getDBWithDBName:(NSString *)dbName{
    
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *dbPath = [library[0] stringByAppendingPathComponent:dbName];
    
    NSLog(@"%@", dbPath);

    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"无法获取数据库");
        return nil;
    }
    return db;
}


#pragma mark --给指定数据库建表

- (void)DataBase:(FMDatabase *)db createTable:(NSString *)tableName keyTypes:(nonnull NSArray<NSDictionary *> *)keyTypes{
    
    if ([self isOpenDatabese:db]) {
        
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName]];
        
        int count = 0;
        
        for (NSDictionary *dict in keyTypes) {
            
            count++;
            
            [sql appendString:[[dict allKeys] firstObject]];
            
            [sql appendString:@" "];
            
            [sql appendString:[[dict allValues] firstObject]];
            if (count == 1) {
                [sql appendString:@" primary key"];
            }
            if (count != [keyTypes count]) {
                
                [sql appendString:@", "];
                
            }
            
        }
        
        
        [sql appendString:@")"];
        
        //        NSLog(@"%@", sql);
        
        [db executeUpdate:sql];
        //关闭数据库
        [db close];
        
    }
    
    
    
}

#pragma mark --给指定数据库的表添加值

-(void)DataBase:(FMDatabase *)db insertKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName

{

    if ([self isOpenDatabese:db]) {
        
        //        int count = 0;
        
        //        NSString *Key = [[NSString alloc] init];
        
        //        for (NSString *key in keyValues) {
        
        //            if(count == 0){
        
        //                NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (?)",tableName, key]];
        
        //                [db executeUpdate:sql,[keyValues valueForKey:key]];
        
        //                Key = key;
        
        //            }else
        
        //            {
        
        //                NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", tableName, key, Key]];
        
        //                [db executeUpdate:sql,[keyValues valueForKey:key],[keyValues valueForKey:Key]];
        
        //            }
        
        //            count++;
        
        //        }
        
        
        
        NSArray *keys = [keyValues allKeys];
        
        NSArray *values = [keyValues allValues];
        
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@ (", tableName]];
        
        NSInteger count = 0;
        
        for (NSString *key in keys) {
            
            
            
            [sql appendString:key];
            
            count ++;
            
            if (count < [keys count]) {
                
                
                
                [sql appendString:@", "];
                
            }
            
        }
        
        
        
        [sql appendString:@") VALUES ("];
        
        
        
        
        
        for (int i = 0; i < [values count]; i++) {
            
            
            
            [sql appendString:@"?"];
            
            
            
            if (i < [values count] - 1) {
                
                
                
                [sql appendString:@","];
                
            }
            
            
            
        }
        
        
        
        [sql appendString:@")"];
        
        
        
        NSLog(@"%@", sql);
        
        
        
        [db executeUpdate:sql withArgumentsInArray:values];
        
        //关闭数据库
        [db close];
    }

}

#pragma mark -- 给指定数据库的表添加字段
-(void)DataBase:(FMDatabase *)db addFieldTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes{
    if ([self isOpenDatabese:db]) {
        for (NSString *key in keyTypes) {
            if (![db columnExists:key inTableWithName:tableName]){
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@",tableName,key,[keyTypes objectForKey:key]];
                BOOL worked = [db executeUpdate:alertStr];
                if(worked){
                    NSLog(@"插入成功");
                }else{
                    NSLog(@"插入失败");
                }
            }
            
        }
        //关闭数据库
        [db close];
    }
}



#pragma mark --给指定数据库的表更新值

-(void)DataBase:(FMDatabase *)db updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValues

{
    
    if ([self isOpenDatabese:db]) {
        
        for (NSString *key in keyValues) {
            
            NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ?", tableName, key]];
            
            [db executeUpdate:sql,[keyValues valueForKey:key]];
            
        }
        //关闭数据库
        [db close];
    }
    
}

#pragma mark --条件更新

-(void)DataBase:(FMDatabase *)db updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValues whereCondition:(NSDictionary *)condition

{
    
    if ([self isOpenDatabese:db]) {
        
        for (NSString *key in keyValues) {
            
            NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", tableName, key, [condition allKeys][0]]];
            
            [db executeUpdate:sql,[keyValues valueForKey:key],[keyValues valueForKey:[condition allKeys][0]]];
            
        }
        //关闭数据库
        [db close];
    }
    
}

#pragma mark --查询数据库表中的所有值

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName

{
    
    FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ LIMIT 10",tableName]];
    
    return [self getArrWithFMResultSet:result keyTypes:keyTypes DataBase:db];
    
}

#pragma mark --条件查询数据库中的数据

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereCondition:(nonnull NSArray<NSDictionary *> *)condition count:(NSInteger)num;

{
    
    if ([self isOpenDatabese:db]) {
        
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE ", tableName]];
        NSMutableArray *values = [NSMutableArray array];
        BOOL isFrist = YES;
        for (NSDictionary *dict in condition) {
            if (isFrist) {
                [sql appendString:[NSString stringWithFormat:@"%@ = ?",[[dict allKeys] firstObject]]];
                [values addObject:[[dict allValues] firstObject]];
                isFrist = NO;
            }else{
                if ([[[dict allKeys] firstObject] isEqualToString:@"queryStr"]) {
                    [sql appendString:[NSString stringWithFormat:@" and %@",[[dict allValues] firstObject]]];
                }else{
                    [sql appendString:[NSString stringWithFormat:@" and %@ = ?",[[dict allKeys] firstObject]]];
                    [values addObject:[[dict allValues] firstObject]];
                }
            }
        }
        if (num > 0) {
            //限制条数
            [sql appendString:[NSString stringWithFormat:@" LIMIT %ld",(long)num]];
        }
        FMResultSet *result = [db executeQuery:sql values:values error:nil];
        return [self getArrWithFMResultSet:result keyTypes:keyTypes DataBase:db];
        
    }
     
    return nil;

}

#pragma mark --模糊查询 某字段以指定字符串开头的数据

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key beginWithStr:(NSString *)str

{
    
    if ([self isOpenDatabese:db]) {
        
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE %@%% LIMIT 10",tableName, key, str]];
        
        return [self getArrWithFMResultSet:result keyTypes:keyTypes DataBase:db];
        
    }
        
    return nil;
    
    
    
}

#pragma mark --模糊查询 某字段包含指定字符串的数据

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key containStr:(NSString *)str

{
    
    if ([self isOpenDatabese:db]) {
        
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE %%%@%% LIMIT 10",tableName, key, str]];
        
        return [self getArrWithFMResultSet:result keyTypes:keyTypes DataBase:db];
        
    }
    return nil;
    
}

#pragma mark --模糊查询 某字段以指定字符串结尾的数据

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key endWithStr:(NSString *)str

{
    
    if ([self isOpenDatabese:db]) {
        
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE %%%@ LIMIT 10",tableName, key, str]];
        
        
        
        return [self getArrWithFMResultSet:result keyTypes:keyTypes DataBase:db];
        
    }
    return nil;
    
}

#pragma mark --清理指定数据库中的数据

-(void)clearDatabase:(FMDatabase *)db from:(NSString *)tableName

{
    
    if ([self isOpenDatabese:db]) {
        
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",tableName]];
        //关闭数据库
        [db close];
    }
    
}

#pragma mark --CommonMethod

-(NSArray *)getArrWithFMResultSet:(FMResultSet *)result keyTypes:(NSDictionary *)keyTypes DataBase:(FMDatabase *)db

{
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    while ([result next]) {
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < keyTypes.count; i++) {
            
            NSString *key = [keyTypes allKeys][i];
            
            NSString *value = [keyTypes valueForKey:key];
            
            if ([value isEqualToString:@"text"]) {
                
                //                字符串
                
                [tempDic setValue:[result stringForColumn:key] forKey:key];
                
            }else if([value isEqualToString:@"blob"])
                
            {
                
                //                二进制对象
                
                [tempDic setValue:[result dataForColumn:key] forKey:key];
                
            }else if ([value isEqualToString:@"integer"])
                
            {
                
                //                带符号整数类型
                
                [tempDic setValue:[NSNumber numberWithInt:[result intForColumn:key]]forKey:key];
                
            }else if ([value isEqualToString:@"boolean"])
                
            {
                
                //                BOOL型
                
                [tempDic setValue:[NSNumber numberWithBool:[result boolForColumn:key]] forKey:key];
                
                
                
            }else if ([value isEqualToString:@"date"])
                
            {
                
                //                date
                
                [tempDic setValue:[result dateForColumn:key] forKey:key];
                
            }
            
            
            
        }
        
        [tempArr addObject:tempDic];
        
    }
    //关闭数据库
    [db close];
    return tempArr;
}

-(BOOL)isOpenDatabese:(FMDatabase *)db

{
    
    if (![db open]) {
        
        [db open];
        
    }
    
    return YES;
    
}


@end
