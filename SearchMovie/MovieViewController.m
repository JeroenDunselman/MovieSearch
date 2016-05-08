//
//  MovieViewController.m
//  SearchMovie
//
//  Created by Jeroen Dunselman on 04/05/16.
//  Copyright © 2016 Jeroen Dunselman. All rights reserved.
//

#import "MovieViewController.h"
#import "MoviePosterVC.h"
@interface MovieViewController ()

@end

@implementation MovieViewController
UITableViewController *detailsTVC;
NSMutableArray *detailListKeyLabels;
NSMutableArray *detailListVals;
MoviePosterVC *posterVC;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Back" style: UIBarButtonItemStylePlain
                                             target:self action:@selector(dismissMyView)];
    
    [detailsTVC.tableView registerClass:[UITableViewCell class]
                 forCellReuseIdentifier:@"detailCell"];
    detailsTVC.tableView.allowsSelection = NO;
    [self showInfo];
}

-(void) viewDidAppear:(BOOL)animated{
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([detailListVals count] - 1) inSection:0];
    [detailsTVC.tableView  scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void) showInfo {
    
    [self getDetailList];
    [self showDetailsTV];
    
    [self.theMovieTitleAndYear setText:
        [NSString stringWithFormat:@"%@ (%@, %@)",
        [self.theMovie objectForKey:@"Title" ],
        [self.theMovie objectForKey:@"Country" ],
        [self.theMovie objectForKey:@"Year" ]]];
    
    if (self.theMoviePoster) {
        [self.theMoviePosterVw setImage:self.theMoviePoster];
    }
    
    if (![[self.theMovie objectForKey:@"Plot" ] isEqualToString:@"N/A"]) {
        [self.thePlotTextView setText:[self.theMovie objectForKey:@"Plot" ]];
    } else {
        [self.thePlotTextView setText:@""];
    }
}

- (void) getDetailList {
    detailListKeyLabels = [[NSMutableArray alloc] init];
    detailListVals = [[NSMutableArray alloc] init];

    NSArray *detailKeys = [self.theMovie allKeys];;
    NSArray *detailValues= [self.theMovie allValues];
    
    //determine itemlist
    NSArray *theDetails = [NSArray arrayWithObjects:
                           @"Genre", @"imdbRating", @"Runtime", @"Rated", @"Metascore", @"Director", @"Actors", @"Writer", @"imdbVotes", @"Language", @"Released", nil];
    
    for (NSString *detailItem in theDetails) {
        NSString *strVal = [detailValues objectAtIndex:[detailKeys indexOfObject:detailItem]];
        if (![strVal isEqualToString:@"N/A"]) {
            [detailListVals addObject:strVal];
            [detailListKeyLabels addObject:detailItem];
        }
    }
}

- (void) showDetailsTV
{
    detailsTVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    detailsTVC.view.frame = self.vwDetails.bounds;
    
    [detailsTVC.tableView setDelegate:self];
    [detailsTVC.tableView setDataSource:self];

    [self addChildViewController:detailsTVC];
    [self.vwDetails addSubview:detailsTVC.view];
    [detailsTVC didMoveToParentViewController:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myID"];
    
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:13];
    cell.detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:8];
    
    [cell setBackgroundColor:[UIColor blackColor]];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    [cell.textLabel setText:[detailListVals objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setText:[detailListKeyLabels objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [detailListKeyLabels count];
}

- (void)dismissMyView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnShowPoster:(id)sender {
    [self showPoster];
}

- (void) showPoster{
    if (self.theMoviePoster) {
        posterVC = [[MoviePosterVC alloc] init];
        [posterVC setTheImg:self.theMoviePoster];
        UINavigationController *posterNavController = [[UINavigationController alloc] initWithRootViewController:posterVC];
        [self presentViewController:posterNavController animated:NO completion:nil];
    }
}

@end
