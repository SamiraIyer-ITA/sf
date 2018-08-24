public with sharing class Group_Controller {

public boolean hasId {get; set;}
public CollaborationGroup ChatterGroup {get; set;}
public CollaborationGroup[] groups {get; set;}
public string GroupId {get; set;}
public boolean isMember {get; set;}

public User[] users {get; set;}

public Group_Controller(){
    this.GroupId = ApexPages.CurrentPage().getParameters().get('id');
    if(this.GroupId == null){
        this.hasId = false;
        this.groups = [select id, name, CanHaveGuests, Description, SmallPhotoUrl, membercount, LastFeedModifiedDate, (select id from GroupMembers) from collaborationgroup where NetworkId = :Network.getNetworkId()];
    }else{
        this.hasId = true;
        this.ChatterGroup =  [select id, name, CanHaveGuests, Description, fullphotourl, (select memberid, member.firstname, member.lastname from GroupMembers), (select title, body from feeds order by createddate desc) from collaborationgroup where id = :this.GroupId limit 1];        
        this.isMember = false;
        for(CollaborationGroupMember member : this.ChatterGroup.GroupMembers){
            if(member.memberid == UserInfo.getUserId())
                this.isMember = true;
        }
        set<id> userIds = new set<id>();
        for(CollaborationGroupFeed feed : [select id, body, createddate, createdbyid, createdby.firstname, createdby.lastname, likecount, (select id, commentbody, commenttype, createdbyid, createdby.firstname, createdby.lastname from feedcomments order by createddate asc) from CollaborationGroupFeed where parentid = :this.GroupId order by createddate desc]){
            userIds.add(feed.createdbyid);
            for(FeedComment comment : feed.feedcomments){
                userIds.add(comment.createdbyid);
            }
        }
        this.users = [select id, companyname from user where id in :userIds];
    }
    
}

@RemoteAction
Public static CollaborationGroupMember join(string groupId){
    //{CollaborationGroupId, CollaborationRole : 'Member', NotificationFrequency : 'Daily Digests'}
    CollaborationGroupMember membership = new CollaborationGroupMember();
    membership.CollaborationGroupId = groupId;
    membership.NotificationFrequency = 'D';
    membership.CollaborationRole = 'Standard';
    membership.MemberId = UserInfo.getUserId();
    upsert membership;
    return membership;
}

@RemoteAction
public static void leave(string groupId){
    CollaborationGroupMember[] member = [select id from CollaborationGroupMember where memberid = :UserInfo.getUserId() and CollaborationGroupId = :groupId limit 1];
    delete member;
}

@RemoteAction
public static CollaborationGroupFeed[] GetFeeds(Id GroupId){
    return [select id, body, createddate, createdby.firstname, createdby.lastname, likecount, (select id, commentbody, commenttype, createddate, createdby.firstname, createdby.lastname from feedcomments order by createddate asc) from collaborationgroupfeed where parentid = :GroupId order by createddate desc];
}

@RemoteAction
public static FeedItem SaveFeed(FeedItem feed){
    upsert feed;
    return [select id, body from FeedItem where id = :feed.id];
}

@RemoteAction
public static FeedComment saveReply(FeedComment reply){
    upsert reply;
    return [Select id, commentbody, parentid from FeedComment where id = :reply.id];
}

@RemoteAction
public static void addLike(string entity){
    FeedLike l = new FeedLike();
        l.FeedItemId = entity;
    insert l;
}

}