//
//  HQHttpTool.h
//  侧拉菜单
//
//  Created by 何青 on 2018/1/22.
//  Copyright © 2018年 何青. All rights reserved.
//

#import "AFHTTPSessionManager.h"

//请求成功回调
typedef void (^requestSuccessBlock) (NSDictionary *dic);
//请求失败回调
typedef void (^requestFailureBlock) (NSError *error);

typedef  enum{
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

@interface HQHttpTool : AFHTTPSessionManager

+ (instancetype) shareManager;
- (void)setSessionID:(NSString*)session;
- (void)requestWithMethod:(HTTPMethod)method  WithPath:(NSString *)path withParams:(NSDictionary *)params withSuccessBlock:(requestSuccessBlock)success withFailureBlock:(requestFailureBlock)failure;

- (void)requestWithMethod:(HTTPMethod)method WithPath:(NSString *)path withParams:(NSDictionary *)params withImageData:(NSData *)imageData fileName:(NSString*)fileName
                className:(NSString*)clsName withSuccessBlock:(requestSuccessBlock)success withFailureBlock:(requestFailureBlock)failure;
@end



