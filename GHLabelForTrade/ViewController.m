//
//  ViewController.m
//  GHLabelForTrade
//
//  Created by 王光辉 on 15/9/24.
//  Copyright (c) 2015年 WGH. All rights reserved.
//

#import "ViewController.h"
#import "GHLabelForTrade.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self creatGHLabel:@"社会生产力的发展产生出用于交换的剩余商品，这些剩余商品在国与国之间交换，就产生了国际贸易。" andFrame:CGRectMake(50, 50, 200, 50)];
    
    [self creatGHLabel:@"社【会生产力】的发展" andFrame:CGRectMake(50, 170, 200, 50)];
    
    [self creatGHLabel:@"社会生产力]的生出用" andFrame:CGRectMake(50, 280, 200, 50)];
    
    [self creatGHLabel:@"社会生产力]的生出用.><<<<<" andFrame:CGRectMake(50, 400, 200, 50)];
}

- (void)creatGHLabel:(NSString *)contentText andFrame:(CGRect)frame
{
    GHLabelForTrade *label = [[GHLabelForTrade alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor grayColor];
    [label setText:contentText withFont:13 needMaxLines:3 andTipsText:@"优惠中" withTipsTextBgcolor:[UIColor orangeColor]];
    [self.view addSubview:label];
}

@end
