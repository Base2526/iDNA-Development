//
//  ChatView.m
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import "ChatView.h"
#import "Configs.h"
#import "InviteFriends.h"
#import "MessageRepo.h"
#import "Message.h"

@interface ChatView ()

@property (strong, nonatomic) NSMutableArray *messages;
//@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubble;
//@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubble;
//@property (strong, nonatomic) JSQMessagesAvatarImage *incomingAvatar;
//@property (strong, nonatomic) JSQMessagesAvatarImage *outgoingAvatar;

@property (strong, nonatomic) MessageRepo *msRepo;
@end

@implementation ChatView
@synthesize friend, msRepo;
@synthesize ref;

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    // 自分の senderId, senderDisplayName を設定
    self.senderId = @"user1";
    self.senderDisplayName = @"classmethod";
    // MessageBubble (背景の吹き出し) を設定
    JSQMessagesBubbleImageFactory *bubbleFactory = [JSQMessagesBubbleImageFactory new];
    self.incomingBubble = [bubbleFactory  incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.outgoingBubble = [bubbleFactory  outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    // アバター画像を設定
    self.incomingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User2"] diameter:64];
    self.outgoingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User1"] diameter:64];
    // メッセージデータの配列を初期化
    self.messages = [NSMutableArray array];
    
    // hide attachment icon
    self.inputToolbar.contentView.leftBarButtonItem = nil;

    msRepo = [[MessageRepo alloc] init];
    ref = [[FIRDatabase database] reference];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"ChatView_reloadData"
                                               object:nil];
    */
    
}

