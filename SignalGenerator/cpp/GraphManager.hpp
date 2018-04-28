//
//  GraphManager.hpp
//  SignalGenerator
//
//  Created by 橋本翔太 on 2018/04/01.
//  Copyright © 2018 hasi6363. All rights reserved.
//

#ifndef GraphManager_hpp
#define GraphManager_hpp

#include <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>
#include <AudioUnit/AudioUnit.h>
#include <iostream>
#include <string>
#include <map>

using namespace std;

class GraphManager
{
private:
    AUGraph mAuGraph;
    map<string, AUNode*> mNodeMap;
public:
    GraphManager();
    ~GraphManager();
    void initialize();
    AUNode* addNode(string key, const AudioComponentDescription* acd);
    void setCallback(string key, AURenderCallbackStruct* callback_struct);
    AUNode* getNode(string key);
    void freeNode();
    void getAudioUnit(string key, AudioUnit* au);
    void setProperty(string key, AudioUnitPropertyID inID, AudioUnitScope inScope, AudioUnitElement inElement, const void *inData, UInt32 inDataSize);
    void setASBD(string key, AudioStreamBasicDescription* asbd);
    void setEnableIO(string key, UInt32 flag);
    void connect(string src_key, UInt32 src_out_num, string dest_key, UInt32 dest_input_num);
    void start();
    void stop();
};

#endif /* GraphManager_hpp */
