public with sharing class RedditSyncService {
    public static void syncPosts() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.reddit.com/r/aww.json');
        request.setMethod('GET');
        request.setHeader('User-Agent', 'SalesforceRedditBot');

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            List<Reddit_Post__c> posts = new List<Reddit_Post__c>();

            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> children = (List<Object>) ((Map<String, Object>) jsonResponse.get('data')).get('children');

            for (Object child : children) {
                Map<String, Object> data = (Map<String, Object>) ((Map<String, Object>) child).get('data');
                Reddit_Post__c post = new Reddit_Post__c(
                    Title__c = (String) data.get('title'),
                    Author_Fullame__c = (String) data.get('author_fullname'),
                    Thumbnail__c = (String) data.get('thumbnail'),
                    Selftext__c = (String) data.get('selftext')
                );
                posts.add(post);
            }
            insert posts;
        }
    }
}
