//
//  ViewController.m
//  EncodeDeCode
//
//  Created by wwt on 15/11/5.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"

static NSString * const KEY0    = @"0123456789";//测试
static NSString * const KEY1    = @"1790365259";
static NSString * const KEY2    = @"1690782278";

@interface ViewController ()

@property (nonatomic, copy) NSArray *KEYS;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.KEYS = @[KEY0,KEY1,KEY2];
    
    NSDictionary *dict = @{@"username":@"17090872779",@"password":@"147258"};
    
    NSString *testStr = [dict JSONString];
    
    NSString *result = @"$6C$33trdso`ld$33$2@$3306181963668$33$3B$33q`rrvnse$33$2@$33056349$33$6E";
    
    testStr = [self encodeString:testStr];
    
    NSLog(@"加密之后：%d",[[self encodeString:testStr key:self.KEYS[0]] isEqualToString:result]);
    NSLog(@"加密之后：%d",[[self encodeString:testStr key:self.KEYS[1]] isEqualToString:result]);
    NSLog(@"加密之后：%@",[self encodeString:testStr key:self.KEYS[2]]);
    
    NSLog(@"加密之后：%@",[self decodeString:result key:self.KEYS[0]]);
    NSLog(@"加密之后：%@",[self decodeString:result key:self.KEYS[1]]);
    NSLog(@"加密之后：%@",[self decodeString:result key:self.KEYS[2]]);
    
}

- (NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
-(NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

/**
 * 加密
 *
 * @param str
 * @return
 */

- (NSString*)encodeString:(NSString*)data key:(NSString*)key{
    
    return [self analysisMethodData:data key:key];
}

/**
 * 解密
 *
 * @param str
 * @return
 */

- (NSString *)decodeString:(NSString *)data key:(NSString *)key {
    
    return [self decodeString:[self analysisMethodData:data key:key]];
}

/**
 * 加解密方法
 *
 * @param str
 * @return
 */

- (NSString *)analysisMethodData:(NSString *)data key:(NSString *)key{
    
    NSString *result=[NSString string];
    
    for(int i=0; i < [data length]; i++){
        
        int chData=[data characterAtIndex:i];
        for(int j = 0;j < [key length];j++){
            int chKey = [key characterAtIndex:j];
            chData = chData^chKey;
        }
        result = [NSString stringWithFormat:@"%@%@",result,[NSString stringWithFormat:@"%c",chData]];
    }
    
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
