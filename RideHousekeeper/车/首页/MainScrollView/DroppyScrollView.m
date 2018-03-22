//
//  DroppyScrollView.m
//  DroppyScrollView
//
//  Created by Cem Olcay on 16/10/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import "DroppyScrollView.h"
#import "CustomBike.h"


#define SpringDamping   0.5
#define SpringVelocity  0.1
#define Duration        0.5

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))


#pragma mark - DroppyView

@implementation UIView (Droppy)


#pragma mark Getters

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)w {
    return self.frame.size.width;
}

- (CGFloat)h {
    return self.frame.size.height;
}


#pragma mark Setters

- (void)setX:(CGFloat)x {
    [self setFrame:(CGRect){{x, [self y]}, {[self w], [self h]}}];
}

- (void)setY:(CGFloat)y {
    [self setFrame:(CGRect){{[self x], y}, {[self w], [self h]}}];
}

- (void)setW:(CGFloat)w {
    [self setFrame:(CGRect){{[self x], [self y]}, {w, [self h]}}];
}

- (void)setH:(CGFloat)h {
    [self setFrame:(CGRect){{[self x], [self y]}, {[self w], h}}];
}

- (void)setRotationY:(CGFloat)y {
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, DEGREES_TO_RADIANS(y), 1.0f, 0.0f, 0.0f);
    
    self.layer.transform = rotationAndPerspectiveTransform;
}


#pragma mark Custom Animations

- (void)moveYBy:(CGFloat)yAmount duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate {
    [self animate:^{
        [self setY:[self y] + yAmount];
    } duration:duration
     complication:complate];
}

- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate {
    [self setRotationY:from];
    [self animate:^{
        [self setRotationY:to];
    } duration:duration
     complication:complate];
}

- (void)alphaFrom:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration complication:(void(^)(BOOL finished))complate {
    [self setAlpha:from];
    [UIView animateWithDuration:duration animations:^{
        [self setAlpha:to];
    } completion:complate];
}


#pragma mark Makro Duration Animations

- (void)moveXBy:(CGFloat)xAmount {
    [self setX:[self x] + xAmount];
//    [self animate:^{
//        [self setX:[self x] + xAmount];
//    }];
}

- (void)moveYBy:(CGFloat)yAmount {
    [self animate:^{
        [self setY:[self y] + yAmount];
    }];
}

- (void)rotateYFrom:(CGFloat)from to:(CGFloat)to {
    [self setRotationY:from];
    [self animate:^{
        [self setRotationY:to];
    }];
}

- (void)alphaFrom:(CGFloat)from to:(CGFloat)to {
    [self setAlpha:from];
    [UIView animateWithDuration:Duration animations:^{
        [self setAlpha:to];
    }];
}


#pragma mark Animation Utils

- (void)animate:(void(^)())animations {
    [UIView animateWithDuration:Duration delay:0 usingSpringWithDamping:SpringDamping initialSpringVelocity:SpringVelocity options:kNilOptions animations:animations completion:nil];
}

- (void)animate:(void(^)())animations duration:(NSTimeInterval)duration complication:(void(^)(BOOL))complate {
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:SpringDamping initialSpringVelocity:SpringVelocity options:kNilOptions animations:animations completion:complate];
}

@end


#pragma mark - DroppyScrollView

@interface DroppyScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *addingQueue;
@property (nonatomic, strong) NSMutableArray *removingQueue;

@property (nonatomic, assign, getter=isAdding) BOOL adding;
@property (nonatomic, assign, getter=isRemoving) BOOL removing;

@end

@implementation DroppyScrollView


#pragma mark  Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.items = [[NSMutableArray alloc] init];
        self.addingQueue = [[NSMutableArray alloc] init];
        self.removingQueue = [[NSMutableArray alloc] init];
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = FALSE;
        self.showsHorizontalScrollIndicator = FALSE;
        self.removing = NO;
        self.adding = NO;
        self.bounces = NO;
        self.itemPadding = 0;
        self.defaultDropLocation = DroppyScrollViewDefaultDropLocationBottom;
    }
    return self;
}


#pragma mark  Droppy Functions

- (void)dropSubview:(UIView *)view {
    if (self.defaultDropLocation == DroppyScrollViewDefaultDropLocationTop) {
        [self dropSubview:view atIndex:[self top]];
    } else if (self.defaultDropLocation == DroppyScrollViewDefaultDropLocationBottom) {
        [self dropSubview:view atIndex:[self bottom]];
    }
}

- (void)dropSubview:(UIView *)view atIndex:(NSInteger)index {
    
    if (self.isAdding || self.isRemoving) {
        [self sendViewToAddingQueue:view index:index];
        return;
    }
    
    [self setAdding:YES];
    [self sendViewToAddingQueue:view index:index];
    [self addSubview:view];
    
    //index fix
    if (index < [self top])
        index = [self top];
    else if (index > [self bottom])
        index = [self bottom];
    
    //shift down views under index
    for (NSInteger i = index; i < [self bottom]; i++) {
        UIView *item = (UIView *)[self.items objectAtIndex:i];
        CGFloat shiftAmount = [view w] + self.itemPadding;
        
        //[item moveYBy:shiftAmount];
        [item moveXBy:shiftAmount];
    }
    
    //add view animations
    //[view setY:[self yForIndex:index]];
    [view setX:[self xForIndex:index]];
    [self.addingQueue removeObjectAtIndex:0];
    [self.items insertObject:view atIndex:index];
    
    [self updateContentSize];
    [self setAdding:NO];
    //[view setRotationY:45];
//    [view setAlpha:0.5];
//    [view animate:^{
//        [view setRotationY:0];
//        [view setAlpha:1];
//    } duration:Duration complication:^(BOOL finished) {
//        [self.addingQueue removeObjectAtIndex:0];
//        [self.items insertObject:view atIndex:index];
//
//        [self updateContentSize];
//        [self setAdding:NO];
//    }];
}


