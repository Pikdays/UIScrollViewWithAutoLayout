//
//  HUViewController.m
//  UIScrollViewWithAutoLayout
//
//  Created by Nova on 15-1-8.
//  Copyright (c) 2015年 huhuTec. All rights reserved.
//

#import "HUViewController.h"

@interface HUViewController ()

@end

@implementation HUViewController

-(void)awakeFromNib{
    
    
}
/*
 关于autolayout把握如下三点就行了:
 1.系统应该能够根据你设置的constraints,推断出你的view的frame的大小,即x,y,width,height,否则系统会显示警告信息.这点好理解.
 2.如果你使用了约束,就不要再设置frame了,这点很好理解,你又用frame,又用约束,很容易产生冲突的,所以只能二选一.
 3. 创建完 NSLayoutConstraint 接下来要将它添加到 view 里，添加方法很简单，用 view 的- (void)addConstraint:(NSLayoutConstraint *)constraint添加。但是应该添加到哪个 view 里呢？
 a.兄弟 view 的 Constraint 添加到他们的 superview
 b.两个 view 的父 view 是兄弟关系的，Constraint 添加到父 view 的 superview 上
 c.如果两个 view 是 parent-child 关系，Constraint 添加到 parent view上
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints=NO;
    UIScrollView* scrollview=[[UIScrollView alloc] init];
    //要使用autolayout,这个设置是必须的,要不然会发生约束冲突
    scrollview.translatesAutoresizingMaskIntoConstraints=NO;
    [scrollview setPagingEnabled:YES];
    [scrollview setShowsVerticalScrollIndicator:NO];
    [scrollview setShowsHorizontalScrollIndicator:YES];
    [self.view addSubview:scrollview];
    //先在UIScrollView中添加一个子视图,注意了UIScrollView只能有一个子视图.
    UIView* conview=[[UIView alloc] init];
    conview.translatesAutoresizingMaskIntoConstraints=NO;
    [scrollview addSubview:conview];
    NSDictionary* views=@{@"conview":conview,@"scrollview":scrollview};
    //要求scrollview和当前的view严丝合缝滴
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollview]|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollview]|" options:0 metrics:0 views:views]];
    
    //要求conview和scrollview严丝合缝滴
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[conview]|" options:0 metrics:0 views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[conview]|" options:0 metrics:0 views:views]];
    
    //因为下页要添加十个子视图,所以conview的宽度为scrollview的十倍. 注意conview的宽度变成了scrollview的十倍之后,仍然要与满足上面那和约束的要求,于是乎,scrollview就知道了自己的contentSize,就产生的滚动的效果了.
    [scrollview addConstraint:[NSLayoutConstraint constraintWithItem:conview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollview attribute:NSLayoutAttributeWidth multiplier:10 constant:0]];
    
    
    UILabel* pre=nil;
    for(int i=0;i<10;i++)
    {
        UILabel* label=[[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints=NO;
        label.text=[NSString stringWithFormat:@"%d/10",i+1];
        label.textAlignment=NSTextAlignmentCenter;
        [conview addSubview:label];
        //为什么下面的这些代码是必须的,请参照规则1
        //label的宽度和高度要与scrollview一致
        [scrollview addConstraint:[ NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollview attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        [scrollview addConstraint:[ NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:scrollview attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        
        if(pre==nil){//如果是第一个页面的话
            NSDictionary* dic=@{@"label":label};
            //lable只要贴住conview就行了.
            [conview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]" options:0 metrics:nil views:dic]];
            [conview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]" options:0 metrics:nil views:dic]];
        }
        else{//如果是后续的页面的话
            NSDictionary* dic=@{@"label":label,@"pre":pre};
            //当前label放在pre的后面
            [conview addConstraint:[ NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:pre attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
            //注意上面只横向布局,下面这个纵向布局得有,才不会导致约束缺少错误.
            [conview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]" options:0 metrics:nil views:dic]];
            
        }
        pre=label;
    }
    
    UILabel* info=[[UILabel alloc] init];
    info.translatesAutoresizingMaskIntoConstraints=NO;
    info.text=@"欢迎交流,QQ:422596694";
    [info sizeToFit];
    [self.view addSubview:info];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:info attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:info attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
