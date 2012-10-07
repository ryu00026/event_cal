//
//  DetailViewController.h
//  event_cal
//
//  Created by Ryuichi on 12/10/07.
//  Copyright (c) 2012年 Ryuichi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
