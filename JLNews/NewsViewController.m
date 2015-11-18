//
//  NewsViewController.m
//  JLNews
//
//  Created by 李大鹏 on 15/10/25.
//  Copyright (c) 2015年 Ldp. All rights reserved.
//

#import "NewsViewController.h"
#import "News.h"
#import "Masonry.h"
#import "TYAttributedLabel.h"
#import "JLDatabase.h"

@interface NewsViewController ()<TYAttributedLabelDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) TYAttributedLabel *contentLabel;

@end

@implementation NewsViewController

- (void)configLabelWith:(News *)news{
    _contentLabel.characterSpacing = 5;
    _contentLabel.linesSpacing = 5;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:news.title];
    [title addAttributeTextColor:[UIColor blackColor]];
    [title addAttributeFont:[UIFont boldSystemFontOfSize:18.0]];
    [_contentLabel appendTextAttributedString:title];
    [_contentLabel appendTextAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n\t"]];
    
    for (NSInteger i = 0; i<news.contentArray.count; i++) {
        NSString *string = news.contentArray[i];
        if ([string hasPrefix:@"[IMG-"]) {
            //            NSString *a = [string substringWithRange:NSMakeRange(5, 1)];
            NSInteger imageIndex = [[string substringWithRange:NSMakeRange(5, 1)] integerValue];
            TYImageStorage *imageUrlStorage = [[TYImageStorage alloc] init];
            imageUrlStorage.imageURL = [NSURL URLWithString:news.imageArr[imageIndex]];
            imageUrlStorage.size = CGSizeMake(CGRectGetWidth(_contentLabel.frame), 343*CGRectGetWidth(_contentLabel.frame)/600);
            [_contentLabel appendTextStorage:imageUrlStorage];
            [_contentLabel appendTextAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n\t"]];
        }
        else{
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:news.contentArray[i]];
            [content addAttributeFont:[UIFont systemFontOfSize:16.0]];
            [_contentLabel appendTextAttributedString:content];
            [_contentLabel appendTextAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n\t"]];
        }
    }
    //    [_contentLabel appendTextAttributedString:content];
    
    [_contentLabel sizeToFit];
    [_scrollView setContentSize:_contentLabel.frame.size];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻详情";
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    _contentLabel = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.frame) - 20, 0)];
    
    _contentLabel.delegate = self;
    [_scrollView addSubview:_contentLabel];
    [self configLabelWith:_news];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"News ViewController Delloc,ScrollView");
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)return:(id)sender {
    //    NSString *str = _textField.text;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    _returnBlock(_textField.text);
}
@end
