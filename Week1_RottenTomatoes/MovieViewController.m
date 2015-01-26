//
//  MovieViewController.m
//  Week1_RottenTomatoes
//
//  Created by Qiyuan Liu on 1/25/15.
//  Copyright (c) 2015 liuqiyuan.com. All rights reserved.
//

#import "MovieViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieMetaDataCell.h"

static NSString *METADATA_CELL_IDENTIFIER = @"MovieMetaDataCell";

@interface MovieViewController ()

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Load the image from thumnail to original size
    NSString *imageUrl = self.movieDict[@"imageUrl"];
    NSString *originalImageUrl = self.movieDict[@"originalImageUrl"];
    [self.movieDetailImageView setImageWithURL:[[NSURL alloc]initWithString:imageUrl]];
    [self.movieDetailImageView setImageWithURL:[[NSURL alloc]initWithString:originalImageUrl]];
    
    // Config datasource and delegate
    self.movieDetailTableView.dataSource = self;
    self.movieDetailTableView.delegate = self;
    
    // add header view to set spaces
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    self.movieDetailTableView.tableHeaderView = headerView;

    // Register the cell
    UINib *movieMetaDataCellNib = [UINib nibWithNibName:@"MovieMetaDataCell" bundle:nil];
    [self.movieDetailTableView registerNib:movieMetaDataCellNib forCellReuseIdentifier:METADATA_CELL_IDENTIFIER];
    
    // Settings for the table view
    [self.movieDetailTableView setRowHeight:200];
    [self.movieDetailTableView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    [self.movieDetailTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieMetaDataCell *cell = [tableView dequeueReusableCellWithIdentifier:METADATA_CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [[MovieMetaDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:METADATA_CELL_IDENTIFIER];
    }
    NSString *movieTitle = self.movieDict[@"title"];
    NSString *movieDesc = self.movieDict[@"desc"];
    NSString *criticsScore = self.movieDict[@"criticsScore"];
    NSString *audienceScore = self.movieDict[@"audienceScore"];
    
    cell.titleLable.text = movieTitle;
    cell.scoreLable.text = [[NSString alloc] initWithFormat:@"Critics Score: %@, Audience Score: %@", criticsScore, audienceScore];
    cell.descLable.text = movieDesc;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
