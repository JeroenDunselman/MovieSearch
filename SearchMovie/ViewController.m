//
//  ViewController.m
//  SearchMovie
//
//  Created by Jeroen Dunselman on 04/05/16.
//  Copyright © 2016 Jeroen Dunselman. All rights reserved.
//

#import "AFNetworking.h"
#import "ViewController.h"
#import "MovieTableViewCell.h"
#import "MovieViewController.h"

@interface ViewController ()

@end

@implementation ViewController
NSMutableDictionary *posterLocations;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    posterLocations = [[NSMutableDictionary alloc] init];
    
    [self.movieTableView setDelegate:self];
    [self.movieTableView setDataSource:self];
//    [self.movieTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MovieCell"];
        [self.movieTableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    [self.movieTableView setHidden:true];
    [self.theSearchBar setPrompt:@"Search Movie Title"];
    [self.theSearchBar setDelegate:self];
    [self.theSearchBar setText:@"Ice"];
    
    [self.activityVw setHidden:true];
}

- (void)searchIMDB{
    [self.activityVw setHidden:false];
    [self.activityVw startAnimating];
    
    //** Create imdb urlstring from theSearchBar
    NSString *strTrimmed = [self.theSearchBar.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    NSString *urlAsString = [NSString stringWithFormat:@"https://www.omdbapi.com/?s=%@&y=&plot=short&r=json&type=movie", strTrimmed];
    urlAsString =  [urlAsString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //** Request search results
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:urlAsString]; //@"http://httpbin.org/get"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            self.movieDataFound = [responseObject objectForKey:@"Search"];
            if ([self.movieDataFound count] > 0){
                [self getMoviePosters];
                [self.movieTableView setHidden:false];
            } else {
                [self.movieTableView setHidden:true];
            }
            [self.movieTableView reloadData];
            [self.activityVw stopAnimating];
            [self.activityVw setHidden:true];
        }
    }];
    [dataTask resume];
}

-(void) getMoviePosters {
    
    for (NSDictionary *aMoviePoster in self.movieDataFound) {
        
        if ([posterLocations objectForKey:[aMoviePoster
                                           objectForKey:@"imdbID"]]) {
            //** we already tried to download this poster during this appsession
            break;
        }
        
        if ([[aMoviePoster objectForKey:@"Poster"] isEqualToString:@"N/A"]) {
            //** Register imdbID key
            NSDictionary *newMovie =
            @{[aMoviePoster objectForKey:@"imdbID"]:@""};
            [posterLocations addEntriesFromDictionary:newMovie];
            break;
        }
        
        //** Get path
        NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [documentDir stringByAppendingPathComponent:[aMoviePoster objectForKey:@"imdbID"]];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if (!fileExists) {
            
            //** Register imdbID key
            NSDictionary *newMovie =
            @{[aMoviePoster objectForKey:@"imdbID"]:@""};
            [posterLocations addEntriesFromDictionary:newMovie];
            
            //** Make request
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[aMoviePoster objectForKey:@"Poster"]]];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (error) {
                    NSLog(@"Download Error:%@",error.description);
                }
                if (data) {
                    //** Save img to disk
                    [data writeToFile:filePath atomically:YES];
                    UIImage *imgPoster = [[UIImage alloc] initWithContentsOfFile:filePath];
                    
                    if (imgPoster) {
                        //** Save img to dictionary
                        [posterLocations setObject:imgPoster forKey:[aMoviePoster objectForKey:@"imdbID"]];
                        [self.movieTableView reloadData];
                    }
                }
            }];
         
        } else {
            //** the poster was saved to disk in previous session
            UIImage *imgPoster = [[UIImage alloc] initWithContentsOfFile:filePath];
            //** add it to the dictionary
            if (imgPoster) {
                [posterLocations setObject:imgPoster forKey:[aMoviePoster objectForKey:@"imdbID"]];
            }
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
//        self.movieDataFound = [[NSArray alloc] init];
        [self.movieTableView setHidden:true];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    [self searchIMDB];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.activityVw setHidden:false];
    [self.activityVw startAnimating];
    
    //** Search imdb by movie ID
    NSString *movieID = [[self.movieDataFound objectAtIndex:indexPath.row] objectForKey:@"imdbID"];
    NSString *urlAsString = [NSString stringWithFormat:@"http://www.omdbapi.com/?i=%@&plot=long&r=json", movieID];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary *theDct = responseObject;
            
            //** Show movie view in navcontroller
            MovieViewController *movieVC = [[MovieViewController alloc] init];
            movieVC.theMovie = theDct;
            
            if ([[posterLocations objectForKey:[theDct objectForKey:@"imdbID" ]
                  ] isKindOfClass:[UIImage class]]) {
                //** Set img if available
                movieVC.theMoviePoster = [posterLocations objectForKey:[theDct objectForKey:@"imdbID" ]];
            }
            
            UINavigationController *movieViewNavController = [[UINavigationController alloc] initWithRootViewController:movieVC];
            [self.view.window.rootViewController presentViewController:movieViewNavController animated:YES completion:nil];
        }
        
        [self.activityVw setHidden:true];
        [self.activityVw stopAnimating];
    }];
    [dataTask resume];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MovieTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" ];
//    NSDictionary *theMovie = [self.movieDataFound objectAtIndex:indexPath.row];
//    [myCell.textLabel setText : [NSString stringWithFormat:@"%@ (%@)",
//                                [theMovie objectForKey:@"Title" ],
//                                [theMovie objectForKey:@"Year" ]]];
//    
//    if ([[posterLocations objectForKey:[theMovie objectForKey:@"imdbID" ]
//          ] isKindOfClass:[UIImage class]]
//        ) {
//        [myCell.imageView setImage:[posterLocations objectForKey:[theMovie objectForKey:@"imdbID" ]]];
//    } else {
//        [myCell.imageView setImage:nil];
//    }
//    return myCell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" ];
    NSDictionary *theMovie = [self.movieDataFound objectAtIndex:indexPath.row];
    [myCell.theLabel setText : [NSString stringWithFormat:@"%@ (%@)",
                                [theMovie objectForKey:@"Title" ],
                                [theMovie objectForKey:@"Year" ]]];
    
    if ([[posterLocations objectForKey:[theMovie objectForKey:@"imdbID" ]
          ] isKindOfClass:[UIImage class]]
        ) {
        [myCell.theThumbnail setImage:[posterLocations objectForKey:[theMovie objectForKey:@"imdbID" ]]];
    } else {
        [myCell.theThumbnail setImage:nil];
    }
    return myCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movieDataFound count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
