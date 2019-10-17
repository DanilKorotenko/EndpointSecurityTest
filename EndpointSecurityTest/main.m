//
//  main.m
//  EndpointSecurityTest
//
//  Created by Timm Kandziora on 18.06.19.
//  Copyright © 2019 Timm Kandziora. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <EndpointSecurity/EndpointSecurity.h>

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        if (geteuid() != 0)
        {
            NSLog(@"Please run me as root ...");
            return 0;
        }

        es_client_t *client = NULL;

        es_handler_block_t message_handler =
            [^void (es_client_t *client, es_message_t *message)
            {
                NSLog(@"Received message from subscribed event! Client at %p", client);

//                NSLog(@"proc file path: %s", message->proc.file.path.data);
//                NSLog(@"proc team id: %s", message->proc.team_id.data);
//                NSLog(@"proc signing id: %s", message->proc.signing_id.data);
//                NSLog(@"proc ppid: %d", message->proc.ppid);
//                NSLog(@"proc original ppid: %d", message->proc.original_ppid);
                NSLog(@"event type: %u", message->event_type);
                NSLog(@"action type: %u", message->action_type);

                if (message->action_type == ES_ACTION_TYPE_NOTIFY)
                {
                    NSLog(@"Notify action, doing nothing ...");
                }
                else
                {
                    // It seems that for now all action types are auth or I somehow messed
                    // up accessing the action union and notifys result type

//                    if (!strcmp("/usr/libexec/xpcproxy", message->proc.file.path.data))
//                    {
//                        es_event_exec_t exec = message->event.exec;
//
//                        NSLog(@"xpcproxy is our trampoline, we really: %s",
//                            exec.proc.file.path.data);
//                    }

                    es_respond_auth_result(client, message, ES_AUTH_RESULT_ALLOW, false);
                }
            } copy];

        es_new_client_result_t client_result = es_new_client(&client, message_handler);

        if (client_result == ES_NEW_CLIENT_RESULT_SUCCESS)
        {
            NSLog(@"Successfully got new client at %p", client);
        }
        else
        {
            NSLog(@"Couldn't get new client ...");
            if (client_result == ES_NEW_CLIENT_RESULT_ERR_NOT_PERMITTED)
            {
                NSLog(@"Error: not permitted");
            }

            if (client_result == ES_NEW_CLIENT_RESULT_ERR_NOT_ENTITLED)
            {
                NSLog(@"Error: not entitled");
            }
            return 0;
        }

        es_clear_cache_result_t cache_result = es_clear_cache(client);

        if (cache_result == ES_CLEAR_CACHE_RESULT_SUCCESS)
        {
            NSLog(@"Successfully cleared cache");
        }
        else
        {
            NSLog(@"Couldn't clear cache ...");
        }

        es_event_type_t event = ES_EVENT_TYPE_AUTH_EXEC;

        es_return_t subscribe_result = es_subscribe(client, &event, 1);

        if (subscribe_result == ES_RETURN_SUCCESS)
        {
            NSLog(@"Client subscribed successfully");
        }
        else
        {
            NSLog(@"Client didn't subscribe ...");
        }

        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop run];

        es_return_t unsubscribe_result = es_unsubscribe_all(client);

        if (unsubscribe_result == ES_RETURN_SUCCESS)
        {
            NSLog(@"Successfully unsubscribed all events");
        }
        else
        {
            NSLog(@"Couldn't unsubscribe ...");
        }

        es_return_t delete_result = es_delete_client(client);

        if (delete_result == ES_RETURN_SUCCESS)
        {
            NSLog(@"Successfully deleted client. Bye then.");
        }
        else
        {
            NSLog(@"Couldn't delete client. Oh oh ...");
        }
    }

    return 0;
}
