//
//  HQHttpTool.m
//  侧拉菜单
//
//  Created by 何青 on 2018/1/22.
//  Copyright © 2018年 何青. All rights reserved.
//

#import "HQHttpTool.h"

#define TestUrl @"http://httpbin.org/"
#define OfficialUrl @"http://httpbin.org/"
#define CacheSessionID @"CacheSessionID"

static NSString *sessionID;

@implementation HQHttpTool

+ (instancetype) shareManager{
    static HQHttpTool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:TestUrl]];
    });
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer.timeoutInterval = 10;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}



- (void)requestWithMethod:(HTTPMethod)method  WithPath:(NSString *)path withParams:(NSDictionary *)params withSuccessBlock:(requestSuccessBlock)success withFailureBlock:(requestFailureBlock)failure{
    switch (method) {
        case GET:{
            [self GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
        case POST:
        {
            [self POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)requestWithMethod:(HTTPMethod)method WithPath:(NSString *)path withParams:(NSDictionary *)params withImageData:(NSData *)imageData fileName:(NSString*)fileName
                className:(NSString*)clsName withSuccessBlock:(requestSuccessBlock)success withFailureBlock:(requestFailureBlock)failure{
    if (imageData && imageData.length) {
        [self POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
              [formData appendPartWithFileData:imageData name:fileName.length ? fileName :@"onebigimage" fileName:fileName.length ? fileName : @"onebigimage" mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
            NSHTTPURLResponse *urlRsp = (NSHTTPURLResponse*)task.response;
            NSString* temp = urlRsp.allHeaderFields[@"Set-Cookie"];
            if ([temp isKindOfClass:[NSString class]]) {
                NSArray *arr = [temp componentsSeparatedByString:@"; "];
                if (arr.count) {
                    for (NSString *str in arr) {
                        NSArray *kv = [str componentsSeparatedByString:@"="];
                        if (kv.count == 2 && [kv[0] isEqualToString:@"JSESSIONID"]) {
                            //                             Set-Cookie1
                            [self setSessionID:kv[1]];
                            break;
                        }
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
}

- (void)setSessionID:(NSString*)session
{
    if (! session) {
        sessionID = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CacheSessionID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (![sessionID isEqualToString:session]) {
        sessionID = session;
        [[NSUserDefaults standardUserDefaults] setObject:sessionID forKey:CacheSessionID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
