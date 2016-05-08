//
//  MoviePosterVC.m
//  SearchMovie
//
//  Created by Jeroen Dunselman on 06/05/16.
//  Copyright © 2016 Jeroen Dunselman. All rights reserved.
//

#import "MoviePosterVC.h"

@interface MoviePosterVC ()

@end

@implementation MoviePosterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.thePosterImageVw setImage:self.theImg];
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Back" style: UIBarButtonItemStylePlain
                                             target:self action:@selector(dismissMyView)];
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

@end
