
/**
 *  ViewController.m
 *  A-star-Pathfinder
 *
 *  Created by Philip Fryklund on 2013-10-08.
 *  Copyright (c) 2013 SDKGameMaker. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "CFunctions.h"
#import "PathCell.h"
#import "CaveFinder.h"


@interface ViewController : UIViewController {
    /// A UISegmentedControl to switch the action when touching the screen
    IBOutlet UISegmentedControl *optionSegCtrl;
    /// A UISegmentController which sets the number of directions the cells will be checking, either 4 or 8
    IBOutlet UISegmentedControl *directionsSegCtrl;
    
    /// The UIImageView that is getting moved when a path is found
    UIImageView *walker;
    
    /// A UIView to let the user know where the startpoint is
    UIView *startView;
    /// A UIView to let the user know where the endpoint is
    UIView *endView;
    
    /// An NSTimer that is going to call a method that removes the PathCell after a duration
    NSTimer *resetTimer;
    
    /// The starting cell
    PathCell *cell;
}

/// An array that will contain all the PathCell's
@property(nonatomic,strong)NSMutableArray *pathArray;
/// An array that will contain all the walls
@property(nonatomic,strong)NSMutableArray *wallArray;
/// The starting point
@property(nonatomic)CGPoint startPoint;
/// The destination point
@property(nonatomic)CGPoint endPoint;
/// A boolean that is false while the cells are finding the path and true when its found
@property(nonatomic)BOOL pathFound;

/**
 *  Animates a UIView to a point in an NSArray
 *
 *  @param walkArray An NSArray of CGPoints
 *  @param index The index of the CGpoint to move the UIView *walker to
 */
-(void)walk:(NSMutableArray *)walkArray index:(int)index;
/**
 *  This method gets called when a PathCell is added on the point of endPoint
 *
 *  @param array An NSArray of the PathCells that have found the path
 */
-(void)done:(NSMutableArray *)array;
/// A method that is getting called everytime a new cell is created and creates an NSTimer to call a method to remove the PathCells. If it is getting called under that duration the NSTimer is reseted
-(void)timeToReset;











@end