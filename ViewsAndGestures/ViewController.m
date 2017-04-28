//
//  ViewController.m
//  ViewsAndGestures
//
//  Created by Mocca Yang on 2017/4/28.
//  Copyright © 2017年 Appmocca. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end

@implementation ViewController
- (IBAction)swipeCard:(id)sender {
    self.playingCardView.faceUp = !self.playingCardView.faceUp;
    [self changeCard];
}

-(void)changeCard {
    if(self.playingCardView.faceUp){
        if(self.playingCardView.rank < 13){
            self.playingCardView.rank++;
        }else{
            self.playingCardView.rank = 1;
        }
    }
    [self.playingCardView randomSuit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.playingCardView.faceUp = YES;
    self.playingCardView.rank = 1;
    self.playingCardView.suit = @"♦";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
