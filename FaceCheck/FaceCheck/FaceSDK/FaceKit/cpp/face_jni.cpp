
#include "face_jni.h"

#include <string>
#include <vector>
#include <cstring>
#include <iostream>
#include <ncnn/ncnn/net.h>

using namespace std;

static YoloFace *g_yoloface;

bool detection_sdk_init_ok = false;

void _release();

global_listener *_listener = nullptr;

void SmartDetector_bindListen(global_listener *listener) {
    _listener = listener;
}

bool SmartDetector_loadModel(string faceModelPath) {
    if (detection_sdk_init_ok) {
        return true;
    }
    
    bool tRet = false;
    if (faceModelPath.size() == 0) {
        return tRet;
    }

    string tFaceModelDir = faceModelPath;
    string tLastChar = tFaceModelDir.substr(tFaceModelDir.length() - 1, 1);
    if ("\\" == tLastChar) {
        tFaceModelDir = tFaceModelDir.substr(0, tFaceModelDir.length() - 1) + "/";
    } else if (tLastChar != "/") {
        tFaceModelDir += "/";
    }
    
    printf("init, tFaceModelDir=%s", tFaceModelDir.c_str());

    int target_size = 640;
    float _mean_vals[3] = {127.f, 127.f, 127.f};
    float _norm_vals[3] = {1 / 255.f, 1 / 255.f, 1 / 255.f};
    
    g_yoloface = new YoloFace();
    
    int yoloface_result = g_yoloface->load(tFaceModelDir, target_size, _mean_vals, _norm_vals, false);
    
    detection_sdk_init_ok = yoloface_result >= 0;
    tRet = detection_sdk_init_ok;
    
    return tRet;
}

int SmartDetector_faceDetect(unsigned char *rgbData, int imageWidth, int imageHeight, FaceDetectCppMaskPoint point) {
    return SmartDetector_faceDetectV2(rgbData, imageWidth, imageHeight, point);
}

int SmartDetector_faceDetectV2(unsigned char *rgbData, int imageWidth, int imageHeight, FaceDetectCppMaskPoint point) {
    _listener->onClearPoints();
    
    int input_size = 640;  //face_jni.cpp -> 210––
    
    // letterbox pad to multiple of 32
    int w = imageWidth;
    int h = imageHeight;
    float scale = 1.f;
    if (w > h) {
        scale = (float)input_size / w;
        w = input_size;
        h = h * scale;
    } else {
        scale = (float)input_size / h;
        h = input_size;
        w = w * scale;
    }
    
    ncnn::Mat ncnn_img = ncnn::Mat::from_pixels(rgbData, ncnn::Mat::PIXEL_RGBA2RGB, imageWidth,
                                      imageHeight);
    
    ncnn::Mat in = ncnn::Mat::from_pixels_resize(rgbData, ncnn::Mat::PIXEL_RGBA2RGB, imageWidth, imageHeight, w, h);
    
    std::vector<Object> objects;
    g_yoloface->detect(in, objects, imageWidth, imageHeight, scale);
    
    printf("===========%zu\n", objects.size());
    
    Face face;
    
    if (objects.size() > 0) {
        for (int i = 0; i < objects.size(); i++) {
            FaceResult face_result;
            
            float x10 = objects[i].rect.x;
            float y10 = objects[i].rect.y;
            float rwidth1 = objects[i].rect.width;
            float rheight1 = objects[i].rect.height;
            float x11 = rwidth1 + x10;
            float y11 = rheight1 + y10;
            
            face_result.face_area = BoundingBox{ x10, y10, x11, y11 };
            
            face_result.face = objects[i];
            
            face.fs.push_back(face_result);
        }
    } else {
        printf("-------------None face\n");
        
        FaceResult face_result;
        
        face.fs.push_back(face_result);
    }
    
//    BoundingBox face_area1;
//    
//    for (int i = 0; i < objects.size(); i++) {
//        float x10 = objects[i].rect.x;
//        float y10 = objects[i].rect.y;
//        float rwidth1 = objects[i].rect.width;
//        float rheight1 = objects[i].rect.height;
//        float x11 = rwidth1 + x10;
//        float y11 = rheight1 + y10;
//        
//        if (i == 0) {
//            face_area1 = BoundingBox{ x10, y10, x11, y11 };
//        }
//    }

    _listener->onDrawPoint(face);
    
    objects.clear();
    in.release();
    ncnn_img.release();
    
    return 0;
}

void reset() {
    
}

void _release() {
    reset();
}

void SmartDetector_release() {
    _release();
    
    if (_listener != nullptr) {
        std::cout << "release listener" << std::endl;
        delete _listener;
    } else {
        std::cout << "has release listener" << std::endl;
    }
    
    if (g_yoloface != nullptr) {
        std::cout << "release g_yoloface" << std::endl;
        delete g_yoloface;
    }
    
    detection_sdk_init_ok = false;
}