- (void)removeSubviewAtIndex:(NSInteger)index {
    if (index < 0 || index >= [self bottom] || [self bottom] == 0 || self.isRemoving || self.isAdding) {
        [self sendViewAtIndexToRemovingQueue:index];
        return;
    }
    
    [self setRemoving:YES];
    [self sendViewAtIndexToRemovingQueue:index];
    UIView *removingView = (UIView *)[self.items objectAtIndex:index];
    
    //shift up views under index
    for (NSInteger i = index+1; i < [self bottom]; i++) {
        UIView *item = (UIView *)[self.items objectAtIndex:i];
        CGFloat shiftAmount = [removingView w] + self.itemPadding;
        
        [item moveXBy:shiftAmount*-1];
    }
    [removingView removeFromSuperview];
    [self.removingQueue removeObjectAtIndex:0];
    //
    [self setContentOffset:CGPointMake(ScreenWidth * ([self bottom]- 1), 0) animated:NO];
    [self.items removeObjectAtIndex:index];
    [self updateContentSize];
    [self setRemoving:NO];
    //remove view
//    [removingView animate:^{
//        //[removingView setAlpha:0];
//    } duration:Duration complication:^(BOOL finished) {
//
//        if (finished) {
//            //droppy management
//            [removingView removeFromSuperview];
//            [self.removingQueue removeObjectAtIndex:0];
//            //[self setContentOffset:CGPointMake(ScreenWidth * ([self bottom]- 1), 0) animated:NO];
//            [self.items removeObjectAtIndex:index];
//            [self updateContentSize];
//            [self setRemoving:NO];
//
//        }
//    }];
}

- (void)updateContentSize {
    CGFloat width = self.itemPadding;
    for (UIView *view in self.items) {
        width += [view w] + self.itemPadding;
    }
    [self setContentSize:CGSizeMake(width, [self h])];
    //[self setContentOffset:CGPointMake(ScreenWidth * ([self bottom]- 1), 0) animated:YES];
    
}


#pragma mark Queues

- (void)sendViewToAddingQueue:(UIView *)view index:(NSInteger)index {
    NSDictionary *obj = @{@"view":view, @"index":@(index)};
    if ([self.addingQueue containsObject:obj]) {
        return;
    } else {
        [self.addingQueue addObject:obj];
    }
}

- (void)sendViewAtIndexToRemovingQueue:(NSInteger)index {
    if ([self.removingQueue containsObject:@(index)]) {
        return;
    } else {
        [self.removingQueue addObject:@(index)];
    }
}


#pragma mark Properties

- (void)setAdding:(BOOL)adding {
    _adding = adding;
    
    if (!adding) {
        if (self.addingQueue.count > 0){
            NSDictionary *queuedObject = [self.addingQueue firstObject];
            [self dropSubview:queuedObject[@"view"] atIndex:[queuedObject[@"index"] integerValue]];
        }
    }
}

- (void)setRemoving:(BOOL)removing {
    _removing = removing;
    
    if (!removing) {
        if (self.removingQueue.count > 0) {
            NSInteger queuedObject = [[self.removingQueue firstObject] integerValue];
            [self removeSubviewAtIndex:queuedObject];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}
//开始拖拽的时候停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
//结束拖拽的时候开始定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //[self startTimer];
}
//结束拖拽的时候更新image内容
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width-scrollView.bounds.size.width) {
        return;
    }
    NSInteger index = scrollView.contentOffset.x/ScreenWidth;
    
    if (self.selectIndex == index) {
        return;
    }
    self.selectIndex = index;
    
    if (self.scrollViewIndex) {
        self.scrollViewIndex(index);
    }
}
//scroll滚动动画结束的时候更新image内容
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width-scrollView.bounds.size.width) {
        return;
    }
    
    NSInteger index = scrollView.contentOffset.x/ScreenWidth;
    
    if (self.selectIndex == index) {
        return;
    }
    self.selectIndex = index;
    if (self.scrollViewIndex) {
        self.scrollViewIndex(index);
    }
}


#pragma mark  Utils

- (NSInteger)top {
    return 0;
}

- (NSInteger)bottom {
    return self.items.count;
}

- (NSInteger)randomIndex {
    if ([self bottom] == 0)
        return 0;
    else return [self bottom];
}


- (CGFloat)yForIndex:(NSInteger)index {
    CGFloat y = self.itemPadding;
    for (NSInteger i = 0; i < index; i++) {
        y += [(UIView *)[self.items objectAtIndex:i] h] + self.itemPadding;
    }
    return y;
}

- (CGFloat)xForIndex:(NSInteger)index {
    CGFloat x = self.itemPadding;
    for (NSInteger i = 0; i < index; i++) {
        x += [(UIView *)[self.items objectAtIndex:i] w] + self.itemPadding;
    }
    return x;
}

#pragma mark 手势代理方法 ，判断触摸的是地图还是外层的view

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //判断如果是百度地图的view 既可以实现手势拖动 scrollview 的滚动关闭
    
    //CustomBike *cusbike = [self.items objectAtIndex:self.Index];

    if ([NSStringFromClass([touch.view class])isEqual:@"TapDetectingView"]) {
        return NO;
    }
    
//    if ([touch.view isDescendantOfView:cusbike.vehiclePositioningMapView.mapView]) {
//        return NO;
//    }
    return YES;
    
}

//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
    return NO;
    
}


- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
            if (point.x > 0 && location.x < 50) {
                return YES;
                }
            }
        }
            return NO;
}
                
                
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
    
}




@end
