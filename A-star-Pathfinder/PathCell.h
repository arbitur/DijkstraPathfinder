
/**
 *  PathCell.h
 *  A-star-Pathfinder
 *
 *  Created by Philip Fryklund on 2013-10-08.
 *  Copyright (c) 2013 SDKGameMaker. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "CFunctions.h"
@class ViewController;

/**
 *  A pathfinding cell that is a subclass of UIView
 *
 *  @version 1.0
 *  @author Philip Fryklund
 *  @copyright SDKGameMaker 2013
 *
 *  @param parent The parentcell to this cell
 *  @param superVC This cells UIViewController
 */
@interface PathCell : UIView

/// Parentcell
@property(nonatomic,strong)PathCell *parent;
/// Parent UIViewController
@property(nonatomic,strong)ViewController *superVC;

@property(nonatomic)char numberOfDirections;

@end