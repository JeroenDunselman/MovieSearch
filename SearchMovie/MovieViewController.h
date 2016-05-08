//
//  MovieViewController.h
//  SearchMovie
//
//  Created by Jeroen Dunselman on 04/05/16.
//  Copyright © 2016 Jeroen Dunselman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *vwDetails;
- (IBAction)btnShowPoster:(id)sender;
@property (strong) NSDictionary *theMovie;
@property (strong) UIImage *theMoviePoster;
@property (weak, nonatomic) IBOutlet UITextView *theMovieTitleAndYear;
@property (weak, nonatomic) IBOutlet UIImageView *theMoviePosterVw;
@property (weak, nonatomic) IBOutlet UITextView *thePlotTextView;
@end
