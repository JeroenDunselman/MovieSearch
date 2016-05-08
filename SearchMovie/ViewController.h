//
//  ViewController.h
//  SearchMovie
//
//  Created by Jeroen Dunselman on 04/05/16.
//  Copyright © 2016 Jeroen Dunselman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    NSMutableArray *contentList;
//    NSMutableArray *filteredContentList;
    BOOL isSearching;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityVw;
@property (weak, nonatomic) IBOutlet UISearchBar *theSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (nonatomic, strong) NSArray *movieDataFound;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;
@end

