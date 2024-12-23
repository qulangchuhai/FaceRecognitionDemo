#ifndef PH_LIVENESS_ANDROID_GLOBAL_LISTENER_H
#define PH_LIVENESS_ANDROID_GLOBAL_LISTENER_H

#include <iostream>

#include "yoloface.h"

using namespace::std;

struct BoundingBox {
    float left, top, right, bottom;
};

struct FaceDetectCppMaskPoint {
    float centerX;
    float centerY;
    float radius;
};

struct FaceResult {
    Object face;
    BoundingBox face_area;
};

struct Face {
    std::vector<FaceResult> fs;
};

typedef void(^DetectDrawPointsCallback)(Face face);
typedef void(^DetectClearPointsCallBack)();

class global_listener {

public:
    DetectDrawPointsCallback drawPointsCallBack;
    DetectClearPointsCallBack clearPointsCallBack;
    
public:
    global_listener();
    ~global_listener();
    
    void onDrawPoint(Face face);
    void onClearPoints();
    
public:
    void bindDrawPointsCallback(DetectDrawPointsCallback callback);
    void bindClearPointsCallBack(DetectClearPointsCallBack callback);
};

void GlobalListenerWillRelease();

#endif //PH_LIVENESS_ANDROID_GLOBAL_LISTENER_H
