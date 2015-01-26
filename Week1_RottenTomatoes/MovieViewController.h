//
//  MovieViewController.h
//  Week1_RottenTomatoes
//
//  Created by Qiyuan Liu on 1/25/15.
//  Copyright (c) 2015 liuqiyuan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSDictionary *movieDict;
@property (weak, nonatomic) IBOutlet UIImageView *movieDetailImageView;
@property (weak, nonatomic) IBOutlet UITableView *movieDetailTableView;

@end
