//
//  RTMDuplicatedMessageFilter.m
//  rtm
//
//  Created by 施王兴 on 2018/1/4.
//  Copyright © 2018年 施王兴. All rights reserved.
//

#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <map>
#include <mutex>
#include <list>
#import "RTMDuplicatedMessageFilter.h"

enum MessageCategories
{
    P2PMessageType,
    GroupMessageType,
    RoomMessageType,
    BroadcastMessageType,
};

static const int expireSecond = 30 * 60;

//==========================================//
//--           Message Id Unit            --//
//==========================================//

struct MessageIdUnit
{
    enum MessageCategories messageType;
    int64_t bizId;
    int64_t uid;
    int64_t mid;
    time_t activeTime;
    
    MessageIdUnit(): messageType(P2PMessageType), bizId(0), uid(0), mid(0), activeTime(0) {}
    MessageIdUnit(enum MessageCategories messageType, int64_t bizId, int64_t uid, int64_t mid)
    {
        this->messageType = messageType;
        this->bizId = bizId;
        this->uid = uid;
        this->mid = mid;
        activeTime = time(NULL);
    }
    MessageIdUnit(const MessageIdUnit& miu)
    {
        this->messageType = miu.messageType;
        this->bizId = miu.bizId;
        this->uid = miu.uid;
        this->mid = miu.mid;
        this->activeTime = miu.activeTime;
    }
    
    inline void active()
    {
        activeTime = time(NULL);
    }
    
    const bool operator < (const MessageIdUnit& other) const
    {
        if (mid < other.mid)
            return true;
        else if (mid > other.mid)
            return false;
        
        if (uid < other.uid)
            return true;
        else if (uid > other.uid)
            return false;
        
        if (bizId < other.bizId)
            return true;
        else if (bizId > other.bizId)
            return false;
        
        if (messageType < other.messageType)
            return true;
        else
            return false;
    }
};

class MessageIdLRUCache
{
    typedef std::list<MessageIdUnit>::iterator ListIter;
    typedef std::map<MessageIdUnit, ListIter>::iterator MapIter;
    
    std::map<MessageIdUnit, ListIter> _map;
    std::list<MessageIdUnit> _list;
    std::mutex _mutex;
    size_t _maxCount;
    
private:
    void checkCount()
    {
        while (_map.size() > _maxCount)
        {
            _map.erase(_list.back());
            _list.pop_back();
        }
    }
    
    void insert(const MessageIdUnit& miu)
    {
        _list.push_front(miu);
        _map[miu] = _list.begin();
        
        checkCount();
    }
    
    void active(MapIter iter)
    {
        MessageIdUnit miu = iter->first;
        
        _list.erase(iter->second);
        _map.erase(iter);
        
        miu.active();
        
        _list.push_front(miu);
        _map[miu] = _list.begin();
    }

public:
    MessageIdLRUCache(size_t maxCount = 4096): _maxCount(maxCount) {}
    
    bool contain(const MessageIdUnit& miu)
    {
        std::lock_guard<std::mutex> lck (_mutex);
        MapIter iter = _map.find(miu);
        if (iter != _map.end())
        {
            active(iter);
            return true;
        }
        
        insert(miu);
        return false;
    }
    
    void cleanExpired()
    {
        time_t threshold = time(NULL) - expireSecond;
        
        std::lock_guard<std::mutex> lck (_mutex);
        while (_map.size() > 0)
        {
            if (_list.back().activeTime <= threshold)
            {
                _map.erase(_list.back());
                _list.pop_back();
            }
            else
                return;
        }
    }
};

//==========================================//
//--    RTM Duplicated Message Filter     --//
//==========================================//
static MessageIdLRUCache _cache;

@implementation RTMDuplicatedMessageFilter

+ (BOOL)filterP2PMessage:(int64_t)mid from:(int64_t)uid
{
    MessageIdUnit miu(P2PMessageType, 0, uid, mid);
    return !_cache.contain(miu);
}

+ (BOOL)filterGroupMessage:(int64_t)mid from:(int64_t)uid inGroup:(int64_t)groupId
{
    MessageIdUnit miu(GroupMessageType, groupId, uid, mid);
    return !_cache.contain(miu);
}

+ (BOOL)filterRoomMessage:(int64_t)mid from:(int64_t)uid inRoom:(int64_t)roomId
{
    MessageIdUnit miu(RoomMessageType, roomId, uid, mid);
    return !_cache.contain(miu);
}

+ (BOOL)filterBroadcastMessage:(int64_t)mid from:(int64_t)uid
{
    MessageIdUnit miu(BroadcastMessageType, 0, uid, mid);
    return !_cache.contain(miu);
}

+ (void)cleanExpiredCache
{
    _cache.cleanExpired();
}

@end
