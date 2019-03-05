//
//  OSSClientObj.m
//  meirong
//
//  Created by yangfeng on 2018/12/15.
//  Copyright © 2018年 yangfeng. All rights reserved.
//

#import "AliyunOSSUpload.h"

NSString * const accessKeyId = @"LTAIu7vLHT1bCw7t";
NSString * const accessKeySecret = @"VgMMcHDd7Y7RzxqoNtAghlX5ayfFm4";
NSString * const bucket = @"mecen";

@interface AliyunOSSUpload ()

@property (nonatomic, strong) OSSClient *client;

@end


@implementation AliyunOSSUpload


// 创建静态对象 防止外部访问
static AliyunOSSUpload *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+ (instancetype)shareOSSClientObj {
    // 最好用self 用OSSClientObj他的子类调用时会出现错误
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)setupEnvironment {
//    // 打开调试log
//    [OSSLog enableLog];
    
    // 初始化sdk
    [self initOSSClient];
}

- (void)initOSSClient {
    
//    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accessKeyId secretKeyId:accessKeySecret securityToken:@"SecurityToken43"];
    
    // 自实现签名，可以用本地签名也可以远程加签
    id<OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:accessKeySecret];
        if (signature != nil) {
            *error = nil;
        } else {
            // construct error object
            *error = [NSError errorWithDomain:@"<your error domain>" code:OSSClientErrorCodeSignFailed userInfo:nil];
            return nil;
        }
        return [NSString stringWithFormat:@"OSS %@:%@", accessKeyId, signature];
    }];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    
    // 网络请求遇到异常失败后的重试次数
    conf.maxRetryCount = 3;
    
    // 网络请求的超时时间
    conf.timeoutIntervalForRequest =30;
    
    // 允许资源传输的最长时间
    conf.timeoutIntervalForResource =24 *60 * 60;
    
    // 你的阿里地址前面通常是这种格式 :http://oss……
    _client = [[OSSClient alloc] initWithEndpoint:ENDPOINT credentialProvider:credential];
}

- (void)updateToALi:(NSData *)data imageName:(NSString *)imageName
{
    CGFloat kb = [data length] / 1024.0 / 1024.0;
    //NSLog(@"kb = %.2lf",kb);
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    put.bucketName = bucket;
    put.objectKey = imageName;
    put.contentType = @"image/png";
    put.uploadingData = data; // 直接上传NSData
    
    put.uploadProgress = ^(int64_t bytesSent,int64_t totalByteSent,int64_t totalBytesExpectedToSend) {
//        NSLog(@"上传进度 = %lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [_client putObject:put];
    
    // 上传阿里云
    // 浏览图片 https://mecen.oss-cn-shenzhen.aliyuncs.com/def
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"上传阿里云 success!");
        } else {
            NSLog(@"上传阿里云 failed, error: %@" , task.error);
        }
        return nil;
    }];
    [putTask waitUntilFinished];
}

// 浏览图片 https://mecen.oss-cn-shenzhen.aliyuncs.com/def
- (NSString *)dowmLoadURL {
    NSMutableString *m_str = [NSMutableString stringWithString:ENDPOINT];
    [m_str insertString:[NSString stringWithFormat:@"%@.",bucket] atIndex:8];
    return m_str;
}

//// 断点续传
//- (void)resumableUpload {
//    __block NSString * recordKey;
//
//    NSString * docDir = [self getDocumentDirectory];
//    NSString * filePath = [docDir stringByAppendingPathComponent:@"file10m"];
//    NSString * bucketName = @"android-test";
//    NSString * objectKey = @"uploadKey";
//
//    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
//        // 为该文件构造一个唯一的记录键
//        NSURL * fileURL = [NSURL fileURLWithPath:filePath];
//        NSDate * lastModified;
//        NSError * error;
//        [fileURL getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
//        if (error) {
//            return [OSSTask taskWithError:error];
//        }
//        recordKey = [NSString stringWithFormat:@"%@-%@-%@-%@", bucketName, objectKey, [OSSUtil getRelativePath:filePath], lastModified];
//        // 通过记录键查看本地是否保存有未完成的UploadId
//        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//        return [OSSTask taskWithResult:[userDefault objectForKey:recordKey]];
//    }] continueWithSuccessBlock:^id(OSSTask *task) {
//        if (!task.result) {
//            // 如果本地尚无记录，调用初始化UploadId接口获取
//            OSSInitMultipartUploadRequest * initMultipart = [OSSInitMultipartUploadRequest new];
//            initMultipart.bucketName = bucketName;
//            initMultipart.objectKey = objectKey;
//            initMultipart.contentType = @"application/octet-stream";
//            return [self.client multipartUploadInit:initMultipart];
//        }
//        OSSLogVerbose(@"An resumable task for uploadid: %@", task.result);
//        return task;
//    }] continueWithSuccessBlock:^id(OSSTask *task) {
//        NSString * uploadId = nil;
//
//        if (task.error) {
//            return task;
//        }
//
//        if ([task.result isKindOfClass:[OSSInitMultipartUploadResult class]]) {
//            uploadId = ((OSSInitMultipartUploadResult *)task.result).uploadId;
//        } else {
//            uploadId = task.result;
//        }
//
//        if (!uploadId) {
//            return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
//                                                              code:OSSClientErrorCodeNilUploadid
//                                                          userInfo:@{OSSErrorMessageTOKEN: @"Can't get an upload id"}]];
//        }
//        // 将“记录键：UploadId”持久化到本地存储
//        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//        [userDefault setObject:uploadId forKey:recordKey];
//        [userDefault synchronize];
//        return [OSSTask taskWithResult:uploadId];
//    }] continueWithSuccessBlock:^id(OSSTask *task) {
//        // 持有UploadId上传文件
//        OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
//        resumableUpload.bucketName = bucketName;
//        resumableUpload.objectKey = objectKey;
//        resumableUpload.uploadId = task.result;
//        resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:filePath];
//        resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
//            NSLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
//        };
//        return [self.client resumableUpload:resumableUpload];
//    }] continueWithBlock:^id(OSSTask *task) {
//        if (task.error) {
//            if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
//                // 如果续传失败且无法恢复，需要删除本地记录的UploadId，然后重启任务
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
//            }
//        } else {
//            NSLog(@"upload completed!");
//            // 上传成功，删除本地保存的UploadId
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
//        }
//        return nil;
//    }];
//}



@end
