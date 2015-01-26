//
//  MoviesViewController.h
//  Week1_RottenTomatoes
//
//  Created by Qiyuan Liu on 1/25/15.
//  Copyright (c) 2015 liuqiyuan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UISearchBarDelegate>

@property (nonatomic) NSArray *moviesArray;
@property (nonatomic) NSMutableArray *searchArray;

- (void) makeGetCall;

@end
