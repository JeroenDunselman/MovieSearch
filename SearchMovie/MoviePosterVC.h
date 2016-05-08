//
//  MoviePosterVC.h
//  SearchMovie
//
//  Created by Jeroen Dunselman on 06/05/16.
//  Copyright © 2016 Jeroen Dunselman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviePosterVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *thePosterImageVw;
@property (strong) UIImage *theImg;
@end
