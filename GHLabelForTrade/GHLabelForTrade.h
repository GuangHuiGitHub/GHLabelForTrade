//
//  GHLabelForTrade.h
//  GHLabelForTrade
//
//  Created by GhGh on 15/9/24.
//  Copyright © 2015年 GhGh. All rights reserved.
//
/*
 说明，引入的时候需要导入 CoreText.framework
 支持ios7.0以上版本
 来自：GH，王光辉
 QQ：595000359
 email：ghhoping@163.com
 */
#import <UIKit/UIKit.h>
@interface GHLabelForTrade : UIView
- (void)setText:(NSString *)contentText withFont:(NSInteger)fontNum needMaxLines:(NSInteger)maxLine andTipsText:(NSString *)tipsText withTipsTextBgcolor:(UIColor *)TipsTextBgcolor;
@end
