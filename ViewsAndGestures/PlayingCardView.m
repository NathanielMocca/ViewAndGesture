//
//  PlayingCardView.m
//  ViewsAndGestures
//
//  Created by Mocca Yang on 2017/4/28.
//  Copyright © 2017年 Appmocca. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView


-(void) setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    //表示需要重畫,不可直接呼叫drawRect
    [self setNeedsDisplay];
}

-(void) setRank:(NSUInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

-(void) setSuit:(NSString *)suit {
    _suit = suit;
    [self setNeedsDisplay];
}
#pragma mark - parameters for better rounded

#define CORNER_FONT_STANDARD_HEIGHT 188.0
#define CORNER_RADIUS 12.0

-(CGFloat) cornerScaleFactor {
    //拉出大小 與 原本自定大小 之倍數(scale)
    return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

-(CGFloat) cornerRadius {
    return CORNER_RADIUS * [self cornerScaleFactor];
}

-(CGFloat) cornerOffset {
    //padding
    return [self cornerRadius] /3.0;
}

#pragma mark - draw Roundedbackimage
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *RoundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]] ;
    
    [RoundedRect addClip]; //mask(遮罩)
    
    [[UIColor whiteColor] setFill]; //設定填入顏色
    [[UIColor blackColor] setStroke]; //設定畫框顏色
    
    [RoundedRect fill]; // 把設定交給bezier path
    [RoundedRect stroke];
    
    //判別正反面
    if(self.faceUp){
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@" ,
                                                  [self rankAsString], self.suit]];
        if(faceImage){
            CGRect imageRect = CGRectInset( self.bounds, self.bounds.size.width*0.1 , self.bounds.size.height*0.1);
            [faceImage drawInRect:imageRect];
        }else{
            [self drawPips];
        }
        [self DrawCorners];
    }else{
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

-(NSString *)rankAsString {
    return @[@"?",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
    //Array[index]
}

-(void) setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    [self setup];
    return self;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    //initialize UIView
    [self setup];
}

#pragma mark - draw corner font

-(void) DrawCorners {
    NSMutableParagraphStyle *paraGraphStyle = [[NSMutableParagraphStyle alloc] init];
    paraGraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerfont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerfont = [cornerfont fontWithSize:cornerfont.pointSize * [self cornerScaleFactor]];
    
    NSString *cardContent = [NSString stringWithFormat:@"%@\n%@", [self rankAsString] , self.suit];
    
    NSAttributedString *cornerText =  [[NSAttributedString alloc] initWithString:cardContent
                                                                      attributes:@{NSFontAttributeName: cornerfont,
                                                                                   NSParagraphStyleAttributeName: paraGraphStyle}];
    CGRect TextBound; //裝cornerfont
    TextBound.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    TextBound.size = [cornerText size];
    [cornerText drawInRect: TextBound];
    //顛倒畫布
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context); //存取現在畫布設定(還沒顛倒畫布)
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height); //把origin變到最右下角開始
    CGContextRotateCTM(context, M_PI);//旋轉2拍
    [cornerText drawInRect:TextBound];
    CGContextRestoreGState(context);//之後再畫的就不是顛倒的

}

#pragma mark - Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
    if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank != 7)];
    }
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

#define PIP_FONT_SCALE_FACTOR 0.012

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    if (upsideDown){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
        CGContextRotateCTM(context, M_PI);
    }
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown){
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}


@end
