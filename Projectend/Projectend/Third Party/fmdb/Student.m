//
//  Student.m
//  Projectend
//
//  Created by Ominext Mobile on 5/14/16.
//  Copyright © 2016 Ominext Mobile. All rights reserved.
//

#import "Student.h"

@implementation Student
+ (NSArray*)getFieldsList {
    static NSArray *arr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[
                k_id,           //1
                k_name,         //2
                k_dateofbirth,  //3
                k_sex,          //4
                k_phone,        //5
                k_address,      //6
                k_idclass,      //7
                k_username,     //8
                k_password,     //9
                k_deleted       //10
                ];
    });
    
    return arr;
}

+ (NSArray*)getFieldOption {
    static NSArray *arr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[
                ksIntPrimaryInc,    //1
                ksText,             //2
                ksText,             //3
                ksText,             //4
                ksInteger,          //5
                ksText,             //6
                ksInteger,          //7
                ksText,             //8
                ksText,             //9
                ksInteger           //10
                ];
    });
    return arr;
}

+ (NSArray*) queryListStudent {
    FMDatabase *db = [DB db];
    [db open];
    NSArray *arrCompany = [self queryListStudent:db];
    [db close];
    
    return arrCompany;
}

+ (NSArray*) queryListStudent:(FMDatabase*)db {
    NSString *queryString = [NSString stringWithFormat:@"%@ = 0",k_deleted];
    NSArray *studentDics = [Student selectWhere:queryString db:db];
    
    NSMutableArray *listStudent = [NSMutableArray array];
    
    for (NSDictionary *dic in studentDics) {
        Student *student = [[Student alloc]initWithDic:dic];
        [listStudent addObject:student];
    }
    return listStudent;
}
@end
