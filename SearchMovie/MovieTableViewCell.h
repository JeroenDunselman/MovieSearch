//
//  MovieTableViewCell.h
//  SearchMovie
//
//  Created by Jeroen Dunselman on 04/05/16.
//  Copyright © 2016 Jeroen Dunselman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theThumbnail;

@end
