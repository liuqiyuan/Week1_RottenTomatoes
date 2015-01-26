//
//  MoviesViewController.m
//  Week1_RottenTomatoes
//
//  Created by Qiyuan Liu on 1/25/15.
//  Copyright (c) 2015 liuqiyuan.com. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieViewController.h"
#import "SVProgressHUD.h"
#import "RKDropdownAlert.h"

static NSString *TITLE = @"Movies";
static NSString *CELL_IDENTIFIER = @"movieTableViewCell";

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (nonatomic, strong) UIRefreshControl *refreshController;
@property (weak, nonatomic) IBOutlet UITabBar *movieTabBar;
@property (nonatomic) BOOL isDVD;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = TITLE;
    self.isDVD = YES;
    
    // Config datasource and delegate
    self.movieTableView.dataSource = self;
    self.movieTableView.delegate = self;
    self.movieTableView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.4].CGColor;
    self.movieTableView.layer.borderWidth = 1;
    
    // Register the cell
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil];
    [self.movieTableView registerNib:movieCellNib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    // Settings for the table view
    [self.movieTableView setRowHeight:100];
    [self.movieTableView setBackgroundColor:[UIColor blackColor]];
    
    // Fetch movies data from Rotten Tomatoes API
    [SVProgressHUD show];
    [SVProgressHUD showInfoWithStatus:@"Loading ..."];
    [self makeGetCall];
    
    // Set refresh controll
    self.refreshController = [[UIRefreshControl alloc]init];
    [self.refreshController addTarget:self action:@selector(makeGetCall) forControlEvents:UIControlEventValueChanged];
    [self.movieTableView insertSubview:self.refreshController atIndex:0];
    
    // Set tab bar
    self.movieTabBar.delegate = self;
    
    // Set search bar
    self.movieSearchBar.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    NSString *movieTitle = [self.searchArray[indexPath.row] valueForKey:@"title"];
    NSString *movieDesc = [self.searchArray[indexPath.row] valueForKey:@"synopsis"];
    id ratingObj = [[self.searchArray[indexPath.row] valueForKey:@"ratings"] valueForKey:@"audience_score"];
    NSString *score = [[NSString alloc] initWithFormat:@"%@", ratingObj];
    NSString *imageURL = [[self.searchArray[indexPath.row] valueForKey:@"posters"] valueForKey:@"thumbnail"];
    
    cell.movieTitleInCell.text = movieTitle;
    cell.movieDescInCell.text = movieDesc;
    cell.startLabelInCell.text = score;
    [cell.movieImageViewInCell setImageWithURL:[[NSURL alloc] initWithString:imageURL]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieViewController *detailVC = [[MovieViewController alloc] init];
    NSString *movieTitle = [self.searchArray[indexPath.row] valueForKey:@"title"];
    NSString *movieDesc = [self.searchArray[indexPath.row] valueForKey:@"synopsis"];
    id ratingObj = [[self.searchArray[indexPath.row] valueForKey:@"ratings"] valueForKey:@"audience_score"];
    NSString *score = [[NSString alloc] initWithFormat:@"%@", ratingObj];
    id ratingObjCritical = [[self.searchArray[indexPath.row] valueForKey:@"ratings"] valueForKey:@"critics_score"];
    NSString *critics_score = [[NSString alloc] initWithFormat:@"%@", ratingObjCritical];
    NSString *imageUrl = [[self.searchArray[indexPath.row] valueForKey:@"posters"] valueForKey:@"original"];
    NSString *originalImageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    NSDictionary *newDict = @{
                              @"imageUrl":imageUrl,
                              @"originalImageUrl":originalImageUrl,
                              @"title":movieTitle,
                              @"desc":movieDesc,
                              @"audienceScore":score,
                              @"criticsScore":critics_score
                              };
    [detailVC setMovieDict:newDict];
    [self.navigationController pushViewController:detailVC animated:YES];
}

// Tab Bar actions
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        [self setIsDVD:YES];
    } else {
        [self setIsDVD:NO];
    }
    [self makeGetCall];
}

// Search Bar actions
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.searchArray removeAllObjects];
    if ([searchText length] > 0) {
        for (id movie in self.moviesArray) {
            NSString *movieTitle = [movie valueForKey:@"title"];
            NSRange find = [movieTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (find.location != NSNotFound) {
                [self.searchArray addObject:movie];
            }
        }
    } else {
        [self.searchArray addObjectsFromArray:self.moviesArray];
    }
    [self.movieTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeGetCall {
    NSString *yourApiKey = @"ew5g6wrfp2ecb5f6td7h3k2b"; // Fill with the key you registered at http://developer.rottentomatoes.com
    NSString *rottenTomatoesURLString;
    if (self.isDVD) {
        rottenTomatoesURLString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=%@", yourApiKey];
    } else {
        rottenTomatoesURLString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apiKey=%@", yourApiKey];
    }
    NSURL *url = [NSURL URLWithString:rottenTomatoesURLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [RKDropdownAlert title:@"Network Error" message:@"Ops, failed to fetch data." backgroundColor:[UIColor blackColor] textColor:[UIColor redColor] time:5];
        } else {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.moviesArray = responseDictionary[@"movies"];
            self.searchArray = [[NSMutableArray alloc] initWithArray:self.moviesArray];
            [self.movieTableView reloadData];
            [self.refreshController endRefreshing];
            [SVProgressHUD dismiss];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
