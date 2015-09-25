//
//  GHTradeLabel.m
//  GHLabelForTrade
//
//  Created by GhGh on 15/9/24.
//  Copyright © 2015年 GhGh. All rights reserved.
/*
 说明，引入的时候需要导入 CoreText.framework
 支持ios7.0以上版本
 来自：GH，王光辉
 QQ：595000359
 email：ghhoping@163.com
*/
#import "GHLabelForTrade.h"
#import <CoreText/CoreText.h>
@interface GHLabelForTrade()
@property (nonatomic, strong) UILabel *oneLineLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, assign) BOOL isContentChar;
@end
@implementation GHLabelForTrade
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.oneLineLabel = [self creatLabel];

        
        UILabel *tipsLabel = [[UILabel alloc] init];
        self.tipsLabel = tipsLabel;
        tipsLabel.userInteractionEnabled = YES;
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.textColor = [UIColor whiteColor];
        [self.oneLineLabel addSubview:tipsLabel];
         self.isContentChar = NO;
    }
    return self;
}
- (UILabel *)creatLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    [self addSubview:label];
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    return label;
}
- (void)setText:(NSString *)contentText withFont:(NSInteger)fontNum needMaxLines:(NSInteger)maxLine andTipsText:(NSString *)tipsText withTipsTextBgcolor:(UIColor *)TipsTextBgcolor;
{
    self.tipsLabel.text = tipsText;
    self.tipsLabel.backgroundColor = TipsTextBgcolor;
    // 计算tipsText
    CGSize tipsTextSize = [self sizeWithText:tipsText Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    self.tipsLabel.layer.masksToBounds = YES;
    self.tipsLabel.layer.cornerRadius = 3;
    
    CGSize textSize = [self sizeWithText:contentText Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    self.oneLineLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    self.oneLineLabel.text = contentText;
    self.oneLineLabel.font = [UIFont systemFontOfSize:fontNum];
    
//    self.tempLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
//    self.tempLabel.text = contentText;
//    self.tempLabel.font = [UIFont systemFontOfSize:fontNum];
    
    // 验证中文
//    NSMutableString *noEnglishChar = [NSMutableString string];
    for (int i = 0; i<[contentText length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [contentText substringWithRange:NSMakeRange(i, 1)];
        [self testInclodedEnglishChar:s];
    }
    
    NSArray *textArray = [self getSeparatedLinesFromLabel:self.oneLineLabel];
    // 最终字符串
    NSMutableString *lastValueStrM = [NSMutableString string];
    if (textArray.count > maxLine) {
        NSMutableArray *textArrayM = [NSMutableArray arrayWithCapacity:2];
        [textArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx < maxLine) {
                [textArrayM addObject:obj];
            }else
                *stop = YES;
        }];
        // 取出最后一个字符串
        NSString *lastLineText = [textArrayM lastObject];
            // 说明相加大于一行 - 必须的
             NSString *lastTureText = [lastLineText substringToIndex:lastLineText.length - tipsText.length - 2];
            lastTureText = [NSString stringWithFormat:@"%@...",lastTureText];
        CGSize lastLineTureSize = [self sizeWithText:lastTureText Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width + 1, self.frame.size.height + 1)];
            for (int i = 0; i < textArrayM.count - 1; ++i) {
                [lastValueStrM appendString:textArrayM[i]];
            }
            [lastValueStrM appendString:lastTureText];
            CGSize lastAllTureSize = [self sizeWithText:lastValueStrM Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
            self.oneLineLabel.text = lastValueStrM;
            self.oneLineLabel.frame = CGRectMake(0, 0, lastAllTureSize.width, lastAllTureSize.height);
            self.tipsLabel.frame = CGRectMake(lastLineTureSize.width + 2, lastAllTureSize.height - tipsTextSize.height - 1, tipsTextSize.width+1, tipsTextSize.height+1);
            self.tipsLabel.font = [UIFont systemFontOfSize:fontNum-3];
    }
    else if (textArray.count == maxLine)
    {
        // 说明相等有2种情况
        // 最后一行大于
        NSString *lastLineText = [textArray lastObject];
        CGSize lastLineSize = [self sizeWithText:lastLineText Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width + 1, self.frame.size.height + 1)];
        if ((lastLineSize.width + tipsTextSize.width) >= self.frame.size.width) {
            // 说明相加大于一行 - 必须的
            NSString *lastTureText = [lastLineText substringToIndex:lastLineText.length - tipsText.length - 2];
            lastTureText = [NSString stringWithFormat:@"%@...",lastTureText];
            CGSize lastLineTureSize = [self sizeWithText:lastTureText Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width + 1, self.frame.size.height + 1)];
            for (int i = 0; i < textArray.count - 1; ++i) {
                [lastValueStrM appendString:textArray[i]];
            }
            [lastValueStrM appendString:lastTureText];
            CGSize lastAllTureSize = [self sizeWithText:lastValueStrM Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
            self.oneLineLabel.text = lastValueStrM;
            self.oneLineLabel.frame = CGRectMake(0, 0, lastAllTureSize.width, lastAllTureSize.height);
            self.tipsLabel.frame = CGRectMake(lastLineTureSize.width + 2, lastAllTureSize.height - tipsTextSize.height - 1, tipsTextSize.width+1, tipsTextSize.height+1);
            self.tipsLabel.font = [UIFont systemFontOfSize:fontNum-3];
        }else
        {
            // 说明小于等于情况
             NSString *lastLineText = [textArray lastObject];
            CGSize lastLineSize = [self sizeWithText:lastLineText Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width + 1, self.frame.size.height + 1)];
            self.oneLineLabel.text = contentText;
            self.oneLineLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
            self.tipsLabel.frame = CGRectMake(lastLineSize.width + 2, textSize.height - tipsTextSize.height - 1, tipsTextSize.width+1, tipsTextSize.height+1);
            self.tipsLabel.font = [UIFont systemFontOfSize:fontNum-3];
        }
        
    }else
    {
        // 小于规定的行数情况
        // 等于一行
        if (textArray.count == 1) {
            // 判断共2种情况
            if ((textSize.width + tipsTextSize.width) >= self.frame.size.width) {
                // 说明相加大于一行 - 必须的
                contentText = [NSString stringWithFormat:@"%@            ",contentText];
                CGSize lastAllTureSize = [self sizeWithText:contentText Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
                self.oneLineLabel.text = contentText;
                self.oneLineLabel.frame = CGRectMake(0, 0, lastAllTureSize.width, lastAllTureSize.height);
                self.tipsLabel.frame = CGRectMake(0, tipsTextSize.height-1, tipsTextSize.width+1, tipsTextSize.height+1);
                self.tipsLabel.font = [UIFont systemFontOfSize:fontNum-3];
            }else
            {
                // 一行搞定
                self.oneLineLabel.text = contentText;
                self.oneLineLabel.frame = CGRectMake(0, 0, textSize.width+tipsTextSize.width, textSize.height);
                self.tipsLabel.frame = CGRectMake(textSize.width+1, 0, tipsTextSize.width+1, tipsTextSize.height+1);
                self.tipsLabel.font = [UIFont systemFontOfSize:fontNum-3];
            }
            
        }else
        {
            // 大于一行 - 要显示完整
            // 考虑最后一行情况
            NSString *lastLineText = [textArray lastObject];
            CGSize lastLineSize = [self sizeWithText:lastLineText Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width + 1, self.frame.size.height + 1)];
            if ((lastLineSize.width + tipsTextSize.width) >= self.frame.size.width) {
                // 说明相加大于一行 - 必须的
                contentText = [NSString stringWithFormat:@"%@            ",contentText];
                CGSize lastAllTureSize = [self sizeWithText:contentText Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width, MAXFLOAT)];
                self.oneLineLabel.text = contentText;
                self.oneLineLabel.frame = CGRectMake(0, 0, lastAllTureSize.width, lastAllTureSize.height);
                self.tipsLabel.frame = CGRectMake(0, lastAllTureSize.height-tipsTextSize.height-1, tipsTextSize.width+1, tipsTextSize.height+1);
                self.tipsLabel.font = [UIFont systemFontOfSize:fontNum-3];           }else
            {
                // 最后一行正好
                NSString *lastLineText = [textArray lastObject];
                CGSize lastLineSize = [self sizeWithText:lastLineText Font:[UIFont systemFontOfSize:fontNum] MaxSize:CGSizeMake(self.frame.size.width + 1, self.frame.size.height + 1)];
                // 一行搞定
                self.oneLineLabel.text = contentText;
                self.oneLineLabel.frame = CGRectMake(0, 0, textSize.width+tipsTextSize.width, textSize.height);
                self.tipsLabel.frame = CGRectMake(lastLineSize.width+1, textSize.height-tipsTextSize.height-1, tipsTextSize.width+1, tipsTextSize.height+1);
                self.tipsLabel.font = [UIFont systemFontOfSize:fontNum-3];
                
            }
            
        }
        
    }
}
- (CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font MaxSize:(CGSize)maxSize
{
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName : font} context:nil].size;
}

- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    NSMutableArray *lastArrayM = [NSMutableArray arrayWithArray:linesArray];
    if (self.isContentChar && [[lastArrayM lastObject] length] < 2) {
        [lastArrayM removeLastObject];
    }
    return (NSArray *)lastArrayM;
}

- (void)testInclodedEnglishChar:(NSString *)str
{
    NSInteger temp = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if(temp == 1)
    {
        self.isContentChar = YES;
    }
}
@end
