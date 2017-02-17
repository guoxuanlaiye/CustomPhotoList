//
//  AlbumDateHeaderView.m
//  自定义相册demo
//
//  Created by 郭轩 on 16/12/4.
//  Copyright © 2016年 guoxuan. All rights reserved.
//

#import "AlbumDateHeaderView.h"

#define  RGBA_COLOR(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

@interface AlbumDateHeaderView ()
@property (nonatomic ,strong)UILabel * dateLabel;

@end

@implementation AlbumDateHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        UILabel * dateLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 56)];
        dateLab.textColor = RGBA_COLOR(75, 75, 75, 1);
        dateLab.font      = [UIFont systemFontOfSize:14.0];
        self.dateLabel    = dateLab;
        [self.contentView addSubview:dateLab];
        
        UIButton * allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        allSelectBtn.frame = CGRectMake(self.frame.size.width-80, 0, 80, 56);
        [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
        [allSelectBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        allSelectBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [allSelectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [allSelectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [allSelectBtn addTarget:self action:@selector(allSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.allSelectButton = allSelectBtn;
        [self.contentView addSubview:allSelectBtn];

    }
    return self;
}
-(void)setDateStr:(NSString *)dateStr
{
    _dateStr = dateStr;
    self.dateLabel.text = dateStr;
}
- (void)setIsAllSelect:(BOOL)isAllSelect
{
    _isAllSelect = isAllSelect;
    self.allSelectButton.selected = isAllSelect;
}
- (void)setHeaderSection:(NSInteger)headerSection
{
    _headerSection = headerSection;
}
- (void)allSelectBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    _allSelectBlock(_headerSection,button);
}
@end
