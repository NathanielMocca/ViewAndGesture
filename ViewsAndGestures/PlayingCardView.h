//
//  PlayingCardView.h
//  ViewsAndGestures
//
//  Created by Mocca Yang on 2017/4/28.
//  Copyright © 2017年 Appmocca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic)BOOL faceUp;
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;


@end
