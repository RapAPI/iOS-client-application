// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from sdk_bridge.djinni

#import <Foundation/Foundation.h>

/**
 * @file
 * Lists all possible connection states
 */
typedef NS_ENUM(NSInteger, IXNConnectionState)
{
    /** initial state */
    IXNConnectionStateUnknown,
    /** This state is set if the connection was correctly established. */
    IXNConnectionStateConnected,
    /** This state is set while trying to establish a connection. */
    IXNConnectionStateConnecting,
    /**
     * This state is set in case of an unsuccessful connection operation
     * or after execution of disconnect method.
     */
    IXNConnectionStateDisconnected,
    /**
     * This state is set when the connection succeeded but the headband's
     * firmware is out of date -- if this occurs, you should instruct your users
     * to use the Muse app to upgrade their firmware.
     */
    IXNConnectionStateNeedsUpdate,
    IXNConnectionStateCount,
};
