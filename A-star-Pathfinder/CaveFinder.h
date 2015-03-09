//
//  CaveFinder.h
//  A-star-Pathfinder
//
//  Created by Philip Fryklund on 2013-11-05.
//  Copyright (c) 2013 SDKGameMaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFunctions.h"
@class ViewController;

@interface CaveFinder : UIView

@property(nonatomic,strong)ViewController *vc;
@property(nonatomic,strong)NSMutableArray *pathArray, *anchorPointArray, *blockArray;

@end