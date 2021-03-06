//
//  SkinViewModel.m
//  AISkinMeasurement
//
//  Created by Joe on 2020/5/20.
//  Copyright © 2020 Joe. All rights reserved.
//

#import "SkinViewModel.h"
#import <AFNetworking/AFNetworking.h>

@implementation SkinViewModel



+ (void)analysisInfoQuery:(NSString *)recordNo
                  success:(void(^)(id data))success
                     fail:(void(^)(NSString *message))fail{


    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];


    NSString *urlString = @"http://192.168.199.201:19097/cosmetology-app/faceAnalysis/query/analysisInfoQuery";
    NSDictionary *para = @{@"deviceNo":@"123",@"recordNo":recordNo};
    
    [manager POST:urlString parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


+ (void)applyAnalysisCommand:(UIImage *)images
       analysisPersonnelType:(NSString *)analysisPersonnelType
                     success:(void(^)(id data))success
                        fail:(void(^)(NSString *message))fail{


    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];


    NSString *urlString = @"http://192.168.199.201:19097/cosmetology-app/faceAnalysis/command/applyAnalysisCommand";
    NSDictionary *para = @{@"deviceNo":@"123",@"deviceType":@"ios",@"analysisPersonnelType":analysisPersonnelType};
//    content = [content fixOrientation];
    NSData *imageData = UIImageJPEGRepresentation(images, 1);

    //post请求
    [manager POST:urlString parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat   = @"YYYY-MM-dd-hh:mm:ss:SSS";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 我这里的imgFile是对应后台给你url里面的图片参数，别瞎带。
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:imageData name:@"images" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        float progress =  1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        NSLog(@"上传图片进度%f",progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        int code = [responseObject[@"code"] intValue];
        if (code == 200) {
            success(responseObject[@"data"]);
        }else{
            fail(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
        fail(error.description);
    }];
}

+ (void)analysisListQuery:(void(^)(id data))success
                     fail:(void(^)(NSString *message))fail{


    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];


    NSString *urlString = @"http://192.168.199.201:19097/cosmetology-app/faceAnalysis/query/analysisListQuery";
    NSDictionary *para = @{@"deviceNo":@"123"};
    
    [manager POST:urlString parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