/*
-(void)reloadData:(NSNotification *) notification{
    
    [self.messages removeAllObjects];
    
    NSMutableArray *all_message = [msRepo getMessageByChatId:[friend objectForKey:@"chat_id"]];
    
    
    
    
    NSInteger ichat_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"chat_id"];
    NSInteger iobject_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"object_id"];
    NSInteger itext = [msRepo.dbManager.arrColumnNames indexOfObject:@"text"];
    NSInteger isender_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"sender_id"];
    
    for (int i = 0; i < [all_message count]; i++) {
        // NSArray *item = all_message[i];
        
        NSArray * _value = [all_message objectAtIndex:i];
        NSString*text = [_value objectAtIndex:itext];
        NSString*sender_id = [_value objectAtIndex:isender_id];
        
        NSLog(@"");
 
        
        JSQMessage *message1 = nil;
        if ([[[Configs sharedInstance] getUIDU] isEqualToString:sender_id]) {
            message1 = [JSQMessage messageWithSenderId:@"user1"
                                           displayName:@"underscore"
                                                  text:text];
        }else{
            message1 = [JSQMessage messageWithSenderId:@"user2"
                                           displayName:@"underscore"
                                                  text:text];
        }
        
        [self.messages addObject:message1];
    }
    
}

#pragma mark - Auto Message

- (void)receiveAutoMessage
{
    // 1秒後にメッセージを受信する
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(didFinishMessageTimer:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)didFinishMessageTimer:(NSTimer*)timer
{
 
}

#pragma mark - JSQMessagesViewController

// Sendボタンが押下されたときに呼ばれる
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    // 効果音を再生する
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    // 新しいメッセージデータを追加する
    JSQMessage *message = [JSQMessage messageWithSenderId:senderId
                                              displayName:senderDisplayName
                                                     text:text];
    [self.messages addObject:message];
    // メッセージの送信処理を完了する (画面上にメッセージが表示される)
    [self finishSendingMessageAnimated:YES];
    // 擬似的に自動でメッセージを受信
    [self receiveAutoMessage];
    
    
 
    
    NSString *ccmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [friend objectForKey:@"chat_id"]];
    NSString *object_id = [[ref child:ccmessage] childByAutoId].key;
    
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    
    // MessageRepo *meRepo = [[MessageRepo alloc] init];
    Message* m  = [[Message alloc] init];
    m.chat_id   = [friend objectForKey:@"chat_id"];
    m.object_id = object_id;
    m.text      = text;
    m.type      = @"private";
    m.sender_id = [[Configs sharedInstance] getUIDU];
    m.receive_id = [friend objectForKey:@"friend_id"];
    m.status    = @"sending";
    m.reader    = @"";
    m.create    = [timeStampObj stringValue];
    m.update    = [timeStampObj stringValue];
    
    if([msRepo insert:m]){
        NSDictionary *_message = @{
                           @"chat_id":m.chat_id,
                           @"object_id":m.object_id,
                           @"text": m.text,
                           @"type": m.type,
                           @"sender_id" : m.sender_id,
                           @"receive_id" : m.receive_id,
                           @"status" : @"send", // สถานะการส่ง  sending(กำลังส่ง), resend(ส่งไม่สำเร็จ), send_success(ส่งสำเร็จ)
                           @"reader" : @{}, // จะเก็บ uid ของผู้เปิดอ่าน
                           @"create": [FIRServerValue timestamp],
                           @"update": [FIRServerValue timestamp]
                           };
    
        [[[ref child:ccmessage] child:object_id] setValue:_message withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
            NSString*chat_id   = ref.parent.key;
            NSString*object_id = ref.key;
            
            // MessageRepo *meRepo = [[MessageRepo alloc] init];
            NSArray*item = [msRepo get:object_id];
            
            if(item != nil){
                
 

                
                NSInteger ichat_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"chat_id"];
                NSInteger iobject_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"object_id"];
                NSInteger itext = [msRepo.dbManager.arrColumnNames indexOfObject:@"text"];
                
                NSInteger itype = [msRepo.dbManager.arrColumnNames indexOfObject:@"type"];
                NSInteger isender_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"sender_id"];
                NSInteger ireceive_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"receive_id"];
                NSInteger istatus = [msRepo.dbManager.arrColumnNames indexOfObject:@"status"];
                NSInteger ireader = [msRepo.dbManager.arrColumnNames indexOfObject:@"reader"];
                NSInteger icreate = [msRepo.dbManager.arrColumnNames indexOfObject:@"create"];
                NSInteger iupdate = [msRepo.dbManager.arrColumnNames indexOfObject:@"update"];
                
                // NSMutableArray*item2 = [meRepo get:object_id];
                
                
                
                Message* m =[[Message alloc] init];
                m.chat_id  = [item objectAtIndex:ichat_id];
                m.object_id  = [item objectAtIndex:iobject_id];
                m.text  = [item objectAtIndex:itext];
                m.type  = [item objectAtIndex:itype];
                m.sender_id  = [item objectAtIndex:isender_id];
                m.receive_id  = [item objectAtIndex:ireceive_id];
                // m.status  = item[7];
                m.reader  = [item objectAtIndex:ireader];
                m.create  = [item objectAtIndex:icreate];
                m.update  = [item objectAtIndex:iupdate];
                
                if (error == nil) {
                    m.status  = @"send_success";
                }else{
                    // error
                    m.status  = @"resend";
                }
                BOOL us = [msRepo update:m];
                NSLog(@"");
            }
        }];
    }
}

#pragma mark - JSQMessagesCollectionViewDataSource

// アイテムごとに参照するメッセージデータを返す
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

// アイテムごとの MessageBubble (背景) を返す
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubble;
    }
    return self.incomingBubble;
}

// アイテムごとのアバター画像を返す
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingAvatar;
    }
    return self.incomingAvatar;
}

#pragma mark - UICollectionViewDataSource

// アイテムの総数を返す
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (IBAction)onInvite:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InviteFriends *inviteF = [storybrd instantiateViewControllerWithIdentifier:@"InviteFriends"];
    
    // changeFN.friend_id = [item objectForKey:@"friend_id"];
    [self.navigationController pushViewController:inviteF animated:YES];
}
 */
@end

