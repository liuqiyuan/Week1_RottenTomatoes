//
//  MovieTableViewCell.h
//  Week1_RottenTomatoes
//
//  Created by Qiyuan Liu on 1/25/15.
//  Copyright (c) 2015 liuqiyuan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieImageViewInCell;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleInCell;
@property (weak, nonatomic) IBOutlet UILabel *movieDescInCell;
@property (weak, nonatomic) IBOutlet UILabel *startLabelInCell;

@end
