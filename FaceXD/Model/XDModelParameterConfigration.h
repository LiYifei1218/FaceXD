//
//  XDModelParameterConfigration.h
//  FaceXD
//
//  Created by CmST0us on 2020/3/16.
//  Copyright © 2020 hakura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>
#import "XDModelParameter.h"
#import "LAppModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDModelParameterConfigration : NSObject
@property (nonatomic, readonly) XDModelParameter *parameter;
@property (nonatomic, weak) LAppModel *model;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithModel:(LAppModel *)model;

- (void)updateParameterWithFaceAnchor:(ARFaceAnchor *)anchor
                             faceNode:(SCNNode *)faceNode
                          leftEyeNode:(SCNNode *)leftEyeNode
                         rightEyeNode:(SCNNode *)rightEyeNode;

- (void)reset;
- (void)commit;

- (NSDictionary<NSString *, NSString *> *)parameterKeyMap;
@end

NS_ASSUME_NONNULL_END
