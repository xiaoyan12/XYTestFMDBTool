//
//  ViewController.m
//  XYFMDBTest
//
//  Created by 闫世超 on 2019/6/3.
//  Copyright © 2019 闫世超. All rights reserved.
//

#import "ViewController.h"
#import "XYFMDBTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建数据库
//    [[XYFMDBTool sharedFMDBTool] createFMDatabase];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClick:(UIButton *)sender {
    [[XYFMDBTool sharedFMDBTool]deleteFMDBTable:@"classMessage"];
    [[XYFMDBTool sharedFMDBTool]deleteFMDBTable:@"classUserInfo"];
}


- (void)createData{
    
    for (int i  = 0; i< 10; i++) {
 
        NSDictionary *addUser = @{
                                  @"my_userId":@"integer",
                                  @"my_avatrar":@"text",
                                  @"my_nickname":@"text",
                                  @"to_userId":@"integer",
                                  @"to_avatrar":@"text",
                                  @"to_nickname":@"text"
                                  };
        [[XYFMDBTool sharedFMDBTool] addFieldFMDBTable:@"classUserInfo" keyTypes:addUser];
        
        NSDictionary *userINfo = @{
                                   @"chatOne_id":[NSString stringWithFormat:@"20737_%d",i],
                                   @"my_userId":@"20737",
                                   @"my_avatrar":@"cbsdacnoncoianvc",
                                   @"my_nickname":@"bcsauibcabncvaon",
                                   @"to_userId":@"123456",
                                   @"to_avatrar":@"cnvaojpajncaoimcpoam",
                                   @"to_nickname":@"vmcapomvcadspmvdvnio"
                                   };
        [[XYFMDBTool sharedFMDBTool] insertFMDBKeyValues:userINfo intoTable:@"classUserInfo"];
    
        NSUInteger r = arc4random_uniform(20);
        
        for (int j = 0; j < r; j++) {
            NSDictionary *msgUser = @{
                                      @"msg_index":@"integer",
                                      @"my_userId":@"integer",
                                      @"my_avatrar":@"text",
                                      @"my_nickname":@"text",
                                      @"to_userId":@"integer",
                                      @"to_avatrar":@"text",
                                      @"to_nickname":@"text"
                                      };
            [[XYFMDBTool sharedFMDBTool] addFieldFMDBTable:@"classMessage" keyTypes:msgUser];
            
            
            NSDictionary *msgInfo = @{
                                      
                                      @"chatOne_id":[NSString stringWithFormat:@"20737_%d",i],
                                      @"chatOne_msg_id":[NSString stringWithFormat:@"%d_%d",i,j],
                                      @"msg_index":@(j),
                                      @"my_userId":@"20737",
                                      @"my_avatrar":@"nvoiancviopanciasonia",
                                      @"my_nickname":@"bcsauibcabncvaon",
                                      @"to_userId":@"123456",
                                      @"to_avatrar":@"cnvaojpajncaoimcpoam",
                                      @"to_nickname":@"vmcapomvcadspmvdvnio"
                                      };
            [[XYFMDBTool sharedFMDBTool] insertFMDBKeyValues:msgInfo intoTable:@"classMessage"];
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
}
- (IBAction)add:(UIButton *)sender {
    [self createData];
}
- (IBAction)select:(UIButton *)sender {
    
    NSDictionary *msgUser = @{@"chatOne_id":@"text",
                              @"chatOne_msg_id":@"text",
                              @"msg_index":@"integer",
                              @"my_userId":@"integer",
                              @"my_avatrar":@"text",
                              @"my_nickname":@"text",
                              @"to_userId":@"integer",
                              @"to_avatrar":@"text",
                              @"to_nickname":@"text"
                              };
    
    NSArray *arr = [[XYFMDBTool sharedFMDBTool] selectFMDBKeyTypes:msgUser
                                                         fromTable:@"classMessage"
                                                    whereCondition:@[@{@"chatOne_id":@"20737_1"},
                                                                     /*@{@"chatOne_msg_id":@"1_2"} */
                                                                     @{@"queryStr":@"msg_index <= 1 AND msg_index > -9"}
                                                                     ] count:10];
    NSLog(@"%@",arr);
}


@end
