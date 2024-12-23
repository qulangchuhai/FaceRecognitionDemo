
#include "global_listener.h"

using namespace::std;

global_listener::global_listener() {
    
}

global_listener::~global_listener() {
    drawPointsCallBack = nullptr;
    clearPointsCallBack = nullptr;
}

void global_listener::onDrawPoint(Face face) {
    if (drawPointsCallBack == nullptr) {
        cout << "no drawPointsCallBack" << endl;
        return;
    }
    
    drawPointsCallBack(face);
}

void global_listener::onClearPoints() {
    if (clearPointsCallBack == nullptr) {
        cout << "no clearPointsCallBack" << endl;
        return;
    }
    
    clearPointsCallBack();
}

void global_listener::bindDrawPointsCallback(DetectDrawPointsCallback callback) {
    drawPointsCallBack = callback;
}

void global_listener::bindClearPointsCallBack(DetectClearPointsCallBack callback) {
    clearPointsCallBack = callback;
}

void GlobalListenerWillRelease() {
    
}
