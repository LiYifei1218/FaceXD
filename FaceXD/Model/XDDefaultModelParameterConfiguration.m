//
//  XDDefaultModelParameterConfiguration.m
//  FaceXD
//
//  Created by CmST0us on 2020/3/16.
//  Copyright © 2020 hakura. All rights reserved.
//

#import "XDDefaultModelParameterConfiguration.h"
#import "XDControlValueLinear.h"

@interface XDDefaultModelParameterConfiguration ()
@property (nonatomic, strong) XDControlValueLinear *eyeLinearX;
@property (nonatomic, strong) XDControlValueLinear *eyeLinearY;
@end

@implementation XDDefaultModelParameterConfiguration

- (instancetype)initWithModel:(LAppModel *)model {
    self = [super initWithModel:model];
    if (self) {
        _eyeLinearX = [[XDControlValueLinear alloc] initWithOutputMax:[self.model paramMaxValue:LAppParamEyeBallX].doubleValue
                                                            outputMin:[self.model paramMinValue:LAppParamEyeBallX].doubleValue inputMax:45 inputMin:-45];
        _eyeLinearY = [[XDControlValueLinear alloc] initWithOutputMax:[self.model paramMaxValue:LAppParamEyeBallY].doubleValue
                                                            outputMin:[self.model paramMinValue:LAppParamEyeBallY].doubleValue inputMax:45 inputMin:-45];
    }
    return self;
}

#pragma mark - Getter Setter
- (void)setWorldAlignment:(ARWorldAlignment)worldAlignment {
    if (_worldAlignment == worldAlignment) {
        return;
    }
    _worldAlignment = worldAlignment;
}

- (void)setOrientation:(UIInterfaceOrientation)orientation {
    if (_orientation == orientation) {
        return;
    }
    _orientation = orientation;
}

#pragma mark - Public
- (void)updateParameterWithFaceAnchor:(ARFaceAnchor *)anchor
                             faceNode:(SCNNode *)faceNode
                          leftEyeNode:(SCNNode *)leftEyeNode
                         rightEyeNode:(SCNNode *)rightEyeNode {
    if (self.worldAlignment == ARWorldAlignmentCamera) {
        self.parameter.headPitch = @(-(180 / M_PI) * faceNode.eulerAngles.x * 1.3);
        self.parameter.headYaw = @((180 / M_PI) * faceNode.eulerAngles.y);
        self.parameter.headRoll = @(-(180 / M_PI) * faceNode.eulerAngles.z + 90.0);
        switch (self.orientation) {
            case UIInterfaceOrientationLandscapeRight: {
                self.parameter.headRoll = @(self.parameter.headRoll.floatValue - 90);
            }
                break;
            case UIInterfaceOrientationLandscapeLeft: {
                CGFloat headRoll = (M_PI - ABS(faceNode.eulerAngles.z)) * (faceNode.eulerAngles.z > 0 ? -1 : 1);
                self.parameter.headRoll = @(-(180 / M_PI) * headRoll);
            }
                break;
            case UIInterfaceOrientationPortraitUpsideDown: {
                self.parameter.headRoll = @(self.parameter.headRoll.floatValue - 180);
            }
                break;
            default:
                break;
        }
    } else if (self.worldAlignment == ARWorldAlignmentGravity) {
        self.parameter.headPitch = @(-(180 / M_PI) * faceNode.eulerAngles.x * 1.3);
        self.parameter.headYaw = @((180 / M_PI) * faceNode.eulerAngles.y);
        self.parameter.headRoll = @(-(180 / M_PI) * faceNode.eulerAngles.z);
    }
    
    self.parameter.bodyAngleX = @(self.parameter.headYaw.floatValue / 4);
    self.parameter.bodyAngleY = @(self.parameter.headPitch.floatValue / 2);
    self.parameter.bodyAngleZ = @(self.parameter.headRoll.floatValue / 2);

    self.parameter.eyeLOpen = @(1 - anchor.blendShapes[ARBlendShapeLocationEyeBlinkLeft].floatValue * 1.3);
    self.parameter.eyeROpen = @(1 - anchor.blendShapes[ARBlendShapeLocationEyeBlinkRight].floatValue * 1.3);
    self.parameter.eyeX = @([self.eyeLinearX calc:(180 / M_PI) * leftEyeNode.eulerAngles.y]);
    self.parameter.eyeY = @(-[self.eyeLinearY calc:(180 / M_PI) * leftEyeNode.eulerAngles.x]);
    self.parameter.mouthOpenY = @(anchor.blendShapes[ARBlendShapeLocationJawOpen].floatValue * 1.8);
    
    CGFloat innerUp = anchor.blendShapes[ARBlendShapeLocationBrowInnerUp].floatValue;
    CGFloat outerUpL = anchor.blendShapes[ARBlendShapeLocationBrowOuterUpLeft].floatValue;
    CGFloat outerUpR = anchor.blendShapes[ARBlendShapeLocationBrowOuterUpRight].floatValue;
    CGFloat downL = anchor.blendShapes[ARBlendShapeLocationBrowDownLeft].floatValue;
    CGFloat downR = anchor.blendShapes[ARBlendShapeLocationBrowDownRight].floatValue;
    self.parameter.eyeBrowYL = @((innerUp + outerUpL) / 2);
    self.parameter.eyeBrowYR = @((innerUp + outerUpR) / 2);
    self.parameter.eyeBrowAngleL = @(17 * (innerUp - outerUpL) - downL - 2.5);
    self.parameter.eyeBrowAngleR = @(17 * (innerUp - outerUpR) - downR - 2.5);
    CGFloat mouthFunnel = anchor.blendShapes[ARBlendShapeLocationMouthFunnel].floatValue;
    CGFloat mouthLeft = anchor.blendShapes[ARBlendShapeLocationMouthFrownLeft].floatValue;
    CGFloat mouthRight = anchor.blendShapes[ARBlendShapeLocationMouthFrownRight].floatValue;
    CGFloat mouthSmileLeft = anchor.blendShapes[ARBlendShapeLocationMouthSmileLeft].floatValue;
    CGFloat mouthSmileRight = anchor.blendShapes[ARBlendShapeLocationMouthSmileRight].floatValue;
    CGFloat mouthForm = 0 - (mouthLeft - mouthSmileLeft + mouthRight - mouthSmileRight) / 2 * 8 - 1 / 3;
    if(mouthForm < 0){
        mouthForm = mouthForm - mouthFunnel;
    }
    self.parameter.mouthForm = @(mouthForm);
}


@end
