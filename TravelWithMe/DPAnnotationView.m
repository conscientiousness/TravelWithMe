#import "DPAnnotationView.h"

NSString *const DPAnnotationViewDidFinishDrag = @"DPAnnotationViewDidFinishDrag";
NSString *const DPAnnotationViewKey = @"DPAnnotationView";

// Estimate a finger size
// This is the amount of pixels I consider
// that the finger will block when the user
// is dragging the pin.
// We will use this to lift the pin even higher during dragging

#define kFingerSize 20.0

@interface DPAnnotationView()
@property (nonatomic) CGPoint fingerPoint;
@end

@implementation DPAnnotationView
@synthesize dragState, fingerPoint, mapView;

- (void)setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated
{
    if(mapView){
        id<MKMapViewDelegate> mapDelegate = (id<MKMapViewDelegate>)mapView.delegate;
        [mapDelegate mapView:mapView annotationView:self didChangeDragState:newDragState fromOldState:dragState];
    }
    
    // Calculate how much to lift the pin, so that it's over the finger, not under.
    CGFloat liftValue = -(fingerPoint.y - self.frame.size.height - kFingerSize);
    
    if (newDragState == MKAnnotationViewDragStateStarting)
    {
        CGPoint endPoint = CGPointMake(self.center.x,self.center.y-liftValue);
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.center = endPoint;
                         }
                         completion:^(BOOL finished){
                             dragState = MKAnnotationViewDragStateDragging;
                         }];
        
    }
    else if (newDragState == MKAnnotationViewDragStateEnding)
    {
        CGAffineTransform theTransform = CGAffineTransformMakeTranslation(0, -liftValue);
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.transform = theTransform;
                         }
                         completion:^(BOOL finished){
                             CGAffineTransform theTransform2 = CGAffineTransformMakeTranslation(0, 0);
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  self.transform = theTransform2;
                                              }
                                              completion:^(BOOL finished){
                                                  dragState = MKAnnotationViewDragStateNone;
                                                  if(!mapView)
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:DPAnnotationViewDidFinishDrag object:nil userInfo:[NSDictionary dictionaryWithObject:self.annotation forKey:DPAnnotationViewKey]];
                                                  // Added this to select the annotation after dragging.
                                                  // This is the behavior for MKPinAnnotationView
                                                  if (mapView)
                                                      [mapView selectAnnotation:self.annotation animated:YES];
                                              }];
                         }];
    }
    else if (newDragState == MKAnnotationViewDragStateCanceling)
    {
        // drop the pin and set the state to none
        CGPoint endPoint = CGPointMake(self.center.x,self.center.y+liftValue);
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.center = endPoint;
                         }
                         completion:^(BOOL finished){
                             dragState = MKAnnotationViewDragStateNone;
                             // Added this to select the annotation after canceling.
                             // This is the behavior for MKPinAnnotationView
                             if (mapView)
                                 [mapView selectAnnotation:self.annotation animated:YES];
                         }];
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    // When the user touches the view, we need his point so we can calculate by how
    // much we should life the annotation, this is so that we don't hide any part of
    // the pin when the finger is down.
    
    // Fixed a bug here.  If a touch happened while the annotation view was being dragged
    // then it screwed up the animation when the annotation was dropped.
    if (dragState == MKAnnotationViewDragStateNone)
    {
        fingerPoint = point;
    }
    return [super hitTest:point withEvent:event];
}

@end